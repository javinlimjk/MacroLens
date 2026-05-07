import 'package:isar/isar.dart';
import '../features/meal_scan/domain/interfaces.dart';
import '../features/meal_scan/domain/models.dart';
import 'models/meal_log_isar.dart';

class MealRepositoryImpl implements IMealRepository {
  final Isar isar;

  MealRepositoryImpl(this.isar);

  @override
  Future<void> saveMeal(MealLog meal) async {
    final isarMeal = MealLogIsar()
      ..domainId = meal.id
      ..timestamp = meal.timestamp
      ..photoLocalPath = meal.photoLocalPath
      ..dishName = meal.dishName
      ..portionSize = _mapPortionSizeToIsar(meal.portionSize)
      ..appliedModifiers = meal.appliedModifiers
      ..calories = meal.finalNutrition.calories
      ..protein = meal.finalNutrition.protein
      ..carbs = meal.finalNutrition.carbs
      ..fats = meal.finalNutrition.fats;

    await isar.writeTxn(() async {
      await isar.mealLogIsars.put(isarMeal);
    });
  }

  @override
  Future<List<MealLog>> getMealsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final isarMeals = await isar.mealLogIsars
        .filter()
        .timestampBetween(startOfDay, endOfDay)
        .sortByTimestampDesc()
        .findAll();

    return isarMeals.map(_mapToDomain).toList();
  }

  @override
  Future<void> deleteMeal(String id) async {
    await isar.writeTxn(() async {
      await isar.mealLogIsars.filter().domainIdEqualTo(id).deleteAll();
    });
  }

  PortionSizeIsar _mapPortionSizeToIsar(PortionSize size) {
    switch (size) {
      case PortionSize.small: return PortionSizeIsar.small;
      case PortionSize.regular: return PortionSizeIsar.regular;
      case PortionSize.large: return PortionSizeIsar.large;
    }
  }

  MealLog _mapToDomain(MealLogIsar isarModel) {
    PortionSize domainPortion;
    switch (isarModel.portionSize) {
      case PortionSizeIsar.small: domainPortion = PortionSize.small; break;
      case PortionSizeIsar.regular: domainPortion = PortionSize.regular; break;
      case PortionSizeIsar.large: domainPortion = PortionSize.large; break;
    }

    return MealLog(
      id: isarModel.domainId,
      timestamp: isarModel.timestamp,
      photoLocalPath: isarModel.photoLocalPath,
      dishName: isarModel.dishName,
      portionSize: domainPortion,
      appliedModifiers: isarModel.appliedModifiers.toList(),
      finalNutrition: NutritionInfo(
        calories: isarModel.calories,
        protein: isarModel.protein,
        carbs: isarModel.carbs,
        fats: isarModel.fats,
      ),
    );
  }

  @override
  Future<void> saveDailyProgress(DailyProgress progress) async {
    // Normalize date to start of day to ensure uniqueness
    final normalizedDate = DateTime(progress.date.year, progress.date.month, progress.date.day);
    
    final isarProgress = DailyProgressIsar()
      ..date = normalizedDate
      ..totalCalories = progress.totalConsumed.calories
      ..totalProtein = progress.totalConsumed.protein
      ..totalCarbs = progress.totalConsumed.carbs
      ..totalFats = progress.totalConsumed.fats
      ..targetCalories = progress.targetGoals.calories
      ..targetProtein = progress.targetGoals.protein
      ..targetCarbs = progress.targetGoals.carbs
      ..targetFats = progress.targetGoals.fats;

    await isar.writeTxn(() async {
      // Because date is marked as @Index(unique: true), Isar will correctly upsert by that index 
      // if we were using a manual id mapped from date, or we can find it first and set the auto-id.
      // Isar 3 auto-increment on unique index requires fetching existing ID to overwrite cleanly.
      final existing = await isar.dailyProgressIsars.filter().dateEqualTo(normalizedDate).findFirst();
      if (existing != null) {
        isarProgress.id = existing.id;
      }
      await isar.dailyProgressIsars.put(isarProgress);
    });
  }

  @override
  Future<DailyProgress?> getDailyProgress(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final isarModel = await isar.dailyProgressIsars.filter().dateEqualTo(normalizedDate).findFirst();
    
    if (isarModel == null) return null;

    return DailyProgress(
      date: isarModel.date,
      totalConsumed: NutritionInfo(
        calories: isarModel.totalCalories,
        protein: isarModel.totalProtein,
        carbs: isarModel.totalCarbs,
        fats: isarModel.totalFats,
      ),
      targetGoals: NutritionInfo(
        calories: isarModel.targetCalories,
        protein: isarModel.targetProtein,
        carbs: isarModel.targetCarbs,
        fats: isarModel.targetFats,
      ),
    );
  }
}
