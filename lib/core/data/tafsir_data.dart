import '../models/tafsir.dart';

/// Tafsir corpus.
///
/// The Tahsin Ibrahim Doski tafsir text is being prepared and will be
/// integrated in a future update. Until then, the bundled map is empty
/// and the Tafsir reader screen shows a "Coming Soon" state.
///
/// To activate: drop entries into [entries] keyed by `"surah:ayah"`.
/// The rest of the app — language switcher, reader UI, share, bookmarks —
/// is already wired and will light up automatically per-ayah.
class TafsirData {
  TafsirData._();

  static const String author = 'Tahsin Ibrahim Doski';
  static const String authorArabic = 'تەحسین ئیبراهیم دۆسکی';

  /// All bundled ayah-tafsir entries. Empty until Doski text is integrated.
  static const Map<String, AyahTafsir> entries = <String, AyahTafsir>{};

  static AyahTafsir? lookup(int surahNumber, int ayahNumber) =>
      entries['$surahNumber:$ayahNumber'];

  static List<AyahTafsir> forSurah(int surahNumber) {
    final List<AyahTafsir> list = entries.values
        .where((AyahTafsir e) => e.surahNumber == surahNumber)
        .toList();
    list.sort((AyahTafsir a, AyahTafsir b) =>
        a.ayahNumber.compareTo(b.ayahNumber));
    return list;
  }

  static List<int> get availableSurahs {
    final Set<int> set =
        entries.values.map((AyahTafsir e) => e.surahNumber).toSet();
    final List<int> list = set.toList()..sort();
    return list;
  }

  static bool get hasContent => entries.isNotEmpty;
}
