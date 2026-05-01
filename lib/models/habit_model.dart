// models/habit_model.dart
class Habit {
  final String id;
  String name;
  String goal;
  DateTime startDate;
  int currentDay;
  Map<int, bool> completedDays;
  String color;
  String icon;
  bool isCompletionShown;

  Habit({
    required this.id,
    required this.name,
    required this.goal,
    required this.startDate,
    required this.currentDay,
    required this.completedDays,
    required this.color,
    required this.icon,
    this.isCompletionShown = false,
  });

  // حساب الأيام المتبقية
  int get remainingDays => 30 - currentDay;

  // حساب نسبة الإنجاز
  double get progress =>
      completedDays.values.where((done) => done).length / 30;

  // حساب أطول سلسلة متتالية
  int get longestStreak {
    int currentStreak = 0;
    int maxStreak = 0;

    for (int day = 1; day <= 30; day++) {
      if (completedDays[day] == true) {
        currentStreak++;
        maxStreak = maxStreak > currentStreak ? maxStreak : currentStreak;
      } else {
        currentStreak = 0;
      }
    }
    return maxStreak;
  }
}