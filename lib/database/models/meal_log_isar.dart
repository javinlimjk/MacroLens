import 'package:isar/isar.dart';

part 'meal_log_isar.g.dart';

@collection
class MealLogIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String domainId;

  late DateTime timestamp;

  String? photoLocalPath;

  late String dishName;

  @enumerated
  late PortionSizeIsar portionSize;

  late List<String> appliedModifiers;

  late int calories;
  late double protein;
  late double carbs;
  late double fats;
}

enum PortionSizeIsar { small, regular, large }

@collection
class DailyProgressIsar {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int totalCalories;
  late double totalProtein;
  late double totalCarbs;
  late double totalFats;

  late int targetCalories;
  late double targetProtein;
  late double targetCarbs;
  late double targetFats;
}
