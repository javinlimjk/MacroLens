import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/manual_search_provider.dart';
import 'meal_entry_sheet.dart';

class ManualLogScreen extends ConsumerWidget {
  const ManualLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableDishes = ref.watch(manualSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Food'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => ref.read(manualSearchProvider.notifier).updateQuery(val),
              decoration: InputDecoration(
                hintText: 'Search for Chicken Rice, Nasi Lemak...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableDishes.length,
              itemBuilder: (context, index) {
                final dish = availableDishes[index];
                final title = dish.dishId.replaceAll('_', ' ').toUpperCase();
                return ListTile(
                  title: Text(title),
                  subtitle: Text('${dish.defaultPortion.calories} kcal • ${dish.defaultPortion.protein}g Protein'),
                  trailing: const Icon(Icons.add_circle_outline),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => MealEntrySheet(baseDish: dish),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
