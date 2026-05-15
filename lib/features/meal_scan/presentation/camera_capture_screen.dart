import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../application/meal_scan_notifier.dart';
import '../application/camera_lifecycle_provider.dart';
import '../domain/models.dart';
import '../../../core/di/providers.dart';
import 'meal_scan_text_input_sheet.dart';
import '../presentation/meal_scan_confirming_sheet.dart';
import '../../../core/di/providers.dart';

class CameraCaptureScreen extends ConsumerWidget {
  const CameraCaptureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mealScanProvider);
    
    // Listen for state transitions to show sheets
    ref.listen(mealScanProvider, (previous, next) {
      if (next is MealScanCapturingText) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => MealScanTextInputSheet(state: next),
        );
      } else if (next is MealScanConfirming) {
        // If we were already in a sheet (AwaitingText), we might want to pop it or replace it.
        // For simplicity in this mock, we assume the previous sheet was popped or we pop it here.
        if (previous is MealScanCapturingText) {
          Navigator.pop(context); 
        }
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => MealScanConfirmingSheet(state: next),
        ).whenComplete(() {
          if (ref.read(mealScanProvider) is MealScanConfirming) {
            ref.read(mealScanProvider.notifier).reset();
          }
        });
      } else if (next is MealScanSaved) {
        if (previous is MealScanConfirming) {
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved: ${next.savedLog.dishName}')),
        );
      } else if (next is MealScanError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.message}')),
        );
      }
    });

    final lifecycleState = ref.watch(cameraLifecycleProvider);
    final isLoading = state is MealScanAnalyzing;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _RuntimeChip(runtime: ref.watch(appConfigProvider).selectedRuntime),
        centerTitle: true,
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
                  child: Text('Camera Error:\n$err', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                ),
              ),
              data: (controller) => CameraPreview(controller),
            ),
          ),
          
          // Loading Overlay
          if (isLoading)
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10 * value, sigmaY: 10 * value),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3 * value),
                      child: Center(
                        child: Transform.scale(
                          scale: 0.9 + (0.1 * value),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Analyzing with Gemma...',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          ref.read(mealScanProvider.notifier).reset();
                        },
                        icon: const Icon(Icons.close, color: Colors.grey),
                        label: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
          // Controls
          if (state is MealScanIdle)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final xfile = await picker.pickImage(source: ImageSource.gallery);
                      if (xfile != null) {
                        final bytes = await xfile.readAsBytes();
                        ref.read(mealScanProvider.notifier).onImageCaptured(bytes);
                      }
                    },
                  ),
                  FloatingActionButton(
                    onPressed: !lifecycleState.hasValue ? null : () async {
                      final controller = lifecycleState.value!;
                      final xfile = await controller.takePicture();
                      final bytes = await xfile.readAsBytes();
                      ref.read(mealScanProvider.notifier).onImageCaptured(bytes);
                    },
                    backgroundColor: Colors.teal,
                    child: const Icon(Icons.camera_alt, size: 32),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white, size: 32),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
class _RuntimeChip extends StatelessWidget {
  final InferenceRuntime runtime;
  const _RuntimeChip({required this.runtime});

  @override
  Widget build(BuildContext context) {
    final isGemma = runtime == InferenceRuntime.gemma;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isGemma ? Colors.purple : Colors.grey, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGemma ? Icons.auto_awesome : Icons.bug_report_outlined,
            size: 14,
            color: isGemma ? Colors.purpleAccent : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            isGemma ? 'GEMMA 4' : 'MOCK',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isGemma ? Colors.purpleAccent : Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
