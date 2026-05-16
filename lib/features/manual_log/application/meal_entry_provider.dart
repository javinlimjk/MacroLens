import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/di/providers.dart';
import '../../meal_scan/domain/models.dart';
import '../../dashboard/application/dashboard_provider.dart';

class MealEntryState {
  final DishBaseNutrition baseDish;
  final PortionSize portionSize;
  final Set<String> activeModifiers;
  final NutritionInfo currentNutrition;

  MealEntryState({
    required this.baseDish,
    required this.portionSize,
    required this.activeModifiers,
    required this.currentNutrition,
  });

  MealEntryState copyWith({
    PortionSize? portionSize,
    Set<String>? activeModifiers,
    NutritionInfo? currentNutrition,
  }) {
    return MealEntryState(
      baseDish: baseDish,
      portionSize: portionSize ?? this.portionSize,
      activeModifiers: activeModifiers ?? this.activeModifiers,
      currentNutrition: currentNutrition ?? this.currentNutrition,
    );
  }
}

class MealEntryNotifier extends AutoDisposeFamilyNotifier<MealEntryState, DishBaseNutrition> {
  @override
  MealEntryState build(DishBaseNutrition arg) {
    return MealEntryState(
      baseDish: arg,
      portionSize: PortionSize.regular,
      activeModifiers: {},
      currentNutrition: arg.defaultPortion,
    );
  }

  void setPortion(PortionSize size) {
    state = state.copyWith(portionSize: size);
    _recalculate();
  }

  void toggleModifier(String modifierKey) {
    final newSet = Set<String>.from(state.activeModifiers);
    if (newSet.contains(modifierKey)) {
      newSet.remove(modifierKey);
    } else {
      newSet.add(modifierKey);
    }
    state = state.copyWith(activeModifiers: newSet);
    _recalculate();
  }

  void _recalculate() {
    final engine = ref.read(nutritionEngineProvider);
    final calculated = engine.calculateManualMacros(
      dishId: state.baseDish.dishId,
      appliedModifiers: state.activeModifiers.toList(),
      portionSize: state.portionSize,
    );
    state = state.copyWith(currentNutrition: calculated);
  }

  Future<void> saveMeal() async {
    final repo = ref.read(mealRepositoryProvider);
    
    final formattedName = state.baseDish.dishId.replaceAll('_', ' ').toUpperCase();
    
    final mealLog = MealLog(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      dishName: formattedName,
      portionSize: state.portionSize,
      appliedModifiers: state.activeModifiers.toList(),
      finalNutrition: state.currentNutrition,
    );

    await repo.saveMeal(mealLog);
    
    // Invalidate dashboard to trigger refresh
    ref.invalidate(dashboardProvider);
  }
}

final mealEntryProvider = NotifierProvider.autoDispose.family<MealEntryNotifier, MealEntryState, DishBaseNutrition>(() {
  return MealEntryNotifier();
});
