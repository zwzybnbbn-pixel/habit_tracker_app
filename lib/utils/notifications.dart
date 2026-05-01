// utils/notifications.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    tzData.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        // التعامل مع الضغط على الإشعار
      },
    );

    _initialized = true;
  }

  // ✅ طلب الإذن بشكل آمن
  static Future<void> requestPermissions() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // باقي الدوال كما هي...
  static Future<void> scheduleDailyReminder({
    required String habitName,
    required String habitId,
    TimeOfDay? time,
  }) async {
    final scheduledTime = time ?? const TimeOfDay(hour: 20, minute: 0);

    final androidDetails = AndroidNotificationDetails(
      'daily_channel_$habitId',
      'تذكير يومي - $habitName',
      channelDescription: 'تذكير يومي لتسجيل تقدمك في عادة $habitName',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF6B4EFF),
      enableLights: true,
      enableVibration: true,
    );

    final iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'daily_reminder',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.periodicallyShow(
      habitId.hashCode,
      '⏰ تذكير بعادتك اليومية',
      'هل أنجزت "$habitName" اليوم؟',
      RepeatInterval.daily,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  static Future<void> showMotivationNotification({
    required String habitName,
    required int day,
    required String habitId,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'motivation_channel_$habitId',
      'إشعارات تحفيزية',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      habitId.hashCode + 100,
      '🎉 أحسنت!',
      'أكملت يوم $day في تحدي "$habitName"',
      notificationDetails,
    );
  }

  static Future<void> showLastChanceNotification({
    required String habitName,
    required String habitId,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'warning_channel_$habitId',
      'إشعارات تحذيرية',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      habitId.hashCode + 200,
      '⚠️ آخر فرصة اليوم',
      'لم تسجل تقدمك في "$habitName" بعد. هل أنجزتها؟',
      notificationDetails,
    );
  }

  static Future<void> showCompletionNotification({
    required String habitName,
    required String habitId,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'completion_channel_$habitId',
      'إنجاز التحدي',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      habitId.hashCode + 300,
      '🏆 مبروك!',
      'أكملت تحدي 30 يوم لـ "$habitName" بنجاح',
      notificationDetails,
    );
  }

  static Future<void> cancelHabitNotifications(String habitId) async {
    await _notifications.cancel(habitId.hashCode);
    await _notifications.cancel(habitId.hashCode + 100);
    await _notifications.cancel(habitId.hashCode + 200);
    await _notifications.cancel(habitId.hashCode + 300);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  static Future<void> showCustomNotification({
    required String title,
    required String body,
    required int id,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'custom_channel',
      'إشعارات مخصصة',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}