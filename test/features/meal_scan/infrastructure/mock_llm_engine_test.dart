import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/infrastructure/mock_multimodal_engine.dart';

void main() {
  late MockMultimodalEngine engine;

  setUp(() {
    engine = MockMultimodalEngine();
  });

  group('MockMultimodalEngine Analysis', () {
    test('Clear Match: chicken rice', () async {
      final input = MultimodalScanInput(
        imageBytes: Uint8List(0),
        userText: 'chicken rice',
      );
      final output = await engine.analyze(input);

      expect(output.dishId, 'chicken_rice');
      expect(output.signalAgreement, true);
      expect(output.modifiers, contains('add_egg'));
    });

    test('Disagreement: duck rice', () async {
      final input = MultimodalScanInput(
        imageBytes: Uint8List(0),
        userText: 'duck rice',
      );
      final output = await engine.analyze(input);

      expect(output.dishId, 'duck_rice');
      expect(output.signalAgreement, false);
      expect(output.disagreementNote, contains('Chicken Rice'));
    });

    test('Partial Info: blurry/laksa', () async {
      final input = MultimodalScanInput(
        imageBytes: Uint8List(0),
        userText: 'blurry',
      );
      final output = await engine.analyze(input);

      expect(output.dishId, 'laksa');
      expect(output.signalAgreement, true);
      expect(output.modifiers, contains('extra_noodles'));
    });

    test('OOV: chee cheong fun', () async {
      final input = MultimodalScanInput(
        imageBytes: Uint8List(0),
        userText: 'chee cheong fun',
      );
      final output = await engine.analyze(input);

      expect(output.dishId, 'unknown');
      expect(output.signalAgreement, true);
      expect(output.estimatedKcal, 350);
    });

    test('Fallback', () async {
      final input = MultimodalScanInput(
        imageBytes: Uint8List(0),
        userText: 'random food',
      );
      final output = await engine.analyze(input);

      expect(output.dishId, 'unknown');
      expect(output.estimatedKcal, 450); // Mock fallback is 450
    });
  });
}
