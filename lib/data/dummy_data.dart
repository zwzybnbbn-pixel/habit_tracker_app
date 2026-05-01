// data/dummy_data.dart
import 'package:habit_tracker_app/models/habit_model.dart';
import 'package:habit_tracker_app/utils/constants.dart';

class DummyData {
  static List<Habit> getDummyHabits() {
    return [
      Habit(
        id: '1',
        name: 'قراءة',
        goal: '10 صفحات',
        startDate: DateTime.now().subtract(const Duration(days: 4)),
        currentDay: 5,
        completedDays: {
          1: true,
          2: true,
          3: true,
          4: true,
          5: false,
          6: false, 7: false, 8: false, 9: false, 10: false,
          11: false, 12: false, 13: false, 14: false, 15: false,
          16: false, 17: false, 18: false, 19: false, 20: false,
          21: false, 22: false, 23: false, 24: false, 25: false,
          26: false, 27: false, 28: false, 29: false, 30: false,
        },
        color: AppColors.habitColors[0].value.toRadixString(16).substring(2),
        icon: '📚',
      ),
      
      Habit(
        id: '2',
        name: 'رياضة',
        goal: '30 دقيقة',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        currentDay: 11,
        completedDays: {
          1: true, 2: true, 3: false, 4: true,
          5: true, 6: true, 7: true, 8: false,
          9: true, 10: true, 11: false,
          12: false, 13: false, 14: false, 15: false,
          16: false, 17: false, 18: false, 19: false, 20: false,
          21: false, 22: false, 23: false, 24: false, 25: false,
          26: false, 27: false, 28: false, 29: false, 30: false,
        },
        color: AppColors.habitColors[1].value.toRadixString(16).substring(2),
        icon: '🏃',
      ),
      
      Habit(
        id: '3',
        name: 'تأمل',
        goal: '15 دقيقة',
        startDate: DateTime.now().subtract(const Duration(days: 20)),
        currentDay: 21,
        completedDays: {
          1: true, 2: true, 3: true, 4: true, 5: true,
          6: true, 7: true, 8: true, 9: true, 10: true,
          11: true, 12: true, 13: true, 14: true, 15: true,
          16: true, 17: true, 18: true, 19: true, 20: true,
          21: false,
          22: false, 23: false, 24: false, 25: false,
          26: false, 27: false, 28: false, 29: false, 30: false,
        },
        color: AppColors.habitColors[2].value.toRadixString(16).substring(2),
        icon: '🧘',
      ),
      
      Habit(
        id: '4',
        name: 'شرب ماء',
        goal: '8 أكواب',
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        currentDay: 16,
        completedDays: {
          1: true, 2: true, 3: true, 4: false, 5: true,
          6: true, 7: false, 8: true, 9: true, 10: true,
          11: true, 12: true, 13: false, 14: true, 15: true,
          16: false,
          17: false, 18: false, 19: false, 20: false,
          21: false, 22: false, 23: false, 24: false, 25: false,
          26: false, 27: false, 28: false, 29: false, 30: false,
        },
        color: AppColors.habitColors[3].value.toRadixString(16).substring(2),
        icon: '💧',
      ),
    ];
  }
  
  // الحصول على عادة واحدة
  static Habit? getHabitById(String id) {
    try {
      return getDummyHabits().firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // الحصول على العادات النشطة فقط
  static List<Habit> getActiveHabits() {
    return getDummyHabits().where((habit) => habit.currentDay <= 30).toList();
  }
  
  // الحصول على العادات المكتملة
  static List<Habit> getCompletedHabits() {
    return getDummyHabits().where((habit) => habit.currentDay > 30).toList();
  }
}