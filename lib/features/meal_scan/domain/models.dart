
enum InferenceSource {
  recognition,      // Confident match from model
  disagreement,     // Result after resolving conflicting signals
  parserFallback,   // JSON parsing failed, used hardcoded defaults
  categoryFallback, // Category identified but specific dish unclear
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

enum MealCategory {
  riceBase,
  noodleBase,
  snackSide,
  drink,
  unknown,
}

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
/// Authoritative output from the LLM reconciliation step.
class LLMInferenceOutput {
  /// Matched dish ID from the known vocabulary, or 'unknown'.
  final String dishId;

  /// Portion size relative to a standard hawker serving (1.0 = standard).
  final double portionMultiplier;

  /// Applied modifier keys (must match NutritionRulesEngine modifier map).
  final List<String> modifiers;

  /// LLM's own calorie estimate — primary signal when dishId is 'unknown'.
  final int estimatedKcal;

  /// Whether photo and text signals pointed to the same dish.
  final bool signalAgreement;

  /// Human-readable conflict description when [signalAgreement] is false.
  final String? disagreementNote;

  /// LLM's chain-of-thought shown to the user on request.
  final String reasoning;

  /// Optional metadata for rich benchmarking (e.g., economy rice counts).
  final Map<String, dynamic> metadata;

  /// The inferred category for the dish, especially important for unknown dishes.
  final MealCategory category;

  /// User-friendly display name (e.g., "Chicken Rice", "Cheeseburger").
  final String displayName;

  /// E.g., "Chinese", "Western", "Malay", "Mixed".
  final String cuisineType;

  /// A note to the user if the model is uncertain.
  final String? uncertaintyNote;

  /// A human readable hint if estimatedKcal is derived.
  final String? kcalHint;

  /// The Inference confidence level (0.0 to 1.0).
  final double confidence;

  /// The source of the identification (recognition, fallback, etc.)
  final InferenceSource source;

  /// Raw textual output from the model (for telemetry/audit)
  final String rawOutput;

  /// Time to first token in milliseconds (for telemetry)
  final int ttftMs;

  const LLMInferenceOutput({
    required this.dishId,
    required this.displayName,
    required this.portionMultiplier,
    required this.modifiers,
    required this.estimatedKcal,
    required this.signalAgreement,
    required this.disagreementNote,
    required this.reasoning,
    this.cuisineType = 'Unknown',
    this.uncertaintyNote,
    this.kcalHint,
    this.category = MealCategory.unknown,
    this.metadata = const {},
    this.confidence = 1.0,
    this.source = InferenceSource.recognition,
    this.rawOutput = '',
    this.ttftMs = 0,
  });

  /// Safe fallback instance returned when output parsing fails.
  static const LLMInferenceOutput fallback = LLMInferenceOutput(
    dishId: 'unknown',
    displayName: 'Unrecognized Dish',
    portionMultiplier: 1.0,
    modifiers: [],
    estimatedKcal: 500,
    signalAgreement: true,
    disagreementNote: null,
    reasoning: 'System could not confidently identify this meal.',
    cuisineType: 'Unknown',
    uncertaintyNote: 'The model response was invalid or empty.',
    kcalHint: 'Average meal default.',
    category: MealCategory.unknown,
    metadata: {},
    confidence: 0.0,
    source: InferenceSource.parserFallback,
    rawOutput: 'Fallback triggered',
    ttftMs: 0,
  );

  /// Convenience getter for whether this was a system fallback.
  bool get isFallback => source == InferenceSource.parserFallback;

  /// Whether the specific dish could not be identified.
  bool get isDishUnknown => dishId == 'unknown';

  /// Returns a safe display name based on the category if the specific dish is unknown.
  String get safeDisplayName {
    if (!isDishUnknown) return displayName;
    
    switch (category) {
      case MealCategory.riceBase: return 'Rice-based Meal';
      case MealCategory.noodleBase: return 'Noodle-based Meal';
      case MealCategory.snackSide: return 'Snack or Side';
      case MealCategory.drink: return 'Beverage';
      case MealCategory.unknown: return 'Identified Meal Item';
    }
  }
}

/// Bundles the two required inputs for LLM reconciliation.
class MultimodalScanInput {
  final List<int> imageBytes;
  final String userText;

  const MultimodalScanInput({
    required this.imageBytes,
    required this.userText,
  });
}

/// User's choice when the LLM signals a disagreement.
enum DisagreementResolution {
  useAISuggestion,   // Accept LLM's dish_id
  useMyDescription,  // Override to user's typed label
  enterManually,     // Route to ManualLogScreen
}

// ── Scan State Machine ────────────────────────────────────────────────────────

/// Sealed state hierarchy for the two-stage scan pipeline.
sealed class MealScanState {
  const MealScanState();
}

/// No active scan.
class MealScanIdle extends MealScanState {
  const MealScanIdle();
}

/// Awaiting optional user text input after photo is captured.
class MealScanCapturingText extends MealScanState {
  final List<int> imageBytes;

  const MealScanCapturingText({
    required this.imageBytes,
  });
}

/// Single-stage multimodal LLM inference running.
class MealScanAnalyzing extends MealScanState {
  final List<int> imageBytes;
  final String userText;
  const MealScanAnalyzing({
    required this.imageBytes,
    required this.userText,
  });
}

/// Stage 2 complete — mandatory confirmation screen shown.
class MealScanConfirming extends MealScanState {
  final List<int> imageBytes;
  final LLMInferenceOutput llmOutput;
  final NutritionInfo resolvedNutrition;

  /// Null until the user explicitly resolves a disagreement.
  final DisagreementResolution? resolution;

  /// Optional hint when device performance is degraded (e.g. thermal throttling).
  final String? thermalHint;

  const MealScanConfirming({
    required this.imageBytes,
    required this.llmOutput,
    required this.resolvedNutrition,
    this.resolution,
    this.thermalHint,
  });

  /// Save is permitted only when there is no disagreement, or the user
  /// has chosen a resolution.
  bool get canSave =>
      llmOutput.signalAgreement || resolution != null;

  MealScanConfirming withResolution(DisagreementResolution r) =>
      MealScanConfirming(
        imageBytes: imageBytes,
        llmOutput: llmOutput,
        resolvedNutrition: resolvedNutrition,
        resolution: r,
        thermalHint: thermalHint,
      );
}

/// Meal successfully saved to the repository.
class MealScanSaved extends MealScanState {
  final MealLog savedLog;
  const MealScanSaved({required this.savedLog});
}

/// An error occurred at some stage of the pipeline.
class MealScanError extends MealScanState {
  final String message;
  /// State to restore if the user retries.
  final MealScanState? recoveryState;
  const MealScanError({required this.message, this.recoveryState});
}

