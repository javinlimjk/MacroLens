import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/meal_scan_notifier.dart';
import '../domain/models.dart';

class MealScanTextInputSheet extends StatefulWidget {
  final MealScanCapturingText state;

  const MealScanTextInputSheet({super.key, required this.state});

  @override
  State<MealScanTextInputSheet> createState() => _MealScanTextInputSheetState();
}

class _MealScanTextInputSheetState extends State<MealScanTextInputSheet> {
  WidgetRef? _ref;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Confirm Dish',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'The AI thinks this is what you\'re eating. Edit if needed.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'What is this food?',
              hintText: 'e.g. Chicken Rice with extra egg',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _controller.clear(),
              ),
            ),
            onSubmitted: (val) => _submit(context),
          ),
          const SizedBox(height: 24),
          Consumer(
            builder: (context, ref, child) {
              _ref = ref;
              return ElevatedButton(
                onPressed: () => _submit(ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue to Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              );
            },
          ),
        ],
      ),
    );
  }

  void _submit(dynamic refOrContext) {
    // If it's ref (from consumer), use it directly. If context, we'd need ProviderScope.
    // In this specific structure, we pass ref to _submit from the Consumer builder.
    if (refOrContext is WidgetRef) {
      refOrContext.read(mealScanProvider.notifier).onImageCaptured(Uint8List.fromList(widget.state.imageBytes), userText: _controller.text.trim());
    } else if (_ref != null) {
      _ref!.read(mealScanProvider.notifier).onImageCaptured(Uint8List.fromList(widget.state.imageBytes), userText: _controller.text.trim());
    }
  }
}
