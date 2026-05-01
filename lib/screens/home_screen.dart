// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/main.dart';
import 'package:habit_tracker_app/models/habit_model.dart';
import 'package:habit_tracker_app/utils/constants.dart';
import 'package:habit_tracker_app/widgets/day_grid_item.dart';
import 'package:habit_tracker_app/widgets/habit_card.dart';
import 'package:habit_tracker_app/data/habit_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  final Habit? initialHabit;

  const HomeScreen({super.key, this.initialHabit});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Habit _habit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    if (widget.initialHabit != null) {
      _habit = widget.initialHabit!;
      _processMissedDaysAutomatically();
    } else {
      final habits = await HabitDatabase.getAllHabits();
      if (habits.isNotEmpty) {
        _habit = habits.first;
        _processMissedDaysAutomatically();
      } else {
        // Create dummy for demo
        _habit = Habit(
          id: const Uuid().v4(),
          name: 'قراءة',
          goal: '10 صفحات',
          startDate: DateTime.now(),
          currentDay: 1,
          completedDays: {},
          color: '6B4EFF',
          icon: '📚',
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _processMissedDaysAutomatically() async {
    bool hasChanges = false;

    final now = DateTime.now();
    final startDate = DateTime(
      _habit.startDate.year,
      _habit.startDate.month,
      _habit.startDate.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    final daysSinceStart = today.difference(startDate).inDays + 1;

    if (daysSinceStart > _habit.currentDay) {
      final missedDays = daysSinceStart - _habit.currentDay;
      final newDay = daysSinceStart > 30 ? 30 : daysSinceStart;

      for (int day = _habit.currentDay; day < newDay; day++) {
        if (day <= 30 && _habit.completedDays[day] == null) {
          _habit.completedDays[day] = false;
          hasChanges = true;
        }
      }

      if (_habit.currentDay < newDay) {
        _habit.currentDay = newDay;
        hasChanges = true;
      }

      if (hasChanges) {
        await HabitDatabase.updateHabit(_habit);

        if (missedDays > 0 && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('📅 تم تحديث التحدي: تخطيت $missedDays أيام فائتة'),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }

    // ✅ التعديل هنا - التحقق من إكمال التحدي
    if (_habit.currentDay > 30 &&
        !_habit.isCompletionShown &&
        context.mounted) {

      _habit.isCompletionShown = true;
      await HabitDatabase.updateHabit(_habit);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          '/completion',
          arguments: _habit,
        );
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        if (_isLoading || _habit == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        Color habitColor = Color(int.parse('0xFF${_habit.color}'));

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(_habit.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  _habit.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.brightness_7 : Icons.brightness_3,
                  color: isDark ? Colors.amber : AppColors.primary,
                ),
                onPressed: () async {
                  isDarkModeNotifier.value = !isDarkModeNotifier.value;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('dark_mode', isDarkModeNotifier.value);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: habitColor),
                onPressed: () {
                  Navigator.pushNamed(context, '/details', arguments: _habit);
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HabitCard(habit: _habit),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'أيام التحدي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: habitColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_habit.remainingDays} يوم متبقي',
                          style: TextStyle(
                            color: habitColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        int dayNumber = index + 1;
                        bool isCompleted = _habit.completedDays[dayNumber] ?? false;
                        bool isToday = dayNumber == _habit.currentDay;

                        return DayGridItem(
                          dayNumber: dayNumber,
                          isCompleted: isCompleted,
                          isToday: isToday,
                          habitColor: habitColor,
                          onTap: () async {
                            if (!isCompleted && dayNumber == _habit.currentDay) {
                              setState(() {
                                _habit.completedDays[dayNumber] = true;
                                if (dayNumber == _habit.currentDay) {
                                  _habit.currentDay++;
                                }
                              });

                              await HabitDatabase.markDayAsCompleted(_habit.id, dayNumber);

                              // ✅ التعديل هنا - بعد تسجيل اليوم 30
                              if (_habit.currentDay > 30 &&
                                  !_habit.isCompletionShown &&
                                  context.mounted) {

                                _habit.isCompletionShown = true;
                                await HabitDatabase.updateHabit(_habit);

                                Navigator.pushReplacementNamed(
                                    context,
                                    '/completion',
                                    arguments: _habit
                                );
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('🎉 أحسنت! أكملت يوم $dayNumber'),
                                      backgroundColor: AppColors.success,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(
                          color: AppColors.success,
                          label: 'تم الإنجاز',
                          icon: Icons.check_circle,
                          isDark: isDark,
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        _buildLegendItem(
                          color: AppColors.incomplete,
                          label: 'لم ينجز',
                          icon: Icons.radio_button_unchecked,
                          isDark: isDark,
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                        _buildLegendItem(
                          color: habitColor,
                          label: 'اليوم الحالي',
                          icon: Icons.today,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_habit');
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: habitColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: habitColor,
                          size: 18,
                        ),
                      ),
                      label: Text(
                        'إضافة عادة جديدة',
                        style: TextStyle(
                          color: habitColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}