import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraLifecycleNotifier extends AutoDisposeAsyncNotifier<CameraController> {
  @override
  Future<CameraController> build() async {
    // 1. Fetch available cameras on the device
    final cameras = await availableCameras();
    
    if (cameras.isEmpty) {
      throw Exception('No cameras available on this device.');
    }

    // 2. Select the best camera (prefer back camera for meals)
    CameraDescription? selectedCamera;
    for (final camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        selectedCamera = camera;
        break;
      }
    }
    // Fallback to the first available camera (usually front or external USB)
    selectedCamera ??= cameras.first;

    // 3. Initialize the controller
    // ResolutionPreset.high gives a good balance of detail and performance for ML inference
    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // This method automatically handles OS permission requests
    await controller.initialize();
    
    // We lock orientation to portrait for MVP simplicity
    await controller.lockCaptureOrientation();

    // Setup disposal hook when provider is destroyed (e.g. user leaves the tab)
    ref.onDispose(() {
      controller.dispose();
    });

    return controller;
  }
}

final cameraLifecycleProvider = AsyncNotifierProvider.autoDispose<CameraLifecycleNotifier, CameraController>(() {
  return CameraLifecycleNotifier();
});
