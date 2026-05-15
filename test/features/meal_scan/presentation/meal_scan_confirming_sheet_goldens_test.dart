import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/presentation/meal_scan_confirming_sheet.dart';

void main() {
  Widget buildTestableWidget(MealScanConfirming state) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: MealScanConfirmingSheet(state: state),
          ),
        ),
      ),
    );
  }

  MealScanConfirming createMockState({
    required String dishId,
    required double confidence,
    required InferenceSource source,
    MealCategory category = MealCategory.unknown,
    bool signalAgreement = true,
    String? disagreementNote,
  }) {
    return MealScanConfirming(
      imageBytes: [],
      llmOutput: LLMInferenceOutput(
        dishId: dishId,
        displayName: dishId.replaceAll('_', ' ').toUpperCase(),
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 500,
        signalAgreement: signalAgreement,
        disagreementNote: disagreementNote,
        reasoning: '',
        category: category,
        confidence: confidence,
        source: source,
      ),
      resolvedNutrition: NutritionInfo(calories: 500, protein: 20, carbs: 50, fats: 10),
    );
  }

  group('MealScanConfirmingSheet Goldens', () {
    testWidgets('1. Clear recognized hawker meal', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'chicken_rice',
        confidence: 0.9,
        source: InferenceSource.recognition,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_1_clear.png'));
    });

    testWidgets('2. Disagreement case', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'chicken_rice',
        confidence: 0.9,
        source: InferenceSource.disagreement,
        signalAgreement: false,
        disagreementNote: 'I detected a mismatch between the photo and your description.',
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_2_disagreement.png'));
    });

    testWidgets('3. Blurry image', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'chicken_rice',
        confidence: 0.2,
        source: InferenceSource.recognition,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_3_blurry.png'));
    });

    testWidgets('4. Parser fallback', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.parserFallback,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_4_parser_fallback.png'));
    });

    testWidgets('5. Category fallback', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.categoryFallback,
        category: MealCategory.riceBase,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_5_category_fallback.png'));
    });

    testWidgets('6. Homemade meal', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.recognition,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_6_homemade.png'));
    });

    testWidgets('7. Snack', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.recognition,
        category: MealCategory.snackSide,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_7_snack.png'));
    });

    testWidgets('8. Noodle dish', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.recognition,
        category: MealCategory.noodleBase,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_8_noodle.png'));
    });

    testWidgets('9. Rice dish', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.recognition,
        category: MealCategory.riceBase,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_9_rice.png'));
    });

    testWidgets('10. Drink', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.recognition,
        category: MealCategory.drink,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_10_drink.png'));
    });

    testWidgets('11. Low-confidence but plausible', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'nasi_lemak',
        confidence: 0.2,
        source: InferenceSource.recognition,
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_11_low_conf_plausible.png'));
    });

    testWidgets('12. Clearly wrong user text vs image', (tester) async {
      await tester.pumpWidget(buildTestableWidget(createMockState(
        dishId: 'unknown',
        confidence: 0.2,
        source: InferenceSource.disagreement,
        signalAgreement: false,
        disagreementNote: 'You typed "apple" but the image shows a burger.',
      )));
      await expectLater(find.byType(MealScanConfirmingSheet), matchesGoldenFile('goldens/scenario_12_wrong_text.png'));
    });
  });
}
