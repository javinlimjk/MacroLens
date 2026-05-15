import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/telemetry/telemetry_logger.dart';
import '../../../core/di/providers.dart';
import '../domain/models.dart';

class MealScanNotifier extends AutoDisposeNotifier<MealScanState> {
  @override
  MealScanState build() => const MealScanIdle();

  /// Stage 1: Run the LLM directly on the captured image for identification.
  Future<void> onImageCaptured(Uint8List imageBytes, {String userText = ''}) async {
    state = MealScanAnalyzing(imageBytes: imageBytes, userText: userText);

    final stopwatch = Stopwatch()..start();
    try {
      final engine = ref.read(multimodalEngineProvider);
      await engine.initialize();

      final output = await engine.analyze(MultimodalScanInput(
        imageBytes: imageBytes,
        userText: userText,
      ));
      print('DEBUG: LLM result: ${output.dishId}, kcal: ${output.estimatedKcal}');

      stopwatch.stop();
      final latency = stopwatch.elapsedMilliseconds;
      
      String? thermalHint;
      if (latency > 4000) {
        thermalHint = 'Device is warm; analysis may be slower than usual.';
      }

      final nutritionEngine = ref.read(nutritionEngineProvider);
      final pSize = _multiplierToPortion(output.portionMultiplier);

      final resolvedResult = nutritionEngine.calculateMacros(
        output: output,
        portionSize: pSize,
      );

      final resolvedNutrition = resolvedResult.nutrition;

      TelemetryLogger().logScan(
        source: output.source,
        confidence: output.confidence,
        ttftMs: output.ttftMs,
        latencyMs: latency,
        decisionPath: resolvedResult.decisionPath,
        isParserFallback: output.source == InferenceSource.parserFallback,
        isCategoryFallback: output.source == InferenceSource.categoryFallback,
        rawOutput: output.rawOutput.length > 500 ? output.rawOutput.substring(0, 500) : output.rawOutput,
      );

      state = MealScanConfirming(
        imageBytes: imageBytes,
        llmOutput: output,
        resolvedNutrition: resolvedNutrition,
        thermalHint: thermalHint,
      );
    } catch (e) {
      state = MealScanError(
        message: 'Analysis failed: ${e.toString()}',
        recoveryState: const MealScanIdle(),
      );
    }
  }

  // State transition to text input if user decides to add text later
  void enterTextMode() {
    final currentState = state;
    if (currentState is MealScanConfirming) {
      state = MealScanCapturingText(imageBytes: currentState.imageBytes);
    }
  }

  /// User selects how to resolve a disagreement.
  void resolveDisagreement(DisagreementResolution resolution) {
    final currentState = state;
    if (currentState is MealScanConfirming) {
      state = currentState.withResolution(resolution);
    }
  }

  /// Final Step: Save the confirmed meal to the repository.
  Future<void> saveConfirmedMeal() async {
    final currentState = state;
    if (currentState is! MealScanConfirming || !currentState.canSave) return;

    try {
      final repository = ref.read(mealRepositoryProvider);
      
      final mealLog = MealLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        dishName: currentState.llmOutput.displayName,
        portionSize: _multiplierToPortion(currentState.llmOutput.portionMultiplier),
        appliedModifiers: currentState.llmOutput.modifiers,
        finalNutrition: currentState.resolvedNutrition,
        // photoLocalPath: ... (would save to disk in real implementation)
      );

      await repository.saveMeal(mealLog);
      state = MealScanSaved(savedLog: mealLog);
    } catch (e) {
      state = MealScanError(message: 'Save failed: ${e.toString()}', recoveryState: currentState);
    }
  }

  PortionSize _multiplierToPortion(double multiplier) {
    if (multiplier < 0.9) return PortionSize.small;
    if (multiplier > 1.1) return PortionSize.large;
    return PortionSize.regular;
  }

  void reset() {
    state = const MealScanIdle();
  }
}

final mealScanProvider = NotifierProvider.autoDispose<MealScanNotifier, MealScanState>(() {
  return MealScanNotifier();
});
