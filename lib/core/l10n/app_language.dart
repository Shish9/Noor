import 'package:flutter/material.dart';

/// Languages supported by the QuranApp UI.
///
/// All Arabic-script languages (Arabic, Sorani, Badini) are RTL.
enum AppLanguage {
  english(
    code: 'en',
    locale: Locale('en'),
    native: 'English',
    englishName: 'English',
    isRtl: false,
  ),
  arabic(
    code: 'ar',
    locale: Locale('ar'),
    native: 'العربية',
    englishName: 'Arabic',
    isRtl: true,
  ),
  sorani(
    code: 'ckb',
    // Flutter doesn't ship a 'ckb' locale; encode as Kurdish (ku) Iraq (IQ).
    locale: Locale('ku', 'IQ'),
    native: 'سۆرانی',
    englishName: 'Kurdish (Sorani)',
    isRtl: true,
  ),
  badini(
    code: 'kmr',
    // Northern Kurdish, encoded as Kurdish (ku) Turkey (TR).
    locale: Locale('ku', 'TR'),
    native: 'بادینی',
    englishName: 'Kurdish (Badini)',
    isRtl: true,
  );

  const AppLanguage({
    required this.code,
    required this.locale,
    required this.native,
    required this.englishName,
    required this.isRtl,
  });

  final String code;
  final Locale locale;
  final String native;
  final String englishName;
  final bool isRtl;

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (AppLanguage l) => l.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
