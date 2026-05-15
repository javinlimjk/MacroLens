import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macrolens/features/meal_scan/application/meal_scan_notifier.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/features/meal_scan/presentation/meal_scan_confirming_sheet.dart';

void main() {
  group('MealScanConfirmingSheet Widget Tests', () {
    testWidgets('Shows agreement state correctly', (tester) async {
      final confirmingState = MealScanConfirming(
        imageBytes: [],
        llmOutput: const LLMInferenceOutput(
          dishId: 'chicken_rice',
          displayName: 'CHICKEN RICE',
          portionMultiplier: 1.0,
          modifiers: ['add_egg'],
          estimatedKcal: 670,
          signalAgreement: true,
          disagreementNote: null,
          reasoning: 'Matches perfectly.',
        ),
        resolvedNutrition: NutritionInfo(calories: 670, protein: 36, carbs: 65, fats: 27),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mealScanProvider.overrideWith(() => MockMealScanNotifier(confirmingState)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MealScanConfirmingSheet(state: confirmingState),
            ),
          ),
        ),
      );

      expect(find.text('Ready to Log'), findsOneWidget);
      expect(find.text('CHICKEN RICE'), findsOneWidget);
      expect(find.text('670'), findsOneWidget);
      expect(find.text('kcal'), findsOneWidget);
      expect(find.text('Review Required'), findsNothing);
    });

    testWidgets('Shows disagreement state with resolution options', (tester) async {
      final confirmingState = MealScanConfirming(
        imageBytes: [],
        llmOutput: const LLMInferenceOutput(
          dishId: 'duck_rice',
          displayName: 'DUCK RICE',
          portionMultiplier: 1.0,
          modifiers: [],
          estimatedKcal: 650,
          signalAgreement: false,
          disagreementNote: 'Conflict detected.',
          reasoning: 'Conflict.',
        ),
        resolvedNutrition: NutritionInfo(calories: 650, protein: 30, carbs: 60, fats: 25),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mealScanProvider.overrideWith(() => MockMealScanNotifier(confirmingState)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MealScanConfirmingSheet(state: confirmingState),
            ),
          ),
        ),
      );

      expect(find.text('Review Required'), findsOneWidget);
      expect(find.text('Conflict detected.'), findsOneWidget);
      expect(find.text('Use AI Suggestion'), findsOneWidget);
      expect(find.text('Use My Description'), findsOneWidget);
      
      // Accept button should be disabled until resolution (mock doesn't handle logic but we test state)
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });
  });
}

class MockMealScanNotifier extends MealScanNotifier {
  final MealScanState initialState;
  MockMealScanNotifier(this.initialState);

  @override
  MealScanState build() => initialState;
}
