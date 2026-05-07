import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../database/meal_repository_impl.dart';
import '../../features/meal_scan/domain/interfaces.dart';
import '../../features/meal_scan/infrastructure/mock_inference_engine.dart';
import '../../features/meal_scan/infrastructure/gemma_inference_engine.dart';
import '../../nutrition_data/nutrition_rules_engine.dart';
import '../hardware/device_capability_service.dart';

/// Provider for the Isar instance. Must be overridden in ProviderScope at app startup.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden in main()');
});

/// Provider for the Meal Repository
final mealRepositoryProvider = Provider<IMealRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return MealRepositoryImpl(isar);
});

/// Provider for the Nutrition Rules Engine
final nutritionEngineProvider = Provider<NutritionRulesEngine>((ref) {
  return NutritionRulesEngine();
});

/// Defines the available inference runtimes for the application.
enum InferenceRuntime {
  mock,
  gemma,
}

/// Provider for App Configuration (e.g., Debug toggles)
class AppConfig {
  final InferenceRuntime selectedRuntime;
  const AppConfig({this.selectedRuntime = InferenceRuntime.mock});
  
  AppConfig copyWith({InferenceRuntime? selectedRuntime}) {
    return AppConfig(selectedRuntime: selectedRuntime ?? this.selectedRuntime);
  }
}

class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() => const AppConfig();

  void setRuntime(InferenceRuntime runtime) {
    state = state.copyWith(selectedRuntime: runtime);
  }
}

final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfig>(() {
  return AppConfigNotifier();
});

/// Provider for the Inference Engine (Mock or Gemma depending on config)
final inferenceEngineProvider = Provider<IInferenceEngine>((ref) {
  final config = ref.watch(appConfigProvider);
  
  switch (config.selectedRuntime) {
    case InferenceRuntime.gemma:
      final capabilityService = DeviceCapabilityService();
      return GemmaInferenceEngine(capabilityService);
    case InferenceRuntime.mock:
    default:
      return MockInferenceEngine();
  }
});
