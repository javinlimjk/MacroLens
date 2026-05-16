import '../features/meal_scan/domain/models.dart';

class NutritionResult {
  final NutritionInfo nutrition;
  final bool isEstimate;
  final String decisionPath;

  NutritionResult({
    required this.nutrition,
    required this.isEstimate,
    required this.decisionPath,
  });
}

class NutritionRulesEngine {
  /// Maps a model prediction (e.g., 'chicken_rice') to its base nutrition values.
  /// Values are estimates for a standard portion.
  final Map<String, DishBaseNutrition> _database = {
    'chicken_rice': DishBaseNutrition(
      dishId: 'chicken_rice',
      defaultPortion: NutritionInfo(calories: 600, protein: 30, carbs: 65, fats: 22),
      modifierImpacts: {
        'extra_rice': NutritionInfo(calories: 200, protein: 4, carbs: 45, fats: 1),
        'less_rice': NutritionInfo(calories: -100, protein: -2, carbs: -22, fats: 0),
        'add_egg': NutritionInfo(calories: 70, protein: 6, carbs: 0, fats: 5),
        'add_meat': NutritionInfo(calories: 150, protein: 15, carbs: 0, fats: 10),
      },
    ),
    'nasi_lemak': DishBaseNutrition(
      dishId: 'nasi_lemak',
      defaultPortion: NutritionInfo(calories: 650, protein: 18, carbs: 70, fats: 30),
      modifierImpacts: {
        'extra_rice': NutritionInfo(calories: 250, protein: 3, carbs: 40, fats: 8), // coconut rice is fattier
        'add_egg': NutritionInfo(calories: 70, protein: 6, carbs: 0, fats: 5),
        'add_chicken_wing': NutritionInfo(calories: 180, protein: 12, carbs: 8, fats: 11),
      },
    ),
    'char_kway_teow': DishBaseNutrition(
      dishId: 'char_kway_teow',
      defaultPortion: NutritionInfo(calories: 740, protein: 22, carbs: 75, fats: 38),
      modifierImpacts: {
        'extra_noodles': NutritionInfo(calories: 200, protein: 4, carbs: 35, fats: 5),
        'no_cockles': NutritionInfo(calories: -30, protein: -5, carbs: -1, fats: -1),
      },
    ),
    'laksa': DishBaseNutrition(
      dishId: 'laksa',
      defaultPortion: NutritionInfo(calories: 600, protein: 25, carbs: 55, fats: 30),
      modifierImpacts: {
        'less_gravy': NutritionInfo(calories: -150, protein: -2, carbs: -5, fats: -12),
        'extra_noodles': NutritionInfo(calories: 180, protein: 5, carbs: 35, fats: 2),
      },
    ),
    'kopi': DishBaseNutrition(
      dishId: 'kopi',
      defaultPortion: NutritionInfo(calories: 120, protein: 2, carbs: 22, fats: 3), // Kopi with condensed milk
      modifierImpacts: {
        'kopi_o': NutritionInfo(calories: -60, protein: -2, carbs: -5, fats: -3), // Black with sugar
        'kopi_c': NutritionInfo(calories: -30, protein: 0, carbs: -5, fats: -1), // Evaporated milk
        'kosong': NutritionInfo(calories: -110, protein: -2, carbs: -20, fats: -3), // No sugar/milk
        'siew_dai': NutritionInfo(calories: -40, protein: 0, carbs: -10, fats: 0), // Less sugar
      },
    ),
    'roti_prata': DishBaseNutrition(
      dishId: 'roti_prata',
      defaultPortion: NutritionInfo(calories: 300, protein: 5, carbs: 35, fats: 15), // Plain prata
      modifierImpacts: {
        'add_egg': NutritionInfo(calories: 80, protein: 7, carbs: 2, fats: 5), // Egg prata difference
        'add_curry': NutritionInfo(calories: 50, protein: 1, carbs: 3, fats: 4),
      },
    ),
    'mee_goreng': DishBaseNutrition(
      dishId: 'mee_goreng',
      defaultPortion: NutritionInfo(calories: 620, protein: 18, carbs: 80, fats: 25),
      modifierImpacts: {
        'add_egg': NutritionInfo(calories: 70, protein: 6, carbs: 0, fats: 5),
        'extra_noodles': NutritionInfo(calories: 200, protein: 4, carbs: 40, fats: 5),
      },
    ),
    // ... Additional dishes (satay, fishball noodles, bcm, wanton mee, etc.)
    // For MVP phase 2, we implement the lookup logic over this extensible map.
  };

  static const double HIGH_THRESHOLD = 0.75;
  static const double LOW_THRESHOLD = 0.40;

  /// Computes the final nutritional value given the LLM output.
  NutritionResult calculateMacros({
    required LLMInferenceOutput output,
    required PortionSize portionSize,
  }) {
    NutritionInfo total;
    bool isEstimate = false;
    String decisionPath = '';

    final base = _database[output.dishId];

    if (output.dishId != 'unknown' && output.confidence >= HIGH_THRESHOLD && base != null) {
      // Dish-level exact mapping
      decisionPath = 'dish_level_exact';
      total = _applyDishModifiers(base, output.modifiers);
    } else if (output.dishId != 'unknown' && output.confidence >= LOW_THRESHOLD && base != null) {
      // Dish-level mapping but estimated due to lower confidence
      decisionPath = 'dish_level_estimate';
      isEstimate = true;
      total = _applyDishModifiers(base, output.modifiers);
    } else {
      // Category/unknown fallback
      decisionPath = 'category_level_estimate';
      isEstimate = true;

      final categoryAvg = _getAverageForCategory(output.category);

      // Safety rule: avoid gross underestimates by respecting the LLM's estimatedKcal if it's higher
      int safeKcal = categoryAvg.calories;
      if (output.estimatedKcal > safeKcal) {
        safeKcal = output.estimatedKcal;
      }

      double ratio = safeKcal / categoryAvg.calories;
      total = NutritionInfo(
        calories: safeKcal,
        protein: categoryAvg.protein * ratio,
        carbs: categoryAvg.carbs * ratio,
        fats: categoryAvg.fats * ratio,
      );
    }

    // Apply portion scaling calibrated to HPB-style ranges
    // Regular = 1.0, Small ≈ 0.75, Large ≈ 1.35
    double scale = 1.0;
    if (portionSize == PortionSize.small) scale = 0.75;
    if (portionSize == PortionSize.large) scale = 1.35;

    if (scale != 1.0) {
      total = NutritionInfo(
        calories: (total.calories * scale).round(),
        protein: (total.protein * scale),
        carbs: (total.carbs * scale),
        fats: (total.fats * scale),
      );
    }

    return NutritionResult(
      nutrition: total,
      isEstimate: isEstimate,
      decisionPath: decisionPath,
    );
  }

  NutritionInfo calculateManualMacros({
    required String dishId,
    required List<String> appliedModifiers,
    required PortionSize portionSize,
  }) {
    final base = _database[dishId];
    if (base == null) {
      return _getAverageForCategory(MealCategory.unknown);
    }

    NutritionInfo total = _applyDishModifiers(base, appliedModifiers);

    double scale = 1.0;
    if (portionSize == PortionSize.small) scale = 0.75;
    if (portionSize == PortionSize.large) scale = 1.35;

    if (scale != 1.0) {
      total = NutritionInfo(
        calories: (total.calories * scale).round(),
        protein: (total.protein * scale),
        carbs: (total.carbs * scale),
        fats: (total.fats * scale),
      );
    }
    return total;
  }

  NutritionInfo _applyDishModifiers(DishBaseNutrition base, List<String> modifiers) {
    NutritionInfo total = base.defaultPortion;
    for (final modifier in modifiers) {
      final impact = base.modifierImpacts[modifier];
      if (impact != null) {
        total = total.add(impact);
      }
    }
    return total;
  }

  NutritionInfo _getAverageForCategory(MealCategory category) {
    switch (category) {
      case MealCategory.riceBase:
        return NutritionInfo(calories: 550, protein: 15, carbs: 75, fats: 20);
      case MealCategory.noodleBase:
        return NutritionInfo(calories: 500, protein: 12, carbs: 70, fats: 18);
      case MealCategory.snackSide:
        return NutritionInfo(calories: 250, protein: 5, carbs: 30, fats: 12);
      case MealCategory.drink:
        return NutritionInfo(calories: 120, protein: 1, carbs: 22, fats: 2);
      case MealCategory.unknown:
        return NutritionInfo(calories: 400, protein: 10, carbs: 50, fats: 15); // Broad average
    }
  }

  /// Exposes available dishes for manual search fallback.
  List<DishBaseNutrition> getAvailableDishes() {
    return _database.values.toList();
  }
}
