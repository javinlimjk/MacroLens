import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../meal_scan/domain/models.dart';
import '../application/meal_entry_provider.dart';

class MealEntrySheet extends ConsumerWidget {
  final DishBaseNutrition baseDish;

  const MealEntrySheet({super.key, required this.baseDish});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mealEntryProvider(baseDish));
    final notifier = ref.read(mealEntryProvider(baseDish).notifier);

    final title = baseDish.dishId.replaceAll('_', ' ').toUpperCase();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Macro(label: 'Cals', value: '\${state.currentNutrition.calories}'),
              _Macro(label: 'Pro', value: '\${state.currentNutrition.protein.toStringAsFixed(1)}g'),
              _Macro(label: 'Carbs', value: '\${state.currentNutrition.carbs.toStringAsFixed(1)}g'),
              _Macro(label: 'Fats', value: '\${state.currentNutrition.fats.toStringAsFixed(1)}g'),
            ],
          ),
          const Divider(height: 32),
          const Text('Portion Size', style: TextStyle(fontWeight: FontWeight.bold)),
          SegmentedButton<PortionSize>(
            segments: const [
              ButtonSegment(value: PortionSize.small, label: Text('Small')),
              ButtonSegment(value: PortionSize.regular, label: Text('Regular')),
              ButtonSegment(value: PortionSize.large, label: Text('Large')),
            ],
            selected: {state.portionSize},
            onSelectionChanged: (set) => notifier.setPortion(set.first),
          ),
          const SizedBox(height: 16),
          if (baseDish.modifierImpacts.isNotEmpty) ...[
            const Text('Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: baseDish.modifierImpacts.keys.map((modKey) {
                final isSelected = state.activeModifiers.contains(modKey);
                final label = modKey.replaceAll('_', ' ');
                return FilterChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) => notifier.toggleModifier(modKey),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () async {
              await notifier.saveMeal();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save Meal', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  final String label;
  final String value;
  const _Macro({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
