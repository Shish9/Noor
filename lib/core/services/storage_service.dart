import 'package:hive_flutter/hive_flutter.dart';

/// Local persistent storage wrapper using Hive.
///
/// Boxes:
///   - prefs: user settings (theme, locale, font size, intervals)
///   - bookmarks: ayah and dua bookmarks
///   - reading: last read position, streaks, history
///   - downloads: offline-cached surahs metadata
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late Box<dynamic> prefs;
  late Box<dynamic> bookmarks;
  late Box<dynamic> reading;
  late Box<dynamic> downloads;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    prefs = await Hive.openBox<dynamic>('prefs');
    bookmarks = await Hive.openBox<dynamic>('bookmarks');
    reading = await Hive.openBox<dynamic>('reading');
    downloads = await Hive.openBox<dynamic>('downloads');
    _initialized = true;
  }

  // --- Settings ---
  T? getPref<T>(String key, {T? fallback}) {
    final dynamic v = prefs.get(key);
    return v as T? ?? fallback;
  }

  Future<void> setPref(String key, dynamic value) => prefs.put(key, value);

  // --- Reading ---
  Map<String, dynamic>? get lastRead {
    final dynamic raw = reading.get('last_read');
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map<dynamic, dynamic>);
  }

  Future<void> setLastRead({required int surah, required int ayah}) async {
    await reading.put('last_read', <String, dynamic>{
      'surah': surah,
      'ayah': ayah,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    await _bumpStreak();
  }

  int get currentStreak => (reading.get('streak_count') as int?) ?? 0;
  int get longestStreak => (reading.get('streak_longest') as int?) ?? 0;
  DateTime? get lastReadDate {
    final int? ts = reading.get('streak_last_date') as int?;
    if (ts == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ts);
  }

  Future<void> _bumpStreak() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime? last = lastReadDate;

    int streak = currentStreak;
    if (last == null) {
      streak = 1;
    } else {
      final DateTime lastDay = DateTime(last.year, last.month, last.day);
      final int diff = today.difference(lastDay).inDays;
      if (diff == 0) {
        // Already counted today
      } else if (diff == 1) {
        streak += 1;
      } else {
        streak = 1;
      }
    }

    final int longest = streak > longestStreak ? streak : longestStreak;
    await reading.putAll(<String, dynamic>{
      'streak_count': streak,
      'streak_longest': longest,
      'streak_last_date': today.millisecondsSinceEpoch,
    });
  }

  // --- Bookmarks ---
  List<String> get bookmarkedAyahs =>
      List<String>.from((bookmarks.get('ayahs') as List<dynamic>?) ?? <dynamic>[]);
  List<String> get bookmarkedDuas =>
      List<String>.from((bookmarks.get('duas') as List<dynamic>?) ?? <dynamic>[]);

  Future<void> toggleAyahBookmark(String ref) async {
    final List<String> list = bookmarkedAyahs;
    if (list.contains(ref)) {
      list.remove(ref);
    } else {
      list.add(ref);
    }
    await bookmarks.put('ayahs', list);
  }

  Future<void> toggleDuaBookmark(String id) async {
    final List<String> list = bookmarkedDuas;
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    await bookmarks.put('duas', list);
  }

  bool isAyahBookmarked(String ref) => bookmarkedAyahs.contains(ref);
  bool isDuaBookmarked(String id) => bookmarkedDuas.contains(id);

  // --- Tafsir favorites ---
  List<String> get favoriteTafsirs =>
      List<String>.from((bookmarks.get('tafsirs') as List<dynamic>?) ?? <dynamic>[]);

  Future<void> toggleTafsirFavorite(String reference) async {
    final List<String> list = favoriteTafsirs;
    if (list.contains(reference)) {
      list.remove(reference);
    } else {
      list.add(reference);
    }
    await bookmarks.put('tafsirs', list);
  }

  bool isTafsirFavorite(String reference) =>
      favoriteTafsirs.contains(reference);

  // --- Dhikr counters ---
  /// Returns counts keyed by dhikr id.
  Map<String, int> get dhikrCounts {
    final dynamic raw = reading.get('dhikr_counts');
    if (raw == null) return <String, int>{};
    return Map<String, int>.from(raw as Map<dynamic, dynamic>);
  }

  Future<void> incrementDhikr(String id) async {
    final Map<String, int> counts = dhikrCounts;
    counts[id] = (counts[id] ?? 0) + 1;
    await reading.put('dhikr_counts', counts);
    await _bumpDhikrTotalToday();
  }

  Future<void> resetDhikr(String id) async {
    final Map<String, int> counts = dhikrCounts;
    counts.remove(id);
    await reading.put('dhikr_counts', counts);
  }

  Future<void> resetAllDhikr() async {
    await reading.put('dhikr_counts', <String, int>{});
  }

  /// Total dhikrs counted today (rolls over each day).
  int get dhikrToday {
    final int? ts = reading.get('dhikr_today_date') as int?;
    if (ts == null) return 0;
    final DateTime stored = DateTime.fromMillisecondsSinceEpoch(ts);
    final DateTime now = DateTime.now();
    if (stored.year != now.year ||
        stored.month != now.month ||
        stored.day != now.day) {
      return 0;
    }
    return (reading.get('dhikr_today_count') as int?) ?? 0;
  }

  Future<void> _bumpDhikrTotalToday() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final int? ts = reading.get('dhikr_today_date') as int?;
    int count = 1;
    if (ts != null) {
      final DateTime stored = DateTime.fromMillisecondsSinceEpoch(ts);
      if (stored.year == today.year &&
          stored.month == today.month &&
          stored.day == today.day) {
        count = ((reading.get('dhikr_today_count') as int?) ?? 0) + 1;
      }
    }
    await reading.putAll(<String, dynamic>{
      'dhikr_today_date': today.millisecondsSinceEpoch,
      'dhikr_today_count': count,
    });
  }

  // --- Tafsir last read position ---
  Map<String, dynamic>? get lastTafsirRead {
    final dynamic raw = reading.get('last_tafsir');
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map<dynamic, dynamic>);
  }

  Future<void> setLastTafsirRead({required int surah, required int ayah}) async {
    await reading.put('last_tafsir', <String, dynamic>{
      'surah': surah,
      'ayah': ayah,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // --- Recently played ---
  List<Map<String, dynamic>> get recentlyPlayed {
    final List<dynamic> raw = (reading.get('recently_played') as List<dynamic>?) ?? <dynamic>[];
    return raw
        .map((dynamic e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
        .toList();
  }

  Future<void> addRecentlyPlayed({
    required int surahNumber,
    required String reciterId,
  }) async {
    final List<Map<String, dynamic>> list = recentlyPlayed;
    list.removeWhere((Map<String, dynamic> e) =>
        e['surah'] == surahNumber && e['reciter'] == reciterId);
    list.insert(0, <String, dynamic>{
      'surah': surahNumber,
      'reciter': reciterId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    if (list.length > 8) list.removeRange(8, list.length);
    await reading.put('recently_played', list);
  }
}
