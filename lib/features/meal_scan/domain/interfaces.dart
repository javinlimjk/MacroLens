import 'models.dart';
import 'dart:typed_data';

abstract class IInferenceEngine {
  /// Initializes the model if not already loaded.
  Future<void> initialize();

  /// Runs inference on the provided image bytes.
  Future<InferenceResult> analyzeImage(Uint8List imageBytes);

  /// Releases model resources.
  Future<void> dispose();
}

abstract class IMealRepository {
  Future<void> saveMeal(MealLog meal);
  Future<List<MealLog>> getMealsForDate(DateTime date);
  Future<void> deleteMeal(String id);

  Future<void> saveDailyProgress(DailyProgress progress);
  Future<DailyProgress?> getDailyProgress(DateTime date);
}
