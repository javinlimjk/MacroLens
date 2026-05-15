import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/infrastructure/gemma_multimodal_engine.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Gemma 4 Real-Image Validation', (WidgetTester tester) async {
    final engine = GemmaMultimodalEngine();
    
    print('--- Gemma 4 Real-Image Validation ---');
    await engine.initialize();
    
    final testImages = {
      'Bar Chor Mee': '/sdcard/Download/test_images/bar_chor_mee_test.png',
      'Kopi': '/sdcard/Download/test_images/kopi_test.png',
      'Chicken Rice': '/sdcard/Download/test_images/chicken_rice.png',
      'Laksa': '/sdcard/Download/test_images/laksa_test.png',
      'Burger & Fries': '/sdcard/Download/test_images/burger_fries_test.png',
    };

    for (final entry in testImages.entries) {
      final name = entry.key;
      final path = entry.value;
      
      final file = File(path);
      expect(file.existsSync(), true, reason: 'Image $name not found at $path');

      print('\nTesting: $name...');
      final bytes = await file.readAsBytes();
      final input = MultimodalScanInput(imageBytes: bytes, userText: '');
      
      final result = await engine.analyze(input);

      print('   Result: ${result.displayName} (${result.dishId})');
      print('   Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%');
      print('   Reasoning: ${result.reasoning}');
    }

    await engine.dispose();
    print('\n--- Validation Complete ---');
  });
}
