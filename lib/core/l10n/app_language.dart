import 'package:flutter/material.dart';

/// Languages supported by the Noor UI.
///
/// Arabic uses RTL; English uses LTR.
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
