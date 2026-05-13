import 'package:flutter/foundation.dart';

import '../models/tafsir.dart';
import '../services/storage_service.dart';
import '../services/tafsir_service.dart';

class TafsirState extends ChangeNotifier {
  TafsirState() {
    final String code =
        StorageService.instance.getPref<String>('tafsir_lang', fallback: 'bad') ??
            'bad';
    _language = TafsirLanguage.fromCode(code);
    _favorites = StorageService.instance.favoriteTafsirs;
    _lastRead = StorageService.instance.lastTafsirRead;
  }

  // ── Selected language ──
  late TafsirLanguage _language;
  TafsirLanguage get language => _language;

  Future<void> setLanguage(TafsirLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    await StorageService.instance.setPref('tafsir_lang', lang.code);
    notifyListeners();
  }

  // ── Cached entries per surah ──
  final Map<int, List<AyahTafsir>> _cache = <int, List<AyahTafsir>>{};
  final Set<int> _loading = <int>{};

  Future<List<AyahTafsir>> getSurah(int surahNumber) async {
    if (_cache.containsKey(surahNumber)) return _cache[surahNumber]!;
    if (_loading.contains(surahNumber)) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return getSurah(surahNumber);
    }
    _loading.add(surahNumber);
    try {
      final List<AyahTafsir> list =
          await TafsirService.instance.getSurah(surahNumber);
      _cache[surahNumber] = list;
      return list;
    } finally {
      _loading.remove(surahNumber);
    }
  }

  bool isBundled(int surahNumber) => TafsirService.instance.isBundled(surahNumber);

  // ── Favorites ──
  late List<String> _favorites;
  List<String> get favorites => _favorites;

  bool isFavorite(String reference) => _favorites.contains(reference);

  Future<void> toggleFavorite(String reference) async {
    await StorageService.instance.toggleTafsirFavorite(reference);
    _favorites = StorageService.instance.favoriteTafsirs;
    notifyListeners();
  }

  // ── Last read position ──
  Map<String, dynamic>? _lastRead;
  Map<String, dynamic>? get lastRead => _lastRead;

  Future<void> markRead({required int surah, required int ayah}) async {
    await StorageService.instance
        .setLastTafsirRead(surah: surah, ayah: ayah);
    _lastRead = StorageService.instance.lastTafsirRead;
    notifyListeners();
  }
}
