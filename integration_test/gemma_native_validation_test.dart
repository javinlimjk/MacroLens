import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/infrastructure/gemma_native_engine.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Gemma 4 Native Engine Validation', () {
    testWidgets(
      'Engine initialization and single inference',
      (WidgetTester tester) async {
        final engine = GemmaNativeEngine();

        // --- Phase 1: Initialization ---
        print('Phase 1: Initializing engine...');
        await engine.initialize();
        print('ENGINE INITIALIZED SUCCESSFULLY');

        // --- Phase 2: Load a single test image ---
        const imagePath = '/data/local/tmp/chicken_rice.png';
        final file = File(imagePath);
        expect(file.existsSync(), isTrue, reason: 'Test image not found: ' + imagePath);

        final bytes = file.readAsBytesSync();
        print('Loaded image: ' + imagePath + ' (' + bytes.length.toString() + ' bytes)');

        // --- Phase 3: Run inference ---
        print('Phase 3: Starting inference...');
        final input = MultimodalScanInput(
          imageBytes: bytes,
          userText: 'Identify this food',
        );

        final result = await engine.analyze(input);

        print('');
        print('=== GEMMA 4 INFERENCE RESULT ===');
        print('Dish ID      : ' + result.dishId);
        print('Display Name : ' + result.displayName);
        print('Category     : ' + result.category.toString());
        print('Cuisine      : ' + result.reasoning);
        print('Runtime      : Native MediaPipe GenAI 0.10.35');
        print('================================');
        print('');

        // Basic validation - the engine returned a non-fallback result
        expect(result.dishId, isNotEmpty);
        expect(result.displayName, isNotEmpty);

        await engine.dispose();
        print('Engine disposed. Test complete.');
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  });
}
