
// screens/add_habit_screen.dart
import 'package:flutter/material.dart';
import 'package:habit_tracker_app/main.dart';
import 'package:habit_tracker_app/utils/constants.dart';
import 'package:habit_tracker_app/models/habit_model.dart';
import 'package:habit_tracker_app/data/habit_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();

  Color _selectedColor = AppColors.habitColors[0];
  String _selectedIcon = '📚';

  final List<String> _icons = ['📚', '🏃', '🧘', '💪', '🥗', '💤', '💧', '📝', '🎯', '🧠'];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('إضافة عادة جديدة'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
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
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // حقل اسم العادة
                    Text(
                      'اسم العادة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'مثال: قراءة',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال اسم العادة';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // حقل الهدف اليومي
                    Text(
                      'الهدف اليومي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark ? null : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _goalController,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: 'مثال: ١٠ صفحات',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الهدف اليومي';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // اختيار لون العادة
                    Text(
                      'لون العادة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: AppColors.habitColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == color
                                    ? (isDark ? Colors.white : Colors.white)
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: _selectedColor == color ? 2 : 0,
                                ),
                              ],
                            ),
                            child: _selectedColor == color
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // اختيار أيقونة العادة
                    Text(
                      'أيقونة العادة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _icons.map((icon) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _selectedIcon == icon
                                  ? _selectedColor.withOpacity(0.1)
                                  : (isDark ? AppColors.cardDark : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedIcon == icon
                                    ? _selectedColor
                                    : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                icon,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),

                    // زر حفظ العادة
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_selectedColor, _selectedColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _selectedColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final newHabit = Habit(
                              id: const Uuid().v4(),
                              name: _nameController.text,
                              goal: _goalController.text,
                              startDate: DateTime.now(),
                              currentDay: 1,
                              completedDays: {},
                              color: _selectedColor.value.toRadixString(16).substring(2),
                              icon: _selectedIcon,
                            );

                            await HabitDatabase.saveHabit(newHabit);

                            if (context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                  arguments: newHabit
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          '💾 حفظ العادة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }
}