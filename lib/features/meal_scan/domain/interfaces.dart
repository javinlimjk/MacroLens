import 'models.dart';
import 'dart:typed_data';


abstract class IMealRepository {
  Future<void> saveMeal(MealLog meal);
  Future<List<MealLog>> getMealsForDate(DateTime date);
  Future<void> deleteMeal(String id);

  Future<void> saveDailyProgress(DailyProgress progress);
  Future<DailyProgress?> getDailyProgress(DateTime date);
}

abstract class IMultimodalInferenceEngine {
  /// Prepares the on-device Multimodal LLM (e.g., MediaPipe interpreter).
  Future<void> initialize();

  /// Analyzes image and text signals into a structured output.
  Future<LLMInferenceOutput> analyze(MultimodalScanInput input);

  /// Releases resources.
  Future<void> dispose();
}
