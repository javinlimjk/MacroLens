import 'dart:convert';
import '../domain/models.dart';

class LLMResponseParser {
  /// Extracts JSON from a potentially messy LLM response string.
  /// Handles markdown code blocks, conversational prefixes, and trailing text.
  static LLMInferenceOutput parse(String rawResponse) {
    try {
      final sanitized = _sanitize(rawResponse);
      if (sanitized == null) return LLMInferenceOutput.fallback;

      final Map<String, dynamic> json = jsonDecode(sanitized);
      
      // Determine confidence and source based on output content if not provided by LLM
      final rawCategory = _parseCategory(json['category']);
      final rawDishId = json['dishId']?.toString() ?? 'unknown';
      
      double confidence = _parseConfidence(json['confidence']);
      InferenceSource source = _parseSource(json['source']);
      String displayName = json['displayName'] as String? ?? rawDishId;

      if (rawDishId == 'unknown' || rawDishId == '') {
        // If dish is unknown but we have a category, it's a category fallback
        if (rawCategory != MealCategory.unknown) {
          source = InferenceSource.categoryFallback;
          confidence = (confidence > 0.5) ? 0.5 : confidence; // Cap confidence
          
          // Use a generic display name based on category
          displayName = switch (rawCategory) {
            MealCategory.riceBase => 'Rice-based Meal',
            MealCategory.noodleBase => 'Noodle-based Meal',
            MealCategory.snackSide => 'Snack or Side',
            MealCategory.drink => 'Drink',
            _ => 'Unrecognized Dish'
          };
        } else {
          source = InferenceSource.parserFallback;
          confidence = 0.0;
          displayName = 'Unrecognized Dish';
        }
      }

      return LLMInferenceOutput(
        dishId: rawDishId,
        displayName: displayName,
        portionMultiplier: (json['portionMultiplier'] as num?)?.toDouble() ?? 1.0,
        modifiers: (json['modifiers'] as List<dynamic>?)?.cast<String>() ?? [],
        estimatedKcal: (json['estimatedKcal'] as num?)?.toInt() ?? 0,
        kcalHint: json['kcalHint'] as String?,
        signalAgreement: json['signalAgreement'] as bool? ?? true,
        disagreementNote: json['disagreementNote'] as String?,
        uncertaintyNote: json['uncertaintyNote'] as String?,
        reasoning: json['reasoning'] as String? ?? 'No reasoning provided.',
        cuisineType: json['cuisineType'] as String? ?? 'Unknown',
        category: rawCategory,
        metadata: json['metadata'] as Map<String, dynamic>? ?? {},
        confidence: confidence,
        source: source,
      );
    } catch (e) {
      return LLMInferenceOutput.fallback;
    }
  }

  static MealCategory _parseCategory(dynamic category) {
    if (category == null) return MealCategory.unknown;
    final catStr = category.toString().toLowerCase();
    if (catStr.contains('rice')) return MealCategory.riceBase;
    if (catStr.contains('noodle')) return MealCategory.noodleBase;
    if (catStr.contains('snack')) return MealCategory.snackSide;
    if (catStr.contains('drink')) return MealCategory.drink;
    return MealCategory.unknown;
  }

  static double _parseConfidence(dynamic value) {
    if (value == null) return 1.0;
    if (value is num) return value.toDouble();
    final str = value.toString().toLowerCase();
    if (str.contains('low')) return 0.2;
    if (str.contains('medium')) return 0.6;
    return 1.0;
  }

  static InferenceSource _parseSource(dynamic value) {
    if (value == null) return InferenceSource.recognition;
    final str = value.toString().toLowerCase();
    if (str.contains('fallback')) return InferenceSource.parserFallback;
    if (str.contains('disagreement')) return InferenceSource.disagreement;
    if (str.contains('category')) return InferenceSource.categoryFallback;
    return InferenceSource.recognition;
  }

  static String? _sanitize(String input) {
    String text = input.trim();

    // 1. Try to find the largest block between { and }
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    
    if (start != -1 && end != -1 && end > start) {
      final possibleJson = text.substring(start, end + 1);
      
      // Basic validation: must contain at least one colon (key-value)
      if (possibleJson.contains(':')) {
        // Remove common markdown/chat clutter inside the block
        return possibleJson.replaceAll('```json', '').replaceAll('```', '').trim();
      }
    }

    return null;
  }
}
