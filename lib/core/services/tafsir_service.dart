import '../data/tafsir_data.dart';
import '../models/surah.dart';
import '../models/tafsir.dart';
import 'quran_service.dart';

/// Loads ayah-level tafsir + translations.
///
/// Strategy:
/// 1. Bundled `TafsirData` (offline, instant) — covers Al-Fatihah and the
///    Mu'awwidhat (112–114) plus any new entries added later.
/// 2. Fall back to the AlQuran.cloud API for the Arabic and English text
///    of the verse, with empty Kurdish translations until the user
///    integrates a full corpus.
class TafsirService {
  TafsirService._();
  static final TafsirService instance = TafsirService._();

  /// Returns a single ayah's tafsir bundle, falling back to the live API
  /// if the entry is not bundled.
  Future<AyahTafsir> getAyah(int surahNumber, int ayahNumber) async {
    final AyahTafsir? bundled = TafsirData.lookup(surahNumber, ayahNumber);
    if (bundled != null) return bundled;

    // Live fallback — fetch Arabic + English from AlQuran.cloud and produce
    // a degraded tafsir entry. Kurdish strings are left empty so the UI can
    // gracefully show "Translation not yet available for this ayah."
    final List<Ayah> ayahs = await QuranService.instance.fetchSurah(surahNumber);
    final Ayah a = ayahs.firstWhere(
      (Ayah a) => a.number == ayahNumber,
      orElse: () => Ayah(
        surahNumber: surahNumber,
        number: ayahNumber,
        arabic: '',
        translation: '',
        transliteration: '',
      ),
    );

    return AyahTafsir(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      arabic: a.arabic,
      translations: <TafsirLanguage, String>{
        TafsirLanguage.arabic: a.arabic,
        TafsirLanguage.english: a.translation,
      },
      tafsirByLanguage: const <TafsirLanguage, String>{},
    );
  }

  /// Returns all ayahs for a surah with merged tafsir data.
  /// Bundled entries take precedence; the rest are filled from the API.
  Future<List<AyahTafsir>> getSurah(int surahNumber) async {
    final List<Ayah> ayahs = await QuranService.instance.fetchSurah(surahNumber);
    final List<AyahTafsir> result = <AyahTafsir>[];

    for (final Ayah a in ayahs) {
      final AyahTafsir? bundled = TafsirData.lookup(surahNumber, a.number);
      if (bundled != null) {
        result.add(bundled);
      } else {
        result.add(
          AyahTafsir(
            surahNumber: surahNumber,
            ayahNumber: a.number,
            arabic: a.arabic,
            translations: <TafsirLanguage, String>{
              TafsirLanguage.arabic: a.arabic,
              TafsirLanguage.english: a.translation,
            },
            tafsirByLanguage: const <TafsirLanguage, String>{},
          ),
        );
      }
    }

    return result;
  }

  /// Whether bundled (offline) tafsir is available for a given surah.
  bool isBundled(int surahNumber) =>
      TafsirData.availableSurahs.contains(surahNumber);
}
