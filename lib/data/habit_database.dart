import 'package:hive/hive.dart';
import 'package:habit_tracker_app/models/habit_model.dart';

class HabitDatabase {
  static const String boxName = 'habits_box';
  static Box<Habit>? _box;

  // دالة التهيئة (كانت ناقصة)
  static Future<void> initialize() async {
    _box = await Hive.openBox<Habit>(boxName);
  }

  static Box<Habit> get box {
    if (_box == null) {
      throw Exception('HabitDatabase not initialized. Call initialize() first.');
    }
    return _box!;
  }

  static Future<void> saveHabit(Habit habit) async {
    await box.put(habit.id, habit);
  }

  static Future<List<Habit>> getAllHabits() async {
    return box.values.toList();
  }

  static Future<Habit?> getHabit(String id) async {
    return box.get(id);
  }

  static Future<void> updateHabit(Habit habit) async {
    await box.put(habit.id, habit);
  }

  static Future<void> deleteHabit(String id) async {
    await box.delete(id);
  }

  static Future<void> markDayAsCompleted(String habitId, int dayNumber) async {
    final habit = box.get(habitId);
    if (habit != null) {
      habit.completedDays[dayNumber] = true;
      if (dayNumber > habit.currentDay) {
        habit.currentDay = dayNumber;
      }
      await box.put(habitId, habit);
    }
  }
}