import 'package:flutter/foundation.dart';

import '../models/surah.dart';
import '../services/quran_service.dart';
import '../services/storage_service.dart';

class QuranState extends ChangeNotifier {
  final Map<int, List<Ayah>> _cache = <int, List<Ayah>>{};
  final Set<int> _loading = <int>{};

  Map<String, dynamic>? _lastRead;
  Map<String, dynamic>? get lastRead => _lastRead;

  List<String> _bookmarks = <String>[];
  List<String> get bookmarks => _bookmarks;

  int _currentStreak = 0;
  int get currentStreak => _currentStreak;

  int _longestStreak = 0;
  int get longestStreak => _longestStreak;

  Future<void> load() async {
    final StorageService s = StorageService.instance;
    _lastRead = s.lastRead;
    _bookmarks = s.bookmarkedAyahs;
    _currentStreak = s.currentStreak;
    _longestStreak = s.longestStreak;
    notifyListeners();
  }

  Future<List<Ayah>> getSurah(int number) async {
    if (_cache.containsKey(number)) return _cache[number]!;
    if (_loading.contains(number)) {
      // Wait briefly and retry — avoids parallel fetches.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return getSurah(number);
    }
    _loading.add(number);
    try {
      final List<Ayah> ayahs = await QuranService.instance.fetchSurah(number);
      _cache[number] = ayahs;
      return ayahs;
    } finally {
      _loading.remove(number);
    }
  }

  bool isLoading(int number) => _loading.contains(number);

  Future<void> setLastRead(int surah, int ayah) async {
    await StorageService.instance.setLastRead(surah: surah, ayah: ayah);
    _lastRead = StorageService.instance.lastRead;
    _currentStreak = StorageService.instance.currentStreak;
    _longestStreak = StorageService.instance.longestStreak;
    notifyListeners();
  }

  Future<void> toggleBookmark(String reference) async {
    await StorageService.instance.toggleAyahBookmark(reference);
    _bookmarks = StorageService.instance.bookmarkedAyahs;
    notifyListeners();
  }

  bool isBookmarked(String reference) => _bookmarks.contains(reference);
}
