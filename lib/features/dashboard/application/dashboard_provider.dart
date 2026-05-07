import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../meal_scan/domain/models.dart';

class DashboardState {
  final DailyProgress progress;
  final List<MealLog> todaysMeals;

  DashboardState({required this.progress, required this.todaysMeals});
}

class DashboardNotifier extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    return _fetchData();
  }

  Future<DashboardState> _fetchData() async {
    final repo = ref.read(mealRepositoryProvider);
    final now = DateTime.now();

    final meals = await repo.getMealsForDate(now);
    DailyProgress? progress = await repo.getDailyProgress(now);

    if (progress == null) {
      // Initialize daily progress if it doesn't exist
      progress = DailyProgress(
        date: now,
        totalConsumed: NutritionInfo(calories: 0, protein: 0, carbs: 0, fats: 0),
        // Default target goals for MVP
        targetGoals: NutritionInfo(calories: 2000, protein: 150, carbs: 200, fats: 65),
      );
    }

    // Always recalculate totals dynamically from meals to ensure exact sync
    int cals = 0;
    double pro = 0, car = 0, fat = 0;
    for (final meal in meals) {
      cals += meal.finalNutrition.calories;
      pro += meal.finalNutrition.protein;
      car += meal.finalNutrition.carbs;
      fat += meal.finalNutrition.fats;
    }
    
    progress = DailyProgress(
      date: now,
      totalConsumed: NutritionInfo(calories: cals, protein: pro, carbs: car, fats: fat),
      targetGoals: progress.targetGoals,
    );
    
    // Sync recalculated back to db
    await repo.saveDailyProgress(progress);

    return DashboardState(progress: progress, todaysMeals: meals);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData());
  }
}

final dashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>(() {
  return DashboardNotifier();
});
