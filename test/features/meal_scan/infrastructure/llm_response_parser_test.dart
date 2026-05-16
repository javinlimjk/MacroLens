import 'package:flutter_test/flutter_test.dart';
import 'package:macrolens/features/meal_scan/infrastructure/llm_response_parser.dart';

void main() {
  group('LLMResponseParser', () {
    test('Parses clean JSON correctly', () {
      final raw = '{"dishId": "chicken_rice", "signalAgreement": true, "portionMultiplier": 1.0, "modifiers": [], "estimatedKcal": 600, "reasoning": "Looks good."}';
      final output = LLMResponseParser.parse(raw);

      expect(output.dishId, 'chicken_rice');
      expect(output.signalAgreement, true);
      expect(output.isFallback, false);
    });

    test('Parses JSON wrapped in markdown code blocks', () {
      final raw = 'Here is the result:\n```json\n{"dishId": "laksa", "signalAgreement": true, "portionMultiplier": 1.0, "modifiers": ["extra_noodles"], "estimatedKcal": 750, "reasoning": "Detected laksa."}\n```\nHope this helps!';
      final output = LLMResponseParser.parse(raw);

      expect(output.dishId, 'laksa');
      expect(output.modifiers, contains('extra_noodles'));
      expect(output.isFallback, false);
    });

    test('Handles conversational prefix/suffix without code blocks', () {
      final raw = 'The dish is {"dishId": "nasi_lemak", "signalAgreement": false, "disagreementNote": "Mismatch", "reasoning": "Conflict."} according to my analysis.';
      final output = LLMResponseParser.parse(raw);

      expect(output.dishId, 'nasi_lemak');
      expect(output.signalAgreement, false);
      expect(output.isFallback, false);
    });

    test('Returns fallback for malformed JSON', () {
      final raw = '{"dishId": "incomplete_json", "signalAgre';
      final output = LLMResponseParser.parse(raw);

      expect(output.isFallback, true);
      expect(output.dishId, 'unknown');
    });

    test('Returns fallback for missing required fields', () {
      final raw = '{"something_else": "entirely"}';
      final output = LLMResponseParser.parse(raw);

      expect(output.isFallback, true);
    });
  });
}
