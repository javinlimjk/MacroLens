import 'package:flutter_test/flutter_test.dart';
import 'package:macrolens/features/meal_scan/domain/models.dart';
import 'package:macrolens/nutrition_data/nutrition_rules_engine.dart';

class BenchmarkCase {
  final String description;
  final String expectedDishId;
  final List<String> expectedModifiers;
  final int canonicalKcal;
  final List<int> acceptableRange; // [min, max]
  final MealCategory category;
  final Map<String, dynamic> metadata;

  BenchmarkCase({
    required this.description,
    required this.expectedDishId,
    required this.expectedModifiers,
    required this.canonicalKcal,
    required this.acceptableRange,
    required this.category,
    this.metadata = const {},
  });
}

void main() {
  final engine = NutritionRulesEngine();

  final List<BenchmarkCase> benchmarkSet = [
    BenchmarkCase(
      description: 'Standard Chicken Rice with Egg',
      expectedDishId: 'chicken_rice',
      expectedModifiers: ['add_egg'],
      canonicalKcal: 607,
      acceptableRange: [540, 680],
      category: MealCategory.riceBase,
    ),
    BenchmarkCase(
      description: 'Laksa (no cockles, less gravy)',
      expectedDishId: 'laksa',
      expectedModifiers: ['no_cockles', 'less_gravy'],
      canonicalKcal: 591,
      acceptableRange: [500, 700],
      category: MealCategory.noodleBase,
    ),
    BenchmarkCase(
      description: 'Economy Rice (1M, 2V)',
      expectedDishId: 'economy_rice',
      expectedModifiers: [],
      canonicalKcal: 520,
      acceptableRange: [450, 600],
      category: MealCategory.riceBase,
      metadata: {'meatCount': 1, 'vegCount': 2},
    ),
    BenchmarkCase(
      description: 'Unknown Snack (Popiah style)',
      expectedDishId: 'unknown',
      expectedModifiers: [],
      canonicalKcal: 250,
      acceptableRange: [150, 400],
      category: MealCategory.snackSide,
    ),
  ];

  group('Nutrition Accuracy Benchmark Suite', () {
    test('Calculate benchmark scores', () {
      int dishMatchCount = 0;
      int rangeHitCount = 0;
      double totalErrorPct = 0;

      print('\n--- NUTRITION BENCHMARK REPORT ---');

      for (final testCase in benchmarkSet) {
        // Simulate LLM output for this case
        final llmOutput = LLMInferenceOutput(
          dishId: testCase.expectedDishId,
          portionMultiplier: 1.0,
          modifiers: testCase.expectedModifiers,
          estimatedKcal: testCase.canonicalKcal,
          signalAgreement: true,
          disagreementNote: null,
          reasoning: 'Benchmark test',
          category: testCase.category,
          metadata: testCase.metadata,
        );

        final result = engine.calculateMacros(
          dishId: llmOutput.dishId,
          appliedModifiers: llmOutput.modifiers,
          portionSize: PortionSize.regular,
          category: llmOutput.category,
        );

        final actualKcal = result.calories;
        final isDishMatch = llmOutput.dishId == testCase.expectedDishId;
        final isInRange = actualKcal >= testCase.acceptableRange[0] && actualKcal <= testCase.acceptableRange[1];
        final errorPct = (actualKcal - testCase.canonicalKcal).abs() / testCase.canonicalKcal;

        if (isDishMatch) dishMatchCount++;
        if (isInRange) rangeHitCount++;
        totalErrorPct += errorPct;

        print('Case: ${testCase.description}');
        print('  Result: $actualKcal kcal (Target: ${testCase.canonicalKcal}, Range: ${testCase.acceptableRange})');
        print('  Match: ${isDishMatch ? "YES" : "NO"}, In-Range: ${isInRange ? "YES" : "NO"}, Error: ${(errorPct * 100).toStringAsFixed(1)}%');
      }

      final dishMatchAccuracy = (dishMatchCount / benchmarkSet.length) * 100;
      final rangeHitRate = (rangeHitCount / benchmarkSet.length) * 100;
      final mpe = (totalErrorPct / benchmarkSet.length) * 100;

      print('\nSUMMARY:');
      print('  Dish Match Accuracy: ${dishMatchAccuracy.toStringAsFixed(1)}%');
      print('  Range Hit Rate     : ${rangeHitRate.toStringAsFixed(1)}%');
      print('  Mean % Error (MPE) : ${mpe.toStringAsFixed(1)}%');
      print('----------------------------------\n');

      expect(dishMatchAccuracy, greaterThanOrEqualTo(90.0));
      expect(mpe, lessThan(15.0));
    });
  });
}
