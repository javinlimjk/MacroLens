import 'dart:io';
import 'package:isar/isar.dart';
import '../../database/meal_repository_impl.dart';
import '../../database/models/meal_log_isar.dart';
import '../../database/photo_cleanup_worker.dart';
import '../../features/meal_scan/domain/models.dart';

class DatabaseVerificationPath {
  static Future<void> verifyAllFlows(Isar isar) async {
    print('--- Starting DB Verification Flow ---');
    final repo = MealRepositoryImpl(isar);
    final worker = PhotoCleanupWorker(isar);

    // 1. SAVE MEAL
    final dummyMealId = 'debug_meal_1';
    final now = DateTime.now();
    final meal = MealLog(
      id: dummyMealId,
      timestamp: now,
      photoLocalPath: null, // Will test file later
      dishName: 'Chicken Rice',
      portionSize: PortionSize.regular,
      appliedModifiers: ['extra_rice'],
      finalNutrition: NutritionInfo(calories: 800, protein: 34, carbs: 110, fats: 23),
    );
    await repo.saveMeal(meal);
    print('1. Save Meal: SUCCESS');

    // 2. READ TODAY'S MEALS
    final todaysMeals = await repo.getMealsForDate(now);
    if (todaysMeals.any((m) => m.id == dummyMealId)) {
      print('2. Read Today\'s Meals: SUCCESS (Found ${todaysMeals.length} meals)');
    } else {
      print('2. Read Today\'s Meals: FAILED (Did not find meal)');
    }

    // 3. DELETE MEAL
    await repo.deleteMeal(dummyMealId);
    final afterDelete = await repo.getMealsForDate(now);
    if (!afterDelete.any((m) => m.id == dummyMealId)) {
      print('3. Delete Meal: SUCCESS');
    } else {
      print('3. Delete Meal: FAILED');
    }

    // 4. CLEANUP WORKER
    // Create a dummy file and a 31-day old meal
    final tempDir = Directory.systemTemp;
    final dummyFile = File('${tempDir.path}/dummy_macro_photo.jpg');
    if (!await dummyFile.exists()) {
      await dummyFile.writeAsString('fake image data');
    }

    final oldMeal = MealLog(
      id: 'old_meal_1',
      timestamp: now.subtract(const Duration(days: 31)),
      photoLocalPath: dummyFile.path,
      dishName: 'Old Meal',
      portionSize: PortionSize.regular,
      appliedModifiers: [],
      finalNutrition: NutritionInfo(calories: 0, protein: 0, carbs: 0, fats: 0),
    );
    await repo.saveMeal(oldMeal);

    print('4. Running Cleanup Worker...');
    await worker.runCleanup();

    // Verify file is gone and DB path is null
    final fileStillExists = await dummyFile.exists();
    final isarOldMeal = await isar.mealLogIsars.filter().domainIdEqualTo('old_meal_1').findFirst();

    if (!fileStillExists && (isarOldMeal == null || isarOldMeal.photoLocalPath == null)) {
      print('4. Cleanup Worker: SUCCESS (File deleted and path nullified)');
    } else {
      print('4. Cleanup Worker: FAILED (FileExists: \$fileStillExists, DBPath: \${isarOldMeal?.photoLocalPath})');
    }

    // Clean up the dummy old meal to avoid cluttering actual DB
    await repo.deleteMeal('old_meal_1');
    print('--- DB Verification Flow Complete ---');
  }
}
