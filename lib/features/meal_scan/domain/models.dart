enum ConfidenceLevel { high, medium, low }

class InferenceResult {
  final List<DishGuess> topGuesses;
  final Duration inferenceLatency;
  final bool isFallback;

  InferenceResult({
    required this.topGuesses,
    required this.inferenceLatency,
    this.isFallback = false,
  });
}

class DishGuess {
  final String dishId;      
  final String name;        
  final double confidence;  
  final List<String> detectedModifiers; 

  DishGuess({
    required this.dishId,
    required this.name,
    required this.confidence,
    required this.detectedModifiers,
  });
}

class NutritionInfo {
  final int calories;
  final double protein;
  final double carbs;
  final double fats;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });

  NutritionInfo add(NutritionInfo other) {
    return NutritionInfo(
      calories: calories + other.calories,
      protein: protein + other.protein,
      carbs: carbs + other.carbs,
      fats: fats + other.fats,
    );
  }
}

class DishBaseNutrition {
  final String dishId;
  final NutritionInfo defaultPortion;
  final Map<String, NutritionInfo> modifierImpacts;

  DishBaseNutrition({
    required this.dishId,
    required this.defaultPortion,
    required this.modifierImpacts,
  });
}

enum PortionSize { small, regular, large }

class MealLog {
  final String id;
  final DateTime timestamp;
  final String? photoLocalPath;
  final String dishName;
  final PortionSize portionSize;
  final List<String> appliedModifiers;
  final NutritionInfo finalNutrition;

  MealLog({
    required this.id,
    required this.timestamp,
    this.photoLocalPath,
    required this.dishName,
    required this.portionSize,
    required this.appliedModifiers,
    required this.finalNutrition,
  });
}

class DailyProgress {
  final DateTime date;
  final NutritionInfo totalConsumed;
  final NutritionInfo targetGoals;

  DailyProgress({
    required this.date,
    required this.totalConsumed,
    required this.targetGoals,
  });
}
