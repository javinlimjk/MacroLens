import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/infrastructure/gemma_native_engine.dart';

Future<void> runGemmaValidation() async {
  final engine = GemmaNativeEngine();
  print('--- Gemma 4 Real-Image Validation ---');

  try {
    await engine.initialize();
    print('✅ Gemma 4 initialized successfully.');
  } catch (e) {
    print('❌ Failed to initialize Gemma 4: $e');
    return;
  }

  final testImages = {
    'Bar Chor Mee': '/sdcard/Download/test_images/bar_chor_mee_test.png',
    'Kopi': '/sdcard/Download/test_images/kopi_test.png',
    'Chicken Rice': '/sdcard/Download/test_images/chicken_rice.png',
    'Laksa': '/sdcard/Download/test_images/laksa_test.jpg',
    'Burger & Fries': '/sdcard/Download/test_images/burger_fries_test.png',
  };

  for (final entry in testImages.entries) {
    final name = entry.key;
    final path = entry.value;

    if (!File(path).existsSync()) {
      print('⚠️ Skipping $name: File not found at $path');
      continue;
    }

    print('\nTesting: $name...');
    final bytes = await File(path).readAsBytes();
    final input = MultimodalScanInput(imageBytes: bytes, userText: '');

    final stopwatch = Stopwatch()..start();
    final result = await engine.analyze(input);
    stopwatch.stop();

    print('   Result: ${result.displayName} (${result.dishId})');
    print('   Category: ${result.category.name}');
    print('   Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%');
    print('   Latency: ${stopwatch.elapsedMilliseconds}ms');
    print('   Reasoning: ${result.reasoning}');
    if (result.uncertaintyNote != null) print('   Uncertainty: ${result.uncertaintyNote}');
  }

  await engine.dispose();
  print('\n--- Validation Complete ---');
}
