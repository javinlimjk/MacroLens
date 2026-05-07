import 'dart:io';
import 'package:isar/isar.dart';
import 'models/meal_log_isar.dart';

class PhotoCleanupWorker {
  final Isar isar;

  PhotoCleanupWorker(this.isar);

  /// Scans the database for meals older than 30 days and deletes their local photos.
  Future<void> runCleanup() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

    // Find meals older than 30 days that still have a photo path
    final oldMeals = await isar.mealLogIsars
        .filter()
        .timestampLessThan(cutoffDate)
        .and()
        .photoLocalPathIsNotNull()
        .findAll();

    for (final meal in oldMeals) {
      if (meal.photoLocalPath != null) {
        final file = File(meal.photoLocalPath!);
        if (await file.exists()) {
          try {
            await file.delete();
            // Update DB to remove the reference
            meal.photoLocalPath = null;
            await isar.writeTxn(() async {
              await isar.mealLogIsars.put(meal);
            });
          } catch (e) {
            // Log error, continue with next
          }
        }
      }
    }
  }
}
