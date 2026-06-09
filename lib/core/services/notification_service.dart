import 'dart:math' as math;
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/dua_data.dart';
import '../models/dua.dart';
import 'prayer_times_service.dart';
import 'storage_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _scheduledThisLaunch = false;

  // Daily duas channel
  static const String _channelId = 'quranapp_duas';
  static const String _channelName = 'Daily Duas';
  static const String _channelDescription =
      'Soft, calming dua reminders throughout your day.';

  // Prayer times channel
  static const String _prayerChannelId = 'noor_prayers';
  static const String _prayerChannelName = 'Prayer Times';
  static const String _prayerChannelDescription =
      'Reminders at the start of each prayer time.';

  static const List<String> _prayerNamesEn = <String>[
    'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha',
  ];
  static const List<String> _prayerNamesAr = <String>[
    'الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء',
  ];

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
    final AndroidFlutterLocalNotificationsPlugin? android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final bool? androidGranted =
        await android?.requestNotificationsPermission();
    // Needed for exact prayer-time alarms on Android 13+.
    try {
      await android?.requestExactAlarmsPermission();
    } catch (_) {}
    final bool? ios = await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return androidGranted ?? ios ?? false;
  }

  bool _ar() =>
      (StorageService.instance.getPref<String>('lang', fallback: 'ar') ??
          'ar') ==
      'ar';

  AndroidNotificationDetails _duaAndroid(bool silent) =>
      AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: silent ? Importance.low : Importance.defaultImportance,
        priority: silent ? Priority.low : Priority.defaultPriority,
        playSound: !silent,
        enableVibration: !silent,
        styleInformation: const BigTextStyleInformation(''),
        color: const Color(0xFFC9A961),
      );

  AndroidNotificationDetails _prayerAndroid(bool silent) =>
      AndroidNotificationDetails(
        _prayerChannelId,
        _prayerChannelName,
        channelDescription: _prayerChannelDescription,
        importance: silent ? Importance.low : Importance.high,
        priority: silent ? Priority.low : Priority.high,
        playSound: !silent,
        enableVibration: !silent,
        category: AndroidNotificationCategory.reminder,
        color: const Color(0xFFC9A961),
      );

  DarwinNotificationDetails _ios(bool silent) => DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: !silent,
      );

  /// Converts a device-local wall-clock [DateTime] to the correct absolute
  /// instant for scheduling. `tz.local` defaults to UTC (we never call
  /// setLocalLocation), so we anchor on UTC and let Dart's own DateTime do the
  /// local→UTC conversion (which is DST-aware for the given date).
  tz.TZDateTime _toTz(DateTime local) => tz.TZDateTime.from(
        DateTime(local.year, local.month, local.day, local.hour, local.minute)
            .toUtc(),
        tz.UTC,
      );

  /// Cancels everything and re-schedules both dua reminders and prayer-time
  /// alerts from current preferences. Safe to call repeatedly.
  Future<void> rescheduleAll() async {
    await _plugin.cancelAll();
    await _scheduleDuas();
    await _schedulePrayers();
    _scheduledThisLaunch = true;
  }

  /// Schedules once per app launch (e.g. after the first location fix), unless
  /// already done. Settings changes call [rescheduleAll] directly.
  Future<void> ensureScheduled() async {
    if (_scheduledThisLaunch) return;
    await rescheduleAll();
  }

  /// Back-compat entry point used by older callers.
  Future<void> scheduleHourlyDuas({
    int intervalHours = 1,
    bool silent = false,
    int startHour = 7,
    int endHour = 22,
  }) =>
      rescheduleAll();

  Future<void> _scheduleDuas({int startHour = 7, int endHour = 22}) async {
    final StorageService store = StorageService.instance;
    final bool enabled =
        store.getPref<bool>('notif_enabled', fallback: true) ?? true;
    if (!enabled) return;
    final int intervalHours =
        store.getPref<int>('notif_interval', fallback: 1) ?? 1;
    final bool silent =
        store.getPref<bool>('notif_silent', fallback: false) ?? false;
    final bool ar = _ar();

    final NotificationDetails details = NotificationDetails(
      android: _duaAndroid(silent),
      iOS: _ios(silent),
    );

    final math.Random rand = math.Random();
    final List<Dua> pool = DuaData.all;
    final DateTime nowL = DateTime.now();
    final tz.TZDateTime nowUtc = tz.TZDateTime.now(tz.UTC);

    int notifId = 1000;
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      for (int hour = startHour;
          hour <= endHour;
          hour += intervalHours.clamp(1, 12)) {
        final tz.TZDateTime scheduled =
            _toTz(DateTime(nowL.year, nowL.month, nowL.day + dayOffset, hour));
        if (!scheduled.isAfter(nowUtc)) continue;

        final Dua dua = pool[rand.nextInt(pool.length)];
        final String title = ar
            ? DuaData.notificationTitlesAr[
                rand.nextInt(DuaData.notificationTitlesAr.length)]
            : DuaData.notificationTitles[
                rand.nextInt(DuaData.notificationTitles.length)];
        final String body = ar
            ? dua.arabic
            : '${dua.translation}\n— ${dua.reference ?? "Authentic Sunnah"}';

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
          if (kDebugMode) print('Failed to schedule dua: $e');
        }
      }
    }
  }

  Future<void> _schedulePrayers() async {
    final StorageService store = StorageService.instance;
    final bool enabled =
        store.getPref<bool>('prayer_notif_enabled', fallback: true) ?? true;
    if (!enabled) return;
    final bool silent =
        store.getPref<bool>('notif_silent', fallback: false) ?? false;
    final bool ar = _ar();

    final NotificationDetails details = NotificationDetails(
      android: _prayerAndroid(silent),
      iOS: _ios(silent),
    );

    final DateTime nowL = DateTime.now();
    final tz.TZDateTime nowUtc = tz.TZDateTime.now(tz.UTC);
    int id = 2000;
    for (int dayOffset = 0; dayOffset < 5; dayOffset++) {
      final DateTime date = DateTime(nowL.year, nowL.month, nowL.day)
          .add(Duration(days: dayOffset));
      final List<DateTime>? times =
          await PrayerTimesService.instance.scheduleTimesFor(date);
      if (times == null) continue;
      for (int i = 0; i < times.length && i < 5; i++) {
        final DateTime dt = times[i];
        final tz.TZDateTime scheduled = _toTz(dt);
        if (!scheduled.isAfter(nowUtc)) continue;
        final String name = ar ? _prayerNamesAr[i] : _prayerNamesEn[i];
        final String title = ar ? '$name • نور' : '$name • Noor';
        final String body =
            ar ? 'حان وقت صلاة $name' : "It's time for $name prayer";
        try {
          await _plugin.zonedSchedule(
            id++,
            title,
            body,
            scheduled,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'prayer:${_prayerNamesEn[i]}',
          );
        } catch (e) {
          // Fall back to inexact if exact alarms are not permitted.
          try {
            await _plugin.zonedSchedule(
              id++,
              title,
              body,
              scheduled,
              details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              payload: 'prayer:${_prayerNamesEn[i]}',
            );
          } catch (e2) {
            if (kDebugMode) print('Failed to schedule prayer: $e2');
          }
        }
      }
    }
  }

  /// Fires an immediate prayer + dua notification so the user can verify
  /// notifications are working right now.
  Future<void> showTestNotifications() async {
    await requestPermissions();
    final bool ar = _ar();

    await _plugin.show(
      9001,
      ar ? 'المغرب • نور' : 'Maghrib • Noor',
      ar ? 'إشعار تجريبي لأوقات الصلاة 🕌' : 'Test prayer-time alert 🕌',
      NotificationDetails(android: _prayerAndroid(false), iOS: _ios(false)),
      payload: 'prayer:test',
    );

    final List<Dua> pool = DuaData.all;
    final Dua dua = pool[math.Random().nextInt(pool.length)];
    final String title = ar
        ? DuaData.notificationTitlesAr[
            math.Random().nextInt(DuaData.notificationTitlesAr.length)]
        : DuaData.notificationTitles[
            math.Random().nextInt(DuaData.notificationTitles.length)];
    final String body = ar
        ? dua.arabic
        : '${dua.translation}\n— ${dua.reference ?? "Authentic Sunnah"}';
    await _plugin.show(
      9002,
      title,
      body,
      NotificationDetails(android: _duaAndroid(false), iOS: _ios(false)),
      payload: 'dua:test',
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
