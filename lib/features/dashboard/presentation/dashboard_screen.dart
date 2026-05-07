import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../application/dashboard_provider.dart';
import '../../meal_scan/domain/models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Progress'),
        centerTitle: true,
      ),
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('Calories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('${data.progress.totalConsumed.calories} / ${data.progress.targetGoals.calories} kcal', style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _MacroCard(title: 'Protein', value: '${data.progress.totalConsumed.protein.toStringAsFixed(0)}g'),
                  _MacroCard(title: 'Carbs', value: '${data.progress.totalConsumed.carbs.toStringAsFixed(0)}g'),
                  _MacroCard(title: 'Fats', value: '${data.progress.totalConsumed.fats.toStringAsFixed(0)}g'),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Today\'s Meals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: data.todaysMeals.isEmpty 
                  ? ListView(
                      children: const [
                        ListTile(
                          leading: Icon(Icons.fastfood),
                          title: Text('No meals logged yet'),
                          subtitle: Text('Tap + to scan or manually enter a meal'),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: data.todaysMeals.length,
                      itemBuilder: (context, index) {
                        final meal = data.todaysMeals[index];
                        return ListTile(
                          leading: const Icon(Icons.restaurant),
                          title: Text(meal.dishName),
                          subtitle: Text('${meal.finalNutrition.calories} kcal • ${meal.portionSize.name} portion'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final repo = ref.read(mealRepositoryProvider);
                              await repo.deleteMeal(meal.id);
                              ref.invalidate(dashboardProvider);
                            },
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  final String title;
  final String value;

  const _MacroCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value),
          ],
        ),
      ),
    );
  }
}
