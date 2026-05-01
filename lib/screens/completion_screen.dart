// screens/completion_screen.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/main.dart';
import 'package:habit_tracker_app/models/habit_model.dart';
import 'package:habit_tracker_app/utils/constants.dart';
import 'package:habit_tracker_app/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletionScreen extends StatelessWidget {
  final Habit habit;

  const CompletionScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    int totalGoal = Helpers.calculateActualAchievement(habit);

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/celebration.png'),
                fit: BoxFit.cover,
                opacity: isDark ? 0.15 : 0.2,
                onError: (exception, stackTrace) {},
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.success,
                  AppColors.primary,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(  // ✅ يسمح بالتمرير
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - kToolbarHeight - 40,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // زر الوضع المضلم
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                isDark ? Icons.brightness_7 : Icons.brightness_3,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () async {
                                isDarkModeNotifier.value = !isDarkModeNotifier.value;
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setBool('dark_mode', isDarkModeNotifier.value);
                              },
                            ),
                          ],
                        ),

                        // أيقونة الإنجاز
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/trophy.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text(
                                    '🏆',
                                    style: TextStyle(fontSize: 60),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // نص التهنئة
                        Text(
                          '🎉 مبروك! 🎉',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'أكملت تحدي الـ 30 يوم',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // بطاقة الإنجاز
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      habit.icon,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          habit.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                          ),
                                        ),
                                        Text(
                                          habit.goal,
                                          style: TextStyle(
                                            color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),

                              // إحصائيات
                              _buildCompletionRow(
                                icon: Icons.check_circle,
                                label: 'الأيام المنجزة',
                                value: '${habit.completedDays.values.where((d) => d).length}/30',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildCompletionRow(
                                icon: Icons.trending_up,
                                label: 'إجمالي الإنجاز',
                                value: totalGoal.toString(),
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _buildCompletionRow(
                                icon: Icons.local_fire_department,
                                label: 'أطول سلسلة',
                                value: '${habit.longestStreak} يوم',
                                isDark: isDark,
                              ),
                              const Divider(height: 24),

                              // لقب الإنجاز
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      _getAchievementTitle(),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '🎓 لقبك الجديد',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.grey.shade400 : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // أزرار الإجراءات
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.share,
                                label: 'مشاركة',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تم نسخ نص المشاركة'),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.refresh,
                                label: 'تحدي جديد',
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, '/add_habit');
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // ✅ مسافة إضافية في الأسفل
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletionRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAchievementTitle() {
    switch (habit.name) {
      case 'قراءة':
        return '📚 قارئ محترف';
      case 'رياضة':
        return '💪 رياضي محترف';
      case 'تأمل':
        return '🧘 متأمل محترف';
      default:
        return '⭐ بطل العادات';
    }
  }
}