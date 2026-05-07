import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../core/hardware/device_capability_service.dart';
import '../../../core/errors/inference_exceptions.dart';
import '../domain/interfaces.dart';
import '../domain/models.dart';

/// Model filename expected in ApplicationSupportDirectory/models/.
const _kModelFileName = 'gemma_2b.tflite';

/// Asset path used as a debug-only fallback for local prototyping.
const _kAssetFallbackPath = 'assets/models/gemma_2b.tflite';

class GemmaInferenceEngine implements IInferenceEngine {
  final DeviceCapabilityService _capabilityService;

  Interpreter? _interpreter;
  RuntimeDiagnostics? _diagnostics;

  GemmaInferenceEngine(this._capabilityService);

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

    // 2. Resolve model path.
    final appSupportDir = await getApplicationSupportDirectory();
    final modelFilePath = '${appSupportDir.path}/models/$_kModelFileName';
    final modelFile = File(modelFilePath);
    final fileExists = await modelFile.exists();

    final String resolvedSource =
        fileExists ? 'ApplicationSupportDirectory' : 'Assets Fallback';

    // 3. Try GPU then fall back to CPU.
    final (interpreter, delegateUsed) = await _buildInterpreter(
      modelFile: fileExists ? modelFile : null,
    );

    _interpreter = interpreter;

    // 4. Read tensor metadata from the loaded interpreter.
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

    try {
      // 1. Decode still image.
      final decoded = img.decodeImage(imageBytes);
      if (decoded == null) {
        throw const FormatException('Failed to decode image bytes.');
      }

      // 2. Read target dimensions from introspected tensor metadata.
      //    Shape is [batch, height, width, channels] — guard if unexpected rank.
      final inShape = _diagnostics!.inputShape;
      final targetH = inShape.length >= 3 ? inShape[1] : 224;
      final targetW = inShape.length >= 3 ? inShape[2] : 224;
      final channels = inShape.length >= 4 ? inShape[3] : 3;

      // 3. Resize.
      final resized = img.copyResize(decoded, width: targetW, height: targetH);

      // 4. Normalise to Float32 in [0, 1].
      //    PLACEHOLDER ASSUMPTION: normalisation range and channel order will
      //    need to match the actual Gemma model contract once the model is
      //    provided. Current assumption: RGB, [0.0, 1.0].
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

      // Reshape to [1, H, W, C] as a nested list expected by tflite_flutter.
      final inputTensor = inputData
          .reshape([1, targetH, targetW, channels]);

      // 5. Allocate output buffers from introspected output shapes.
      //    PLACEHOLDER ASSUMPTION: we only read the first output tensor and
      //    return a dummy result. Real output parsing is deferred.
      final outShape = _diagnostics!.outputShapes.isNotEmpty
          ? _diagnostics!.outputShapes[0]
          : [1, 1000];
      final outputCount = outShape.reduce((a, b) => a * b);
      final outputBuffer = Float32List(outputCount);
      final outputTensor = outputBuffer.reshape(outShape);

      // 6. Run inference.
      _interpreter!.run(inputTensor, outputTensor);

      stopwatch.stop();
      dev.log(
        '[GemmaEngine] analyzeImage completed in ${stopwatch.elapsedMilliseconds} ms '
        '(output parsing is a placeholder — real Gemma output mapping pending).',
        name: 'GemmaEngine',
      );

      // PLACEHOLDER: Return a dummy result until output tensor parsing matches
      // the real Gemma model's classification/detection head.
      return InferenceResult(
        topGuesses: [
          DishGuess(
            dishId: 'placeholder_001',
            name: 'Identified Meal (placeholder)',
            confidence: 0.0,
            detectedModifiers: [],
          ),
        ],
        inferenceLatency: stopwatch.elapsed,
        isFallback: true,
      );
    } on FormatException {
      rethrow;
    } catch (e) {
      throw Exception('Inference execution failed: $e');
    }
  }

  // ── Disposal ──────────────────────────────────────────────────────────────

  @override
  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
    _diagnostics = null;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Attempts GPU initialisation first, then retries with CPU on failure.
  /// Returns the interpreter and a string describing the delegate used.
  Future<(Interpreter, String)> _buildInterpreter({
    required File? modelFile,
  }) async {
    // GPU attempt.
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

    // CPU fallback.
    try {
      final cpuOptions = InterpreterOptions();
      final interpreter = await _loadInterpreter(modelFile, cpuOptions);
      dev.log('[GemmaEngine] CPU fallback initialised.', name: 'GemmaEngine');
      return (interpreter, 'CPU');
    } catch (cpuError) {
      _mapAndThrow(cpuError);
    }
  }

  /// Loads the interpreter from file if available, otherwise from asset.
  Future<Interpreter> _loadInterpreter(
    File? modelFile,
    InterpreterOptions options,
  ) async {
    if (modelFile != null) {
      return Interpreter.fromFile(modelFile, options: options);
    }
    // Debug-only asset fallback.
    try {
      return await Interpreter.fromAsset(_kAssetFallbackPath, options: options);
    } catch (e) {
      throw ModelLoadException(
        'Model file not found in ApplicationSupportDirectory or assets: $e',
      );
    }
  }

  /// Reads all tensor metadata from an already-opened interpreter.
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

  /// Maps raw tflite_flutter / IO exceptions to domain exceptions and throws.
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
