import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/camera_scan_provider.dart';
import '../application/camera_lifecycle_provider.dart';
import '../../../core/di/providers.dart';
import '../../manual_log/presentation/meal_entry_sheet.dart';

class CameraCaptureScreen extends ConsumerWidget {
  const CameraCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(cameraScanProvider);
    final isScanning = scanState.isLoading;

    // We can listen to state changes to show a modal on success
    ref.listen(cameraScanProvider, (previous, next) {
      if (!next.isLoading && next.hasValue && next.value != null) {
        // Show success bottom sheet with results
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => _InferenceResultSheet(result: next.value!),
        ).whenComplete(() {
          // Reset the scan state when sheet is dismissed
          ref.read(cameraScanProvider.notifier).reset();
        });
      } else if (!next.isLoading && next.hasError) {
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inference failed: \${next.error}')),
        );
      }
    });

    final lifecycleState = ref.watch(cameraLifecycleProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Camera Preview Layer
          Positioned.fill(
            child: lifecycleState.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.teal)),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Camera Error:\n$err',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              data: (controller) => CameraPreview(controller),
            ),
          ),
          
          // Inference Loading Overlay Layer
          if (isScanning)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 16),
                    Text('Analyzing on-device...', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ),
            
          // Controls Layer
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                  onPressed: isScanning ? null : () {},
                ),
                FloatingActionButton(
                  onPressed: (isScanning || !lifecycleState.hasValue)
                    ? null 
                    : () async {
                        try {
                          final controller = lifecycleState.value!;
                          final xfile = await controller.takePicture();
                          final bytes = await xfile.readAsBytes();
                          ref.read(cameraScanProvider.notifier).scanImage(bytes);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to capture: $e')),
                          );
                        }
                      },
                  backgroundColor: (isScanning || !lifecycleState.hasValue) ? Colors.grey : Colors.teal,
                  child: const Icon(Icons.camera_alt, size: 32),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 32),
                  onPressed: isScanning ? null : () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InferenceResultSheet extends ConsumerWidget {
  final result;

  const _InferenceResultSheet({required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Scan Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Inference took \${result.inferenceLatency.inMilliseconds}ms', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ...result.topGuesses.map<Widget>((guess) {
            return ListTile(
              title: Text(guess.name),
              subtitle: Text('Confidence: \${(guess.confidence * 100).toStringAsFixed(1)}%'),
              trailing: const Icon(Icons.check_circle_outline, color: Colors.teal),
              onTap: () {
                // Route to meal entry sheet
                Navigator.pop(context); // Close this results sheet
                final engine = ref.read(nutritionEngineProvider);
                final baseDish = engine.getAvailableDishes().firstWhere((d) => d.dishId == guess.dishId);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => MealEntrySheet(baseDish: baseDish),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
