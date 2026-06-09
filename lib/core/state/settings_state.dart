import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class SettingsState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;
  Locale get locale => _language.locale;
  bool get isRtl => _language.isRtl;

  String _userName = '';
  String get userName => _userName;

  double _arabicFontSize = 26;
  double get arabicFontSize => _arabicFontSize;

  String _reciterId = 'mishary';
  String get reciterId => _reciterId;

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  int _notificationIntervalHours = 1;
  int get notificationIntervalHours => _notificationIntervalHours;

  bool _silentNotifications = false;
  bool get silentNotifications => _silentNotifications;

  bool _prayerNotificationsEnabled = true;
  bool get prayerNotificationsEnabled => _prayerNotificationsEnabled;

  int _dailyReadingGoal = 10; // ayahs per day
  int get dailyReadingGoal => _dailyReadingGoal;

  bool _showTransliteration = true;
  bool get showTransliteration => _showTransliteration;

  bool _distractionFreeMode = false;
  bool get distractionFreeMode => _distractionFreeMode;

  // ─────────────── Prayer-time calculation ───────────────
  // Source: 'auto' = Kurdistan official schedule when in a covered city,
  // astronomical elsewhere; 'calc' = always astronomical.
  String _prayerSource = 'auto';
  String get prayerSource => _prayerSource;

  // 'auto' = detect nearest Kurdistan city from GPS, otherwise a specific
  // city id (forces that city's table).
  String _prayerCity = 'auto';
  String get prayerCity => _prayerCity;

  String _prayerMethod = 'muslimWorldLeague';
  String get prayerMethod => _prayerMethod;

  String _prayerMadhab = 'shafi'; // 'shafi' | 'hanafi'
  String get prayerMadhab => _prayerMadhab;

  final Map<String, int> _prayerOffsets = <String, int>{
    'fajr': 0,
    'dhuhr': 0,
    'asr': 0,
    'maghrib': 0,
    'isha': 0,
  };
  int prayerOffset(String key) => _prayerOffsets[key] ?? 0;

  /// A compact signature of every prayer-time setting. Screens that cache
  /// computed times watch this and recompute whenever it changes.
  String get prayerConfigKey => '$_prayerSource|$_prayerCity|'
      '$_prayerMethod|$_prayerMadhab|'
      '${_prayerOffsets['fajr']},${_prayerOffsets['dhuhr']},'
      '${_prayerOffsets['asr']},${_prayerOffsets['maghrib']},'
      '${_prayerOffsets['isha']}';

  Future<void> load() async {
    final StorageService s = StorageService.instance;
    // Default language: Arabic.
    _language =
        AppLanguage.fromCode(s.getPref<String>('lang', fallback: 'ar') ?? 'ar');
    _userName = s.getPref<String>('user_name', fallback: '') ?? '';
    _arabicFontSize = (s.getPref<num>('arabic_font_size', fallback: 26) ?? 26).toDouble();
    _reciterId = s.getPref<String>('reciter', fallback: 'mishary') ?? 'mishary';
    _notificationsEnabled = s.getPref<bool>('notif_enabled', fallback: true) ?? true;
    _notificationIntervalHours = s.getPref<int>('notif_interval', fallback: 1) ?? 1;
    _silentNotifications = s.getPref<bool>('notif_silent', fallback: false) ?? false;
    _prayerNotificationsEnabled =
        s.getPref<bool>('prayer_notif_enabled', fallback: true) ?? true;
    _dailyReadingGoal = s.getPref<int>('reading_goal', fallback: 10) ?? 10;
    _showTransliteration = s.getPref<bool>('show_translit', fallback: true) ?? true;
    _prayerSource = s.getPref<String>('prayer_source', fallback: 'auto') ?? 'auto';
    _prayerCity = s.getPref<String>('prayer_city', fallback: 'auto') ?? 'auto';
    _prayerMethod =
        s.getPref<String>('prayer_method', fallback: 'muslimWorldLeague') ??
            'muslimWorldLeague';
    _prayerMadhab = s.getPref<String>('prayer_madhab', fallback: 'shafi') ?? 'shafi';
    for (final String k in _prayerOffsets.keys.toList()) {
      _prayerOffsets[k] = s.getPref<int>('prayer_adj_$k', fallback: 0) ?? 0;
    }
    notifyListeners();
  }

  Future<void> setPrayerSource(String source) async {
    if (_prayerSource == source) return;
    _prayerSource = source;
    await StorageService.instance.setPref('prayer_source', source);
    notifyListeners();
  }

  Future<void> setPrayerCity(String city) async {
    if (_prayerCity == city) return;
    _prayerCity = city;
    await StorageService.instance.setPref('prayer_city', city);
    notifyListeners();
  }

  Future<void> setPrayerMethod(String id) async {
    if (_prayerMethod == id) return;
    _prayerMethod = id;
    await StorageService.instance.setPref('prayer_method', id);
    notifyListeners();
  }

  Future<void> setPrayerMadhab(String madhab) async {
    if (_prayerMadhab == madhab) return;
    _prayerMadhab = madhab;
    await StorageService.instance.setPref('prayer_madhab', madhab);
    notifyListeners();
  }

  Future<void> setPrayerOffset(String key, int minutes) async {
    final int v = minutes.clamp(-30, 30).toInt();
    if (_prayerOffsets[key] == v) return;
    _prayerOffsets[key] = v;
    await StorageService.instance.setPref('prayer_adj_$key', v);
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    await StorageService.instance.setPref('lang', lang.code);
    // Re-queue notifications so their text matches the new language.
    await NotificationService.instance.rescheduleAll();
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final String trimmed = name.trim();
    if (_userName == trimmed) return;
    _userName = trimmed;
    await StorageService.instance.setPref('user_name', trimmed);
    notifyListeners();
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size.clamp(18, 44);
    await StorageService.instance.setPref('arabic_font_size', _arabicFontSize);
    notifyListeners();
  }

  Future<void> setReciter(String id) async {
    _reciterId = id;
    await StorageService.instance.setPref('reciter', id);
    notifyListeners();
  }

  Future<void> setShowTransliteration(bool v) async {
    _showTransliteration = v;
    await StorageService.instance.setPref('show_translit', v);
    notifyListeners();
  }

  Future<void> setDistractionFree(bool v) async {
    _distractionFreeMode = v;
    notifyListeners();
  }

  Future<void> setDailyReadingGoal(int v) async {
    _dailyReadingGoal = v;
    await StorageService.instance.setPref('reading_goal', v);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool v) async {
    _notificationsEnabled = v;
    await StorageService.instance.setPref('notif_enabled', v);
    if (v) {
      await NotificationService.instance.requestPermissions();
      await NotificationService.instance.scheduleHourlyDuas(
        intervalHours: _notificationIntervalHours,
        silent: _silentNotifications,
      );
    } else {
      await NotificationService.instance.cancelAll();
    }
    notifyListeners();
  }

  Future<void> setNotificationInterval(int hours) async {
    _notificationIntervalHours = hours;
    await StorageService.instance.setPref('notif_interval', hours);
    if (_notificationsEnabled) {
      await NotificationService.instance.scheduleHourlyDuas(
        intervalHours: hours,
        silent: _silentNotifications,
      );
    }
    notifyListeners();
  }

  Future<void> setSilentNotifications(bool v) async {
    _silentNotifications = v;
    await StorageService.instance.setPref('notif_silent', v);
    if (_notificationsEnabled) {
      await NotificationService.instance.scheduleHourlyDuas(
        intervalHours: _notificationIntervalHours,
        silent: v,
      );
    }
    notifyListeners();
  }

  Future<void> setPrayerNotificationsEnabled(bool v) async {
    _prayerNotificationsEnabled = v;
    await StorageService.instance.setPref('prayer_notif_enabled', v);
    if (v) await NotificationService.instance.requestPermissions();
    await NotificationService.instance.rescheduleAll();
    notifyListeners();
  }

  /// Fires an immediate test prayer + dua notification.
  Future<void> sendTestNotification() =>
      NotificationService.instance.showTestNotifications();
}
