import 'dart:typed_data';
import '../domain/interfaces.dart';
import '../domain/models.dart';

class MockInferenceEngine implements IInferenceEngine {
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    // Simulate loading model weights into memory
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<InferenceResult> analyzeImage(Uint8List imageBytes) async {
    if (!_isInitialized) {
      throw StateError('MockInferenceEngine must be initialized before calling analyzeImage.');
    }

    // Simulate heavy on-device inference computation
    await Future.delayed(const Duration(seconds: 2));

    return InferenceResult(
      inferenceLatency: const Duration(milliseconds: 2000),
      isFallback: false,
      topGuesses: [
        DishGuess(
          dishId: 'chicken_rice',
          name: 'Chicken Rice',
          confidence: 0.92,
          detectedModifiers: ['extra_rice'], // Simulated detection
        ),
        DishGuess(
          dishId: 'nasi_lemak',
          name: 'Nasi Lemak',
          confidence: 0.78,
          detectedModifiers: [],
        ),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    // Simulate releasing resources
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = false;
  }
}
