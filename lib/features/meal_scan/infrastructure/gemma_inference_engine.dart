import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../core/hardware/device_capability_service.dart';
import '../../../core/errors/inference_exceptions.dart';
import '../domain/interfaces.dart';
import '../domain/models.dart';

class GemmaInferenceEngine implements IInferenceEngine {
  final DeviceCapabilityService _capabilityService;
  Interpreter? _interpreter;
  
  bool get _isInitialized => _interpreter != null;

  GemmaInferenceEngine(this._capabilityService);

  @override
  Future<void> initialize() async {
    // 1. Capability Check
    final canRun = await _capabilityService.canRunGemmaE2B();
    if (!canRun) {
      throw UnsupportedDeviceException('Device does not meet hardware requirements (Android 14+, 8GB+ RAM) to run Gemma locally.');
    }

    // 2. Model File Lookup & Interpreter Initialization
    try {
      final appSupportDir = await getApplicationSupportDirectory();
      final modelPath = '${appSupportDir.path}/models/gemma_2b.tflite';
      final modelFile = File(modelPath);

      final options = InterpreterOptions()..addDelegate(GpuDelegateV2());

      if (await modelFile.exists()) {
        _interpreter = Interpreter.fromFile(modelFile, options: options);
      } else {
        // Fallback for local developer prototyping
        try {
          _interpreter = await Interpreter.fromAsset('assets/models/gemma_2b.tflite', options: options);
        } catch (e) {
          throw ModelLoadException('Model file not found in ApplicationSupportDirectory or assets: $e');
        }
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('not found') || errorStr.contains('no such file')) {
        throw ModelLoadException('Model file not found: $e');
      } else if (errorStr.contains('allocate') || errorStr.contains('oom') || errorStr.contains('memory')) {
        throw OOMException('Failed to allocate memory for interpreter: $e');
      } else {
        throw ModelLoadException('Interpreter failed to initialize: $e');
      }
    }
  }

  @override
  Future<InferenceResult> analyzeImage(Uint8List imageBytes) async {
    if (!_isInitialized) {
      throw StateError('GemmaInferenceEngine must be initialized before calling analyzeImage.');
    }

    try {
      // 1. Decode Image
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }

      // 2. Resize
      // Using 224x224 as a standard placeholder vision input size
      final targetSize = 224;
      final resizedImage = img.copyResize(decodedImage, width: targetSize, height: targetSize);

      // 3. Normalize & Create Input Tensor (assuming Float32)
      // Model expects [1, 224, 224, 3]
      var inputTensor = List.generate(
        1,
        (i) => List.generate(
          targetSize,
          (y) => List.generate(
            targetSize,
            (x) {
              final pixel = resizedImage.getPixel(x, y);
              return [
                pixel.r / 255.0, // Normalize to 0-1
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      // 4. Determine output shape
      // We will assume a simple 1D array of floats for classification as a dummy shape
      var outputTensor = List.filled(1, List.filled(1000, 0.0)); // 1000 classes dummy

      // 5. Run inference
      _interpreter!.run(inputTensor, outputTensor);

      // 6. Map dummy output to result
      return InferenceResult(
        topGuesses: [
          DishGuess(
            dishId: 'dummy_123',
            name: 'Identified Meal',
            confidence: 0.85,
            detectedModifiers: [],
          )
        ],
        inferenceLatency: const Duration(milliseconds: 150),
      );
    } catch (e) {
      // If inference crashes due to shape mismatch or delegates, we catch and log safely
      throw Exception('Inference execution failed: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
  }
}
