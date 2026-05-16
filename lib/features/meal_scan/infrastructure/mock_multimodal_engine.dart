import '../domain/interfaces.dart';
import '../domain/models.dart';

class MockMultimodalEngine implements IMultimodalInferenceEngine {
  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> dispose() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<LLMInferenceOutput> analyze(MultimodalScanInput input) async {
    String text = input.userText.toLowerCase();
    final size = input.imageBytes.length;

    // If no user text, simulate visual identification based on "image hint" (file size)
    if (text.isEmpty) {
      if (size > 800000) text = 'satay';
      else if (size > 700000) text = 'laksa';
      else if (size > 400000) text = 'chicken rice';
      else if (size > 120000) text = 'mee pok';
      else if (size > 90000) text = 'kopi o';
      else text = 'chicken rice'; // Best guess fallback
    }

    // 1. OOV Case: Chee Cheong Fun
    if (text.contains('chee cheong fun')) {
      return const LLMInferenceOutput(
        dishId: 'unknown',
        displayName: 'Chee Cheong Fun',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 350,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'Chee Cheong Fun detected (not in primary catalog). Estimated ~350 kcal.',
        cuisineType: 'Chinese',
        uncertaintyNote: 'Not in hawker database. Falling back to category estimation.',
        kcalHint: 'Based on generic rice noodle rolls.',
        category: MealCategory.riceBase,
        confidence: 0.2,
        source: InferenceSource.categoryFallback,
      );
    }

    // 2. Disagreement Case: Duck Rice vs Chicken Rice (Mocking image as Chicken Rice)
    if (text.contains('duck rice')) {
      return const LLMInferenceOutput(
        dishId: 'duck_rice',
        displayName: 'Duck Rice',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 650,
        signalAgreement: false,
        disagreementNote: 'The photo appears to be Chicken Rice, but you typed Duck Rice.',
        reasoning: 'Visual features (light meat, oily rice) strongly suggest chicken_rice, which conflicts with the user label.',
        cuisineType: 'Chinese',
        confidence: 0.6,
        source: InferenceSource.disagreement,
      );
    }

    // 3. Partial Info Case: Blurry Laksa
    if (text.contains('blurry') || text.contains('laksa')) {
      return const LLMInferenceOutput(
        dishId: 'laksa',
        displayName: 'Laksa',
        portionMultiplier: 1.0,
        modifiers: ['extra_noodles', 'no_cockles'],
        estimatedKcal: 750,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'Image is blurry, but the orange broth suggests Laksa. Deferring to user text for specific modifiers.',
        cuisineType: 'Local',
        confidence: 0.6,
        source: InferenceSource.recognition,
      );
    }

    // 4. Mee Pok
    if (text.contains('mee pok') || text.contains('minced meat')) {
      return const LLMInferenceOutput(
        dishId: 'bak_chor_mee',
        displayName: 'Bak Chor Mee',
        portionMultiplier: 1.0,
        modifiers: ['add_vinegar', 'minced_pork'],
        estimatedKcal: 520,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'Detected Mee Pok (Bak Chor Mee). Minced pork and vinegar noted as modifiers.',
        cuisineType: 'Local',
      );
    }

    // 5. Pasta
    if (text.contains('pasta') || text.contains('spaghetti')) {
      return const LLMInferenceOutput(
        dishId: 'unknown',
        displayName: 'Spaghetti with Meat Sauce',
        portionMultiplier: 1.0,
        modifiers: ['tomato_sauce'],
        estimatedKcal: 600,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'Detected Spaghetti with tomato-based meat sauce.',
        cuisineType: 'Western',
        uncertaintyNote: 'Western food detected. Using category fallback.',
        kcalHint: 'Generic pasta calorie average.',
        category: MealCategory.noodleBase,
        source: InferenceSource.categoryFallback,
      );
    }

    // 5.5 Burger and Fries (Out-of-Domain case)
    if (text.contains('burger') || text.contains('fries')) {
      return const LLMInferenceOutput(
        dishId: 'unknown',
        displayName: 'Cheeseburger & Fries',
        portionMultiplier: 1.0,
        modifiers: [],
        estimatedKcal: 850,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'Visual features show a cheeseburger with a side of french fries.',
        cuisineType: 'Western',
        uncertaintyNote: 'Western food detected. Using category fallback.',
        kcalHint: 'Generic snack/fast food average.',
        category: MealCategory.snackSide,
        source: InferenceSource.categoryFallback,
        confidence: 0.9,
      );
    }

    // 7. Satay
    if (text.contains('satay')) {
      return const LLMInferenceOutput(
        dishId: 'satay',
        displayName: 'Satay (10 sticks)',
        portionMultiplier: 1.0,
        modifiers: ['peanut_sauce'],
        estimatedKcal: 380,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'The image shows grilled meat skewers (Satay) with peanut sauce.',
        cuisineType: 'Local',
        confidence: 0.95,
        source: InferenceSource.recognition,
      );
    }

    // 6. Clear Match: Chicken Rice
    if (text.contains('chicken rice')) {
      return const LLMInferenceOutput(
        dishId: 'chicken_rice',
        displayName: 'Chicken Rice',
        portionMultiplier: 1.0,
        modifiers: ['add_egg'],
        estimatedKcal: 670,
        signalAgreement: true,
        disagreementNote: null,
        reasoning: 'The image clearly shows Hainanese chicken rice with a braised egg, matching the user description.',
        cuisineType: 'Local',
      );
    }

    // Default Fallback
    return const LLMInferenceOutput(
      dishId: 'unknown',
      displayName: 'Meal Item',
      portionMultiplier: 1.0,
      modifiers: [],
      estimatedKcal: 450,
      signalAgreement: true,
      disagreementNote: null,
      reasoning: 'Unclear image, identification confidence is low.',
      cuisineType: 'Unknown',
      uncertaintyNote: 'Failed to identify dish. Try scanning again.',
      kcalHint: 'Safe fallback generic estimate.',
      category: MealCategory.unknown,
      confidence: 0.0,
      source: InferenceSource.parserFallback,
    );
  }
}
