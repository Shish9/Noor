import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/surah.dart';

/// Lightweight client for AlQuran.cloud API with on-disk caching.
/// API docs: https://alquran.cloud/api
class QuranService {
  QuranService._();
  static final QuranService instance = QuranService._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.alquran.cloud/v1',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Box<dynamic>? _cache;

  Future<void> _ensureCache() async {
    _cache ??= await Hive.openBox<dynamic>('quran_cache');
  }

  /// Returns ayahs for a surah. Combines Arabic Uthmani with English Sahih translation.
  Future<List<Ayah>> fetchSurah(int surahNumber, {String translation = 'en.sahih'}) async {
    await _ensureCache();
    final String key = 'surah_${surahNumber}_$translation';
    final dynamic cached = _cache!.get(key);
    if (cached != null) {
      return _parse(jsonDecode(cached as String) as Map<String, dynamic>, surahNumber);
    }

    try {
      final Response<dynamic> arabicResp = await _dio.get<dynamic>(
        '/surah/$surahNumber/quran-uthmani',
      );
      final Response<dynamic> trResp = await _dio.get<dynamic>(
        '/surah/$surahNumber/$translation',
      );

      final Map<String, dynamic> merged = <String, dynamic>{
        'arabic': arabicResp.data,
        'translation': trResp.data,
      };
      await _cache!.put(key, jsonEncode(merged));
      return _parse(merged, surahNumber);
    } catch (e) {
      // Offline / failure fallback — return Al-Fatihah baked-in if requested.
      if (surahNumber == 1) return _alFatihahFallback();
      rethrow;
    }
  }

  List<Ayah> _parse(Map<String, dynamic> json, int surahNumber) {
    final List<dynamic> arabicAyahs =
        (json['arabic'] as Map<String, dynamic>)['data']['ayahs'] as List<dynamic>;
    final List<dynamic> translationAyahs =
        (json['translation'] as Map<String, dynamic>)['data']['ayahs'] as List<dynamic>;

    final List<Ayah> ayahs = <Ayah>[];
    for (int i = 0; i < arabicAyahs.length; i++) {
      final Map<String, dynamic> a = arabicAyahs[i] as Map<String, dynamic>;
      final Map<String, dynamic> t = translationAyahs[i] as Map<String, dynamic>;
      ayahs.add(
        Ayah(
          surahNumber: surahNumber,
          number: a['numberInSurah'] as int,
          arabic: a['text'] as String,
          translation: t['text'] as String,
          transliteration: '',
        ),
      );
    }
    return ayahs;
  }

  List<Ayah> _alFatihahFallback() {
    return const <Ayah>[
      Ayah(
        surahNumber: 1,
        number: 1,
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        transliteration: 'Bismillahir-Rahmanir-Raheem',
      ),
      Ayah(
        surahNumber: 1,
        number: 2,
        arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        translation: '[All] praise is [due] to Allah, Lord of the worlds.',
        transliteration: 'Alhamdu lillahi rabbil-\'alamin',
      ),
      Ayah(
        surahNumber: 1,
        number: 3,
        arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'The Entirely Merciful, the Especially Merciful.',
        transliteration: 'Ar-Rahmanir-Raheem',
      ),
      Ayah(
        surahNumber: 1,
        number: 4,
        arabic: 'مَالِكِ يَوْمِ الدِّينِ',
        translation: 'Sovereign of the Day of Recompense.',
        transliteration: 'Maliki yawmid-deen',
      ),
      Ayah(
        surahNumber: 1,
        number: 5,
        arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        translation: 'It is You we worship and You we ask for help.',
        transliteration: 'Iyyaka na\'budu wa iyyaka nasta\'een',
      ),
      Ayah(
        surahNumber: 1,
        number: 6,
        arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        translation: 'Guide us to the straight path.',
        transliteration: 'Ihdinas-siratal-mustaqeem',
      ),
      Ayah(
        surahNumber: 1,
        number: 7,
        arabic: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        translation: 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
        transliteration: 'Siratal-ladhina an\'amta \'alayhim, ghayril-maghdubi \'alayhim, walad-dalleen',
      ),
    ];
  }
}
