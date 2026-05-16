import 'package:flutter_test/flutter_test.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/nutrition_data/nutrition_rules_engine.dart';

void main() {
  late NutritionRulesEngine engine;

  setUp(() {
    engine = NutritionRulesEngine();
  });

  group('NutritionRulesEngine Routing Logic', () {
    test('High confidence known dish -> dish_level_exact', () {
      final output = LLMInferenceOutput(
        dishId: 'chicken_rice',
        displayName: 'Chicken Rice',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 0,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: '',
        confidence: 0.80, // >= 0.75
        category: MealCategory.riceBase,
      );

      final result = engine.calculateMacros(
        output: output,
        portionSize: PortionSize.regular,
      );

      expect(result.decisionPath, 'dish_level_exact');
      expect(result.isEstimate, false);
      expect(result.nutrition.calories, 600); // from database
    });

    test('Medium confidence known dish -> dish_level_estimate', () {
      final output = LLMInferenceOutput(
        dishId: 'chicken_rice',
        displayName: 'Chicken Rice',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 0,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: '',
        confidence: 0.60, // between 0.40 and 0.75
        category: MealCategory.riceBase,
      );

      final result = engine.calculateMacros(
        output: output,
        portionSize: PortionSize.regular,
      );

      expect(result.decisionPath, 'dish_level_estimate');
      expect(result.isEstimate, true);
      expect(result.nutrition.calories, 600); // from database
    });

    test('Low confidence known dish -> category_level_estimate (Safety bounds applied)', () {
      final output = LLMInferenceOutput(
        dishId: 'chicken_rice',
        displayName: 'Chicken Rice',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 700,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: '',
        confidence: 0.30, // < 0.40
        category: MealCategory.riceBase,
      );

      final result = engine.calculateMacros(
        output: output,
        portionSize: PortionSize.regular,
      );

      expect(result.decisionPath, 'category_level_estimate');
      expect(result.isEstimate, true);
      // riceBase average is 550, but LLM estimated 700, so it should pick 700
      expect(result.nutrition.calories, 700);
    });

    test('Unknown dish -> category_level_estimate (Safety bounds applied)', () {
      final output = LLMInferenceOutput(
        dishId: 'unknown',
        displayName: 'Burger and Fries',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 950,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: '',
        confidence: 0.90, // Even if high confidence, it's unknown
        category: MealCategory.snackSide,
      );

      final result = engine.calculateMacros(
        output: output,
        portionSize: PortionSize.regular,
      );

      expect(result.decisionPath, 'category_level_estimate');
      expect(result.isEstimate, true);
      // snackSide avg is 250, LLM says 950 -> should be 950
      expect(result.nutrition.calories, 950);
    });

    test('Parser fallback behavior -> uses LLM estimate or generic avg', () {
      final output = LLMInferenceOutput.fallback;

      final result = engine.calculateMacros(
        output: output,
        portionSize: PortionSize.regular,
      );

      // In fallback, confidence is 0.0, so it goes to category_level_estimate
      expect(result.decisionPath, 'category_level_estimate');
      expect(result.isEstimate, true);

      // The fallback object has estimatedKcal=500.
      expect(result.nutrition.calories, 500);
    });

    test('Gross underestimate prevented (LLM guesses too low)', () {
      final output = LLMInferenceOutput(
        dishId: 'unknown',
        displayName: 'Unknown Noodle',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 150, // Gross underestimate for a noodle dish
        signalAgreement: true,
        disagreementNote: null,
        reasoning: '',
        confidence: 0.20,
        category: MealCategory.noodleBase,
      );

      final result = engine.calculateMacros(
        output: output,
        portionSize: PortionSize.regular,
      );

      expect(result.decisionPath, 'category_level_estimate');
      expect(result.isEstimate, true);
      // noodleBase avg is 500. 150 < 500, so it uses 500
      expect(result.nutrition.calories, 500);
    });
  });
}
