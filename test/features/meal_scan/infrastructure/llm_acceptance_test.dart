import 'package:flutter_test/flutter_test.dart';
import 'package:macrolens/features/meal_scan/infrastructure/llm_response_parser.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';

void main() {
  group('LLM Acceptance Suite (Prompt Version: 1.0.0-PROD)', () {

    test('Case 1: Clear Match (Chicken Rice)', () {
      const rawOutput = '''
```json
{
  "dishId": "chicken_rice",
  "portionMultiplier": 1.0,
  "modifiers": ["add_egg"],
  "estimatedKcal": 670,
  "signalAgreement": true,
  "disagreementNote": null,
  "reasoning": "The image clearly shows a standard portion of Hainanese chicken rice with a side of braised egg."
}
```
''';
      final output = LLMResponseParser.parse(rawOutput);

      expect(output.dishId, equals('chicken_rice'));
      expect(output.signalAgreement, isTrue);
      expect(output.modifiers, contains('add_egg'));
      expect(output.isFallback, isFalse);
    });

    test('Case 2: Disagreement (CTK vs Duck Rice)', () {
      const rawOutput = '''
I detected a conflict.
{
  "dishId": "char_kway_teow",
  "portionMultiplier": 1.0,
  "modifiers": [],
  "estimatedKcal": 740,
  "signalAgreement": false,
  "disagreementNote": "The photo appears to be Char Kway Teow, but you described it as Duck Rice.",
  "reasoning": "I detected flat rice noodles and cockles typical of Char Kway Teow."
}
''';
      final output = LLMResponseParser.parse(rawOutput);

      expect(output.dishId, equals('char_kway_teow'));
      expect(output.signalAgreement, isFalse);
      expect(output.disagreementNote, contains('Char Kway Teow'));
      expect(output.isFallback, isFalse);
    });

    test('Case 3: Partial Information (Blurry Laksa)', () {
      const rawOutput = '''
```json
{
  "dishId": "laksa",
  "portionMultiplier": 1.0,
  "modifiers": ["extra_noodles", "no_cockles"],
  "estimatedKcal": 750,
  "signalAgreement": true,
  "disagreementNote": null,
  "reasoning": "The image is blurry but consistent with Laksa. Deferring to user description."
}
```
''';
      final output = LLMResponseParser.parse(rawOutput);

      expect(output.dishId, equals('laksa'));
      expect(output.signalAgreement, isTrue);
      expect(output.modifiers, containsAll(['extra_noodles', 'no_cockles']));
    });

    test('Case 4: Out-of-Vocabulary (Chee Cheong Fun)', () {
      const rawOutput = '''
{"dishId": "unknown", "portionMultiplier": 1.0, "modifiers": [], "estimatedKcal": 350, "signalAgreement": true, "disagreementNote": null, "reasoning": "Chee Cheong Fun is not in my primary catalog."}
''';
      final output = LLMResponseParser.parse(rawOutput);

      expect(output.dishId, equals('unknown'));
      expect(output.estimatedKcal, equals(350));
      expect(output.signalAgreement, isTrue);
    });

    test('Contract Enforcement: Shape Consistency', () {
      // Ensure that even with different text, the parser returns a valid object
      final outputs = [
        LLMResponseParser.parse('{"dishId": "kopi", "signalAgreement": true}'),
        LLMResponseParser.parse('{"dishId": "satay", "signalAgreement": true}')
      ];

      for (var o in outputs) {
        expect(o, isA<LLMInferenceOutput>());
        expect(o.isFallback, isFalse);
      }
    });
  });
}
