import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../core/hardware/device_capability_service.dart';
import '../../../core/errors/inference_exceptions.dart';
import '../domain/interfaces.dart';
import '../domain/models.dart';
import 'label_registry.dart';

// ── Tuning constants ──────────────────────────────────────────────────────────

/// Minimum confidence for a candidate to appear in results.
const _kConfidenceThreshold = 0.20;

/// Maximum number of ranked candidates to surface.
const _kTopK = 3;

// ── File/asset paths ──────────────────────────────────────────────────────────

/// Model filename expected in ApplicationSupportDirectory/models/.
const _kModelFileName = 'gemma_2b.tflite';

/// Asset path used as a debug-only fallback for local prototyping.
const _kAssetFallbackPath = 'assets/models/gemma_2b.tflite';

// ─────────────────────────────────────────────────────────────────────────────

class GemmaInferenceEngine implements IInferenceEngine {
  final DeviceCapabilityService _capabilityService;
  final LabelRegistry _labelRegistry;

  Interpreter? _interpreter;
  RuntimeDiagnostics? _diagnostics;

  GemmaInferenceEngine(this._capabilityService)
      : _labelRegistry = LabelRegistry();

  // ── Public interface ──────────────────────────────────────────────────────

  @override
  RuntimeDiagnostics? get diagnostics => _diagnostics;

  bool get _isInitialized => _interpreter != null;

  // ── Initialization ────────────────────────────────────────────────────────

  @override
  Future<void> initialize() async {
    // 1. Device capability gate.
    final canRun = await _capabilityService.canRunGemmaE2B();
    if (!canRun) {
      throw UnsupportedDeviceException(
        'Device does not meet hardware requirements '
        '(Android 14+, 8 GB RAM recommended) to run Gemma locally.',
      );
    }

    // 2. Load label registry (must succeed before interpreter is built).
    try {
      await _labelRegistry.load();
    } catch (e) {
      throw ModelLoadException('labels.json not found or invalid: $e');
    }

    // 3. Resolve model path.
    final appSupportDir = await getApplicationSupportDirectory();
    final modelFilePath = '${appSupportDir.path}/models/$_kModelFileName';
    final modelFile = File(modelFilePath);
    final fileExists = await modelFile.exists();

    final String resolvedSource =
        fileExists ? 'ApplicationSupportDirectory' : 'Assets Fallback';

    // 4. Try GPU then fall back to CPU.
    final (interpreter, delegateUsed) = await _buildInterpreter(
      modelFile: fileExists ? modelFile : null,
    );

    _interpreter = interpreter;

    // 5. Read tensor metadata from the loaded interpreter.
    _diagnostics = _introspect(
      interpreter: interpreter,
      loadedSource: resolvedSource,
      delegateUsed: delegateUsed,
    );

    dev.log('[GemmaEngine] Initialized.\n$_diagnostics', name: 'GemmaEngine');
  }

  // ── Inference ─────────────────────────────────────────────────────────────

  @override
  Future<InferenceResult> analyzeImage(Uint8List imageBytes) async {
    if (!_isInitialized) {
      throw StateError(
        'GemmaInferenceEngine must be initialized before calling analyzeImage.',
      );
    }

    final stopwatch = Stopwatch()..start();

    // 1. Decode still image.
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw const FormatException('Failed to decode image bytes.');
    }

    // 2. Read target dimensions from introspected tensor metadata.
    //    Shape expected: [batch, height, width, channels].
    final inShape = _diagnostics!.inputShape;
    final targetH = inShape.length >= 3 ? inShape[1] : 224;
    final targetW = inShape.length >= 3 ? inShape[2] : 224;
    final channels = inShape.length >= 4 ? inShape[3] : 3;

    // 3. Resize & normalise to Float32 in [0, 1].
    //    PLACEHOLDER ASSUMPTION: RGB channel order, [0.0, 1.0] normalisation.
    //    Must be confirmed against the real Gemma model contract.
    final resized = img.copyResize(decoded, width: targetW, height: targetH);
    final inputData = Float32List(targetH * targetW * channels);
    var idx = 0;
    for (var y = 0; y < targetH; y++) {
      for (var x = 0; x < targetW; x++) {
        final pixel = resized.getPixel(x, y);
        inputData[idx++] = pixel.r / 255.0;
        inputData[idx++] = pixel.g / 255.0;
        inputData[idx++] = pixel.b / 255.0;
      }
    }
    final inputTensor = inputData.reshape([1, targetH, targetW, channels]);

    // 4. Build output buffers from introspected output shapes.
    final outputCount = _diagnostics!.outputTensorCount;
    final outputBuffers = <int, Object>{};

    for (var i = 0; i < outputCount; i++) {
      final shape = _diagnostics!.outputShapes[i];
      final size = shape.fold<int>(1, (a, b) => a * b);
      outputBuffers[i] = Float32List(size).reshape(shape);
    }

    // 5. Run inference.
    try {
      _interpreter!.runForMultipleInputs([inputTensor], outputBuffers);
    } catch (e) {
      dev.log('[GemmaEngine] runForMultipleInputs failed: $e',
          name: 'GemmaEngine');
      // Surface a safe fallback rather than crashing the app.
      stopwatch.stop();
      return InferenceResult(
        topGuesses: [],
        inferenceLatency: stopwatch.elapsed,
        isFallback: true,
      );
    }

    stopwatch.stop();

    // 6. Parse primary output tensor (index 0) — logits or probabilities.
    //    Auxiliary outputs (index 1+) are logged for diagnostics only.
    if (outputCount > 1) {
      dev.log(
        '[GemmaEngine] Model exposes $outputCount output tensors. '
        'Parsing tensor[0] as class scores; auxiliary tensors logged only.',
        name: 'GemmaEngine',
      );
      for (var i = 1; i < outputCount; i++) {
        dev.log(
          '[GemmaEngine] Auxiliary output[$i] shape: '
          '${_diagnostics!.outputShapes[i]} type: ${_diagnostics!.outputTypes[i]}',
          name: 'GemmaEngine',
        );
      }
    }

    final rawBuffer = outputBuffers[0]!;
    final List<double> scores = _extractScores(rawBuffer);

    if (scores.isEmpty) {
      dev.log(
        '[GemmaEngine] Output tensor[0] has unexpected rank; returning fallback.',
        name: 'GemmaEngine',
      );
      return InferenceResult(
        topGuesses: [],
        inferenceLatency: stopwatch.elapsed,
        isFallback: true,
      );
    }

    // 7. Apply softmax if the model outputs raw logits.
    //    PLACEHOLDER ASSUMPTION: we always apply softmax here.
    //    If the model already outputs probabilities (sum ≈ 1.0) this will
    //    distort scores slightly. Confirmed once real model contract is known.
    final probabilities = _softmax(scores);

    // 8. Select top-K candidates above the confidence threshold.
    final topGuesses = _selectTopK(probabilities);

    dev.log(
      '[GemmaEngine] analyzeImage completed in ${stopwatch.elapsedMilliseconds} ms. '
      'Top guess: ${topGuesses.isNotEmpty ? topGuesses.first.name : "none"}',
      name: 'GemmaEngine',
    );

    return InferenceResult(
      topGuesses: topGuesses,
      inferenceLatency: stopwatch.elapsed,
      isFallback: false,
    );
  }

  // ── Disposal ──────────────────────────────────────────────────────────────

  @override
  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
    _diagnostics = null;
    _labelRegistry.dispose();
  }

  // ── Private: interpreter building ────────────────────────────────────────

  /// Attempts GPU initialisation first, then retries with CPU on failure.
  Future<(Interpreter, String)> _buildInterpreter({
    required File? modelFile,
  }) async {
    try {
      final gpuOptions = InterpreterOptions()..addDelegate(GpuDelegateV2());
      final interpreter = await _loadInterpreter(modelFile, gpuOptions);
      dev.log('[GemmaEngine] GPU delegate initialised.', name: 'GemmaEngine');
      return (interpreter, 'GPU');
    } catch (gpuError) {
      dev.log(
        '[GemmaEngine] GPU delegate failed ($gpuError). Retrying with CPU.',
        name: 'GemmaEngine',
      );
    }

    try {
      final cpuOptions = InterpreterOptions();
      final interpreter = await _loadInterpreter(modelFile, cpuOptions);
      dev.log('[GemmaEngine] CPU fallback initialised.', name: 'GemmaEngine');
      return (interpreter, 'CPU');
    } catch (cpuError) {
      _mapAndThrow(cpuError);
    }
  }

  Future<Interpreter> _loadInterpreter(
    File? modelFile,
    InterpreterOptions options,
  ) async {
    if (modelFile != null) {
      return Interpreter.fromFile(modelFile, options: options);
    }
    try {
      return await Interpreter.fromAsset(_kAssetFallbackPath, options: options);
    } catch (e) {
      throw ModelLoadException(
        'Model file not found in ApplicationSupportDirectory or assets: $e',
      );
    }
  }

  // ── Private: introspection ────────────────────────────────────────────────

  RuntimeDiagnostics _introspect({
    required Interpreter interpreter,
    required String loadedSource,
    required String delegateUsed,
  }) {
    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = List<int>.from(inputTensor.shape);
    final inputType = inputTensor.type.toString();

    final outputCount = interpreter.getOutputTensors().length;
    final outputShapes = <List<int>>[];
    final outputTypes = <String>[];

    for (var i = 0; i < outputCount; i++) {
      final t = interpreter.getOutputTensor(i);
      outputShapes.add(List<int>.from(t.shape));
      outputTypes.add(t.type.toString());
    }

    return RuntimeDiagnostics(
      loadedSource: loadedSource,
      delegateUsed: delegateUsed,
      inputShape: inputShape,
      inputType: inputType,
      outputTensorCount: outputCount,
      outputShapes: outputShapes,
      outputTypes: outputTypes,
    );
  }

  // ── Private: output parsing ───────────────────────────────────────────────

  /// Flattens the raw output buffer into a 1-D list of doubles.
  /// Returns an empty list if the buffer cannot be parsed.
  List<double> _extractScores(Object rawBuffer) {
    try {
      // tflite_flutter returns a nested List<dynamic> for multi-dim tensors.
      // The primary output is typically [[score0, score1, ...]].
      if (rawBuffer is List) {
        final inner = rawBuffer.first;
        if (inner is List) {
          return inner.cast<double>();
        }
        return rawBuffer.cast<double>();
      }
    } catch (_) {}
    return [];
  }

  /// Applies softmax to raw logit scores.
  List<double> _softmax(List<double> logits) {
    if (logits.isEmpty) return [];
    final maxLogit = logits.reduce(math.max);
    final exps = logits.map((v) => math.exp(v - maxLogit)).toList();
    final sumExps = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sumExps).toList();
  }

  /// Returns up to [_kTopK] [DishGuess] objects whose confidence exceeds
  /// [_kConfidenceThreshold], ranked highest first.
  List<DishGuess> _selectTopK(List<double> probabilities) {
    // Build index-score pairs.
    final indexed = List.generate(
      probabilities.length,
      (i) => (index: i, score: probabilities[i]),
    );

    // Sort descending.
    indexed.sort((a, b) => b.score.compareTo(a.score));

    // Take top-K above threshold.
    return indexed
        .take(_kTopK)
        .where((e) => e.score >= _kConfidenceThreshold)
        .map((e) => DishGuess(
              dishId: _labelRegistry.labelAt(e.index),
              name: _formatName(_labelRegistry.labelAt(e.index)),
              confidence: e.score,
              detectedModifiers: [],
            ))
        .toList();
  }

  /// Converts a snake_case dish ID to a human-readable title.
  String _formatName(String dishId) =>
      dishId.replaceAll('_', ' ').split(' ').map((w) {
        if (w.isEmpty) return w;
        return w[0].toUpperCase() + w.substring(1);
      }).join(' ');

  // ── Private: error mapping ────────────────────────────────────────────────

  Never _mapAndThrow(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('not found') || msg.contains('no such file')) {
      throw ModelLoadException('Model file not found: $e');
    } else if (msg.contains('allocate') ||
        msg.contains('oom') ||
        msg.contains('memory')) {
      throw OOMException('Failed to allocate memory for interpreter: $e');
    } else {
      throw ModelLoadException('Interpreter failed to initialize: $e');
    }
  }
}
