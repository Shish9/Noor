import 'package:flutter/material.dart';

import '../l10n/app_language.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class SettingsState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;
  Locale get locale => _language.locale;
  bool get isRtl => _language.isRtl;

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

  int _dailyReadingGoal = 10; // ayahs per day
  int get dailyReadingGoal => _dailyReadingGoal;

  bool _showTransliteration = true;
  bool get showTransliteration => _showTransliteration;

  bool _distractionFreeMode = false;
  bool get distractionFreeMode => _distractionFreeMode;

  Future<void> load() async {
    final StorageService s = StorageService.instance;
    // Default language: Arabic.
    _language =
        AppLanguage.fromCode(s.getPref<String>('lang', fallback: 'ar') ?? 'ar');
    _arabicFontSize = (s.getPref<num>('arabic_font_size', fallback: 26) ?? 26).toDouble();
    _reciterId = s.getPref<String>('reciter', fallback: 'mishary') ?? 'mishary';
    _notificationsEnabled = s.getPref<bool>('notif_enabled', fallback: true) ?? true;
    _notificationIntervalHours = s.getPref<int>('notif_interval', fallback: 1) ?? 1;
    _silentNotifications = s.getPref<bool>('notif_silent', fallback: false) ?? false;
    _dailyReadingGoal = s.getPref<int>('reading_goal', fallback: 10) ?? 10;
    _showTransliteration = s.getPref<bool>('show_translit', fallback: true) ?? true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    await StorageService.instance.setPref('lang', lang.code);
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
}
