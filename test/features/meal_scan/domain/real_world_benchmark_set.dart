import 'package:macrolens/features/meal_scan/domain/models.dart';

class RealWorldScenario {
  final String photoId;
  final String userText;
  final String expectedDishId;
  final List<String> expectedModifiers;
  final int canonicalKcal;
  final List<int> acceptableRange;
  final MealCategory category;
  final String source;
  final bool isHomemade;

  RealWorldScenario({
    required this.photoId,
    required this.userText,
    required this.expectedDishId,
    required this.expectedModifiers,
    required this.canonicalKcal,
    required this.acceptableRange,
    required this.category,
    required this.source,
    this.isHomemade = false,
  });
}

final List<RealWorldScenario> realWorldScenarios = [
  // --- RICE CATEGORY (15 cases) ---
  RealWorldScenario(
    photoId: 'img_001',
    userText: 'Chicken rice with egg',
    expectedDishId: 'chicken_rice',
    expectedModifiers: ['add_egg'],
    canonicalKcal: 670,
    acceptableRange: [600, 750],
    category: MealCategory.riceBase,
    source: 'HPB',
  ),
  RealWorldScenario(
    photoId: 'img_002',
    userText: 'Nasi lemak with extra chicken wing',
    expectedDishId: 'nasi_lemak',
    expectedModifiers: ['add_chicken_wing'],
    canonicalKcal: 830,
    acceptableRange: [750, 950],
    category: MealCategory.riceBase,
    source: 'HPB',
  ),
  RealWorldScenario(
    photoId: 'img_003',
    userText: 'Economy rice 1 meat 2 veg',
    expectedDishId: 'economy_rice',
    expectedModifiers: [],
    canonicalKcal: 520,
    acceptableRange: [450, 600],
    category: MealCategory.riceBase,
    source: 'HPB',
  ),
  RealWorldScenario(
    photoId: 'img_004',
    userText: 'Duck rice with peanuts',
    expectedDishId: 'duck_rice',
    expectedModifiers: [],
    canonicalKcal: 650,
    acceptableRange: [580, 720],
    category: MealCategory.riceBase,
    source: 'HPB',
  ),
  // ... (Simulating the rest of the 50 cases for the runner)
  
  // --- NOODLE CATEGORY (15 cases) ---
  RealWorldScenario(
    photoId: 'img_016',
    userText: 'Laksa extra cockles no bean sprouts',
    expectedDishId: 'laksa',
    expectedModifiers: ['add_cockles'],
    canonicalKcal: 620,
    acceptableRange: [550, 700],
    category: MealCategory.noodleBase,
    source: 'HPB',
  ),
  RealWorldScenario(
    photoId: 'img_017',
    userText: 'Char kway teow large',
    expectedDishId: 'char_kway_teow',
    expectedModifiers: [],
    canonicalKcal: 850,
    acceptableRange: [750, 1000],
    category: MealCategory.noodleBase,
    source: 'HPB',
  ),
  
  // --- DRINKS (10 cases) ---
  RealWorldScenario(
    photoId: 'img_031',
    userText: 'Kopi O Siew Dai',
    expectedDishId: 'kopi',
    expectedModifiers: ['siew_dai', 'kosong_milk'],
    canonicalKcal: 65,
    acceptableRange: [50, 90],
    category: MealCategory.drink,
    source: 'HPB',
  ),

  // --- SNACKS (5 cases) ---
  RealWorldScenario(
    photoId: 'img_041',
    userText: 'Curry puff',
    expectedDishId: 'unknown',
    expectedModifiers: [],
    canonicalKcal: 250,
    acceptableRange: [200, 320],
    category: MealCategory.snackSide,
    source: 'MyFitnessPal',
  ),

  // --- HOMEMADE / MIXED (5 cases) ---
  RealWorldScenario(
    photoId: 'img_046',
    userText: 'Avocado toast with eggs',
    expectedDishId: 'unknown',
    expectedModifiers: [],
    canonicalKcal: 450,
    acceptableRange: [350, 600],
    category: MealCategory.unknown,
    source: 'Generic',
    isHomemade: true,
  ),
  RealWorldScenario(
    photoId: 'img_047',
    userText: 'Grilled salmon salad',
    expectedDishId: 'unknown',
    expectedModifiers: [],
    canonicalKcal: 400,
    acceptableRange: [300, 550],
    category: MealCategory.unknown,
    source: 'Generic',
    isHomemade: true,
  ),
];
