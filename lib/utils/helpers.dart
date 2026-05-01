// utils/helpers.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:habit_tracker_app/models/habit_model.dart';

class Helpers {
  // تنسيق التاريخ
  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
  
  // تنسيق التاريخ بالعربية
  static String formatDateArabic(DateTime date) {
    final formatter = DateFormat('EEEE, d MMMM', 'ar');
    return formatter.format(date);
  }
  
  // الحصول على اسم اليوم
  static String getDayName(int dayNumber) {
    switch (dayNumber) {
      case 1: return 'السبت';
      case 2: return 'الأحد';
      case 3: return 'الاثنين';
      case 4: return 'الثلاثاء';
      case 5: return 'الأربعاء';
      case 6: return 'الخميس';
      case 7: return 'الجمعة';
      default: return '';
    }
  }
  
  // استخراج الرقم من النص
  static int extractNumberFromString(String text) {
    final RegExp regex = RegExp(r'\d+');
    final match = regex.firstMatch(text);
    return match != null ? int.parse(match.group(0)!) : 0;
  }
  
  // حساب نسبة التقدم
  static double calculateProgress(int completed, int total) {
    if (total == 0) return 0;
    return completed / total;
  }
  
  // الحصول على رسالة تحفيزية حسب النسبة
  static String getMotivationalMessage(double progress) {
    if (progress < 0.25) {
      return '💪 بداية قوية! استمر';
    } else if (progress < 0.5) {
      return '🌟 أنت تبني عادة رائعة';
    } else if (progress < 0.75) {
      return '🚀 نصف الطريق! استمر';
    } else if (progress < 1) {
      return '🎯 على وشك الإنجاز';
    } else {
      return '🏆 أهنئك! أكملت التحدي';
    }
  }
  
  // الحصول على لون حسب النسبة
  static Color getProgressColor(double progress) {
    if (progress < 0.25) {
      return Colors.orange;
    } else if (progress < 0.5) {
      return Colors.yellow.shade700;
    } else if (progress < 0.75) {
      return Colors.lightGreen;
    } else if (progress < 1) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }
  
  // التحقق من صحة البيانات
  static bool isValidHabit(Habit habit) {
    return habit.name.isNotEmpty && 
           habit.goal.isNotEmpty && 
           habit.currentDay >= 1 && 
           habit.currentDay <= 31;
  }
  
  // حساب الأيام المتتالية الحالية
  static int getCurrentStreak(Habit habit) {
    int streak = 0;
    for (int day = habit.currentDay - 1; day >= 1; day--) {
      if (habit.completedDays[day] == true) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
  
  // مشاركة النص
  static String getShareText(Habit habit) {
    return '''
🎯 تحديث تقدمي في تطبيق "٣٠ يوم"
📌 العادة: ${habit.name} (${habit.goal})
✅ الأيام المنجزة: ${habit.completedDays.values.where((d) => d).length}/30
🔥 أطول سلسلة: ${habit.longestStreak} أيام
📊 نسبة الإنجاز: ${(habit.progress * 100).toStringAsFixed(1)}%
🚀 استمر في تحقيق أهدافك!
    ''';
  }
  static int calculateActualAchievement(Habit habit){
    int perDay = extractNumberFromString(habit.goal);
    int completeDays = habit.completedDays.values.where((d) => d).length;
    return perDay * completeDays;
  }
}