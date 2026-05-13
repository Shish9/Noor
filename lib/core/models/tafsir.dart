import 'package:flutter/widgets.dart';

/// Languages supported by the Tafsir subsystem.
///
/// Each language carries:
/// - `code`     : storage / API key
/// - `label`    : short label for chips and switcher
/// - `english`  : English name for accessibility / settings
/// - `native`   : native script label (shown next to the chip)
/// - `isRtl`    : whether the script is right-to-left
enum TafsirLanguage {
  badini(
    code: 'bad',
    label: 'Badînî',
    englishName: 'Kurdish (Badini)',
    native: 'بادینی',
    isRtl: true,
  ),
  sorani(
    code: 'sor',
    label: 'Soranî',
    englishName: 'Kurdish (Sorani)',
    native: 'سۆرانی',
    isRtl: true,
  ),
  arabic(
    code: 'ar',
    label: 'العربية',
    englishName: 'Arabic',
    native: 'العربية',
    isRtl: true,
  ),
  english(
    code: 'en',
    label: 'English',
    englishName: 'English',
    native: 'EN',
    isRtl: false,
  );

  const TafsirLanguage({
    required this.code,
    required this.label,
    required this.englishName,
    required this.native,
    required this.isRtl,
  });

  final String code;
  final String label;
  final String englishName;
  final String native;
  final bool isRtl;

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  static TafsirLanguage fromCode(String code) {
    return TafsirLanguage.values.firstWhere(
      (TafsirLanguage l) => l.code == code,
      orElse: () => TafsirLanguage.english,
    );
  }
}

/// One ayah's translations + tafsir bundle for all supported languages.
class AyahTafsir {
  const AyahTafsir({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabic,
    this.translations = const <TafsirLanguage, String>{},
    this.tafsirByLanguage = const <TafsirLanguage, String>{},
    this.author = 'Tahsin Ibrahim Doski',
    this.tafsirAudioUrl,
  });

  final int surahNumber;
  final int ayahNumber;

  /// Arabic Quran text (Uthmani).
  final String arabic;

  /// Plain translations per language.
  final Map<TafsirLanguage, String> translations;

  /// Long-form tafsir explanation per language.
  final Map<TafsirLanguage, String> tafsirByLanguage;

  /// Default author label shown above each tafsir entry.
  final String author;

  /// Optional audio URL for spoken tafsir.
  final String? tafsirAudioUrl;

  /// Stable identifier "surah:ayah" for storage keys.
  String get reference => '$surahNumber:$ayahNumber';

  String? translation(TafsirLanguage lang) => translations[lang];
  String? tafsir(TafsirLanguage lang) => tafsirByLanguage[lang];

  bool hasTafsir(TafsirLanguage lang) =>
      tafsirByLanguage[lang]?.trim().isNotEmpty ?? false;
}
