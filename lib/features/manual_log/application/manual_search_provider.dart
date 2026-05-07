import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../../meal_scan/domain/models.dart';

class ManualSearchNotifier extends Notifier<List<DishBaseNutrition>> {
  String _query = '';

  @override
  List<DishBaseNutrition> build() {
    return _getDishes();
  }

  void updateQuery(String query) {
    _query = query.toLowerCase();
    state = _getDishes();
  }

  List<DishBaseNutrition> _getDishes() {
    final engine = ref.read(nutritionEngineProvider);
    final allDishes = engine.getAvailableDishes();
    if (_query.isEmpty) {
      return allDishes;
    }
    return allDishes.where((dish) {
      // In a real app we'd search a 'name' field, but currently we only have 'dishId' in DishBaseNutrition.
      // We format 'chicken_rice' -> 'chicken rice' for simple matching.
      final formattedName = dish.dishId.replaceAll('_', ' ').toLowerCase();
      return formattedName.contains(_query);
    }).toList();
  }
}

final manualSearchProvider = NotifierProvider<ManualSearchNotifier, List<DishBaseNutrition>>(() {
  return ManualSearchNotifier();
});
