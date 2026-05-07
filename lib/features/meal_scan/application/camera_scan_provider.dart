import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../domain/models.dart';

class CameraScanNotifier extends AutoDisposeAsyncNotifier<InferenceResult?> {
  @override
  Future<InferenceResult?> build() async {
    // Initial state is no result and not loading
    return null;
  }

  Future<void> scanImage(Uint8List imageBytes) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final engine = ref.read(inferenceEngineProvider);
      
      // We lazily initialize the engine here
      await engine.initialize();
      
      // Pass the real bytes to the engine
      final result = await engine.analyzeImage(imageBytes);
      
      // Cleanup for mock purposes
      await engine.dispose();
      
      return result;
    });
  }
  
  void reset() {
    state = const AsyncValue.data(null);
  }
}

final cameraScanProvider = AsyncNotifierProvider.autoDispose<CameraScanNotifier, InferenceResult?>(() {
  return CameraScanNotifier();
});
