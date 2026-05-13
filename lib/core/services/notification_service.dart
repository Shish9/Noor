import 'dart:math' as math;
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/dua_data.dart';
import '../models/dua.dart';
import 'storage_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelId = 'quranapp_duas';
  static const String _channelName = 'Daily Duas';
  static const String _channelDescription =
      'Soft, calming dua reminders throughout your day.';

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    final bool? android = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final bool? ios = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return android ?? ios ?? false;
  }

  /// Schedules dua notifications throughout the day at the user's chosen interval.
  /// `intervalHours`: 1, 2, 3, 4, 6, or 12.
  /// `silent`: when true, schedules without sound/vibration.
  Future<void> scheduleHourlyDuas({
    int intervalHours = 1,
    bool silent = false,
    int startHour = 7,
    int endHour = 22,
  }) async {
    await _plugin.cancelAll();
    if (!StorageService.instance.prefs.containsKey('notif_enabled')) {
      await StorageService.instance.setPref('notif_enabled', true);
    }
    final bool enabled =
        StorageService.instance.getPref<bool>('notif_enabled', fallback: true) ?? true;
    if (!enabled) return;

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: silent ? Importance.low : Importance.defaultImportance,
      priority: silent ? Priority.low : Priority.defaultPriority,
      playSound: !silent,
      enableVibration: !silent,
      styleInformation: const BigTextStyleInformation(''),
      color: const Color(0xFF10B981),
    );
    final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: !silent,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final math.Random rand = math.Random();
    final List<Dua> pool = DuaData.all;
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    int notifId = 1000;
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      for (int hour = startHour; hour <= endHour; hour += intervalHours) {
        final tz.TZDateTime scheduled = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day + dayOffset,
          hour,
        );
        if (scheduled.isBefore(now)) continue;

        final Dua dua = pool[rand.nextInt(pool.length)];
        final String title = DuaData.notificationTitles[
            rand.nextInt(DuaData.notificationTitles.length)];
        final String body = '${dua.translation}\n— ${dua.reference ?? "Authentic Sunnah"}';

        try {
          await _plugin.zonedSchedule(
            notifId++,
            title,
            body,
            scheduled,
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'dua:${dua.id}',
          );
        } catch (e) {
          if (kDebugMode) print('Failed to schedule notification: $e');
        }
      }
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
