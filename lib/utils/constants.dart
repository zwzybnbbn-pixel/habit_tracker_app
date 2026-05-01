import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primary = Color(0xFF6B4EFF);
  static const Color secondary = Color(0xFF00C9A7);
  static const Color accent = Color(0xFFFF6B6B);

  // خلفيات
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color backgroundDark = Color(0xFF121212);

  // ألوان البطاقات
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);

  // ألوان النصوص
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF4A4A68);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // ألوان الوضع المضلم الإضافية
  static const Color primaryDark = Color(0xFF8B7CFF);
  static const Color secondaryDark = Color(0xFF00E5B9);

  // ألوان النجاح والإنجاز
  static const Color success = Color(0xFF00C9A7);
  static const Color warning = Color(0xFFFFB347);
  static const Color incomplete = Color(0xFFE0E0E0);

  // ألوان العادات المتنوعة
  static const List<Color> habitColors = [
    Color(0xFF6B4EFF),
    Color(0xFFFF6B6B),
    Color(0xFFFFB347),
    Color(0xFF00C9A7),
    Color(0xFF4A90E2),
    Color(0xFF9B51E0),
  ];

  // تدرجات للخلفيات
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6B4EFF), Color(0xFF9B51E0)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C9A7), Color(0xFF4A90E2)],
  );
}

class AppTextStyles {
  static const String fontFamily = 'Cairo';

  static TextStyle heading1 = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    fontFamily: fontFamily,
    color: Color(0xFF1A1A2E),
  );

  static TextStyle heading2 = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    color: Color(0xFF1A1A2E),
  );

  static TextStyle bodyText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    color: Color(0xFF4A4A68),
  );

  static TextStyle caption = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    fontFamily: fontFamily,
    color: Color(0xFF6B6B8B),
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    color: Colors.white,
  );
}

class AppShadows {
  static BoxShadow soft = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow medium = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );

  static BoxShadow strong = BoxShadow(
    color: AppColors.primary.withOpacity(0.3),
    blurRadius: 30,
    offset: const Offset(0, 12),
  );
}

class AppStrings {
  static const String appName = '٣٠ يوم';
  static const String welcomeMessage = 'بناء عادات جديدة بطريقة بسيطة وممتعة';
  static const String daysRemaining = 'يوماً متبقياً';
  static const String completed = 'تم';
  static const String notCompleted = 'لم ينجز بعد';

  static const List<String> motivationalMessages = [
    'أنت تبني نسخة أفضل من نفسك',
    'كل يوم هو فرصة جديدة للتحسن',
    'الاستمرارية أهم من الكمال',
    '٣٠ يوم تفصلك عن عادة جديدة',
    'استمر، أنت تقوم بعمل رائع',
    'اليوم خطوة أقرب لهدفك',
  ];
}

class AppIcons {
  static const Map<String, String> habitIcons = {
    '📚': 'قراءة',
    '🏃': 'رياضة',
    '🧘': 'تأمل',
    '💪': 'تمارين قوة',
    '🥗': 'أكل صحي',
    '💤': 'نوم منتظم',
    '💧': 'شرب ماء',
    '📝': 'كتابة',
    '🎯': 'هدف',
    '🧠': 'تعلم',
  };
}