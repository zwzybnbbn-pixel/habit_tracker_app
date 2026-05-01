// screens/habit_details_screen.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/main.dart';
import 'package:habit_tracker_app/models/habit_model.dart';
import 'package:habit_tracker_app/utils/constants.dart';
import 'package:habit_tracker_app/widgets/progress_chart.dart';
import 'package:habit_tracker_app/data/habit_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitDetailsScreen extends StatelessWidget {
  final Habit habit;


  HabitDetailsScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        Color habitColor = Color(int.parse('0xFF${habit.color}'));

        return Scaffold(
          appBar: AppBar(
            title: Text(
              habit.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: habitColor,
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
            ],
          ),
          body: Container(
            color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة الإحصائيات
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          habitColor,
                          habitColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: habitColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              icon: Icons.check_circle,
                              value: '${habit.completedDays.values.where((d) => d).length}',
                              label: 'أيام منجزة',
                              color: Colors.white,
                            ),
                            _buildStatCard(
                              icon: Icons.event_busy,
                              value: '${habit.remainingDays}',
                              label: 'أيام متبقية',
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatCard(
                              icon: Icons.pie_chart,
                              value: '${(habit.progress * 100).toStringAsFixed(1)}%',
                              label: 'نسبة الإنجاز',
                              color: Colors.white,
                            ),
                            _buildStatCard(
                              icon: Icons.local_fire_department,
                              value: '${habit.longestStreak}',
                              label: 'أطول سلسلة',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // رسم بياني للتقدم
                  Text(
                    'تقدمك خلال الأسابيع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ProgressChart(habit: habit),
                  const SizedBox(height: 24),

                  // عنوان سجل الأيام
                  Text(
                    'سجل الأيام',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // قائمة سجل الأيام
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 30, //عرض 30 يوم كاملة
                      separatorBuilder: (context, index) => Divider(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        int day = index + 1;
                        bool isCompleted = habit.completedDays[day] ?? false;
                        bool isFuture = day > habit.currentDay; //  أيام المستقبل

                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isCompleted
                                  ? habitColor
                                  : isFuture
                                  ? Colors.grey.shade300.withOpacity(0.3)  //  لون مختلف للأيام المستقبلية
                                  : AppColors.incomplete,  // لون الأيام الفائتة
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: isCompleted
                                      ? Colors.white
                                      : isFuture
                                      ? Colors.grey.shade500  //  لون نص مختلف للمستقبل
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            'اليوم $day',
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                          subtitle: Text(
                              isFuture ? 'لم يبدأ بعد' : habit.goal,  //  نص للمستقبل
                          style: TextStyle(
                          color: isFuture
                          ? Colors.grey.shade500  //  لون  للمستقبل
                              : (isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight),
                        ),
                        ),
                        trailing: isCompleted
                        ? Icon(Icons.check_circle, color: habitColor)
                            : isFuture
                        ? Icon(Icons.lock_clock, color: Colors.grey.shade400)  //  أيقونة المستقبل
                            : Icon(Icons.radio_button_unchecked,
                        color: AppColors.incomplete),
                        );
                        },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // أزرار الإجراءات
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.edit,
                          label: 'تعديل العادة',
                          color: AppColors.primary,
                          isDark: isDark,
                          onTap: () {
                            _showEditDialog(context, isDark);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.delete,
                          label: 'حذف العادة',
                          color: AppColors.accent,
                          isDark: isDark,
                          onTap: () {
                            _showDeleteDialog(context, isDark);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف العادة'),
        content: const Text('هل أنت متأكد من حذف هذه العادة؟ لا يمكن التراجع عن هذا الإجراء.'),
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {

              await HabitDatabase.deleteHabit(habit.id);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف العادة "${habit.name}" بنجاح'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, bool isDark) {
    final nameController = TextEditingController(text: habit.name);
    final goalController = TextEditingController(text: habit.goal);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل العادة'),
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'اسم العادة',
                labelStyle: TextStyle(
                  color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              decoration: InputDecoration(
                labelText: 'الهدف اليومي',
                labelStyle: TextStyle(
                  color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              habit.name = nameController.text;
              habit.goal = goalController.text;

              await HabitDatabase.updateHabit(habit);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم تحديث العادة بنجاح'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}