import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../models/reciter.dart';
import '../models/surah.dart';
import '../state/settings_state.dart';
import 'app_language.dart';

/// Locale-aware formatting helpers.
///
/// When the app is in Arabic mode every visible number, date, and proper
/// noun should appear in Arabic — not just the chrome strings.
class Fmt {
  Fmt._();

  static const Map<String, String> _arabicDigits = <String, String>{
    '0': '٠', '1': '١', '2': '٢', '3': '٣', '4': '٤',
    '5': '٥', '6': '٦', '7': '٧', '8': '٨', '9': '٩',
  };

  /// Returns Western digits as Arabic-Indic when the language is Arabic.
  /// Pass-through for English.
  static String n(BuildContext context, Object number) {
    final AppLanguage lang = context.read<SettingsState>().language;
    final String s = number.toString();
    if (lang != AppLanguage.arabic) return s;
    final StringBuffer b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      b.write(_arabicDigits[s[i]] ?? s[i]);
    }
    return b.toString();
  }

  /// Like [n] but doesn't need a BuildContext — pass the language directly.
  static String num(AppLanguage lang, Object number) {
    final String s = number.toString();
    if (lang != AppLanguage.arabic) return s;
    final StringBuffer b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      b.write(_arabicDigits[s[i]] ?? s[i]);
    }
    return b.toString();
  }

  /// Localized "Weekday · Month Day" header date.
  /// Uses the Arabic locale when Arabic is selected.
  static String headerDate(BuildContext context, DateTime when) {
    final AppLanguage lang = context.read<SettingsState>().language;
    final String localeTag = lang == AppLanguage.arabic ? 'ar' : 'en';
    try {
      return intl.DateFormat('EEEE · d MMMM', localeTag).format(when);
    } catch (_) {
      // Arabic data not initialized — fall back to English.
      return intl.DateFormat('EEEE · MMMM d').format(when);
    }
  }

  /// Surah name appropriate for the current language: Arabic script for
  /// Arabic mode, romanized name for English.
  static String surahName(BuildContext context, Surah s) {
    final AppLanguage lang = context.read<SettingsState>().language;
    return lang == AppLanguage.arabic ? s.nameArabic : s.nameTransliteration;
  }

  /// Reciter name appropriate for the current language.
  static String reciterName(BuildContext context, Reciter r) {
    final AppLanguage lang = context.read<SettingsState>().language;
    return lang == AppLanguage.arabic ? r.arabicName : r.name;
  }
}
