class Reciter {
  const Reciter({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.style,
    required this.baseAudioUrl,
    required this.everyAyahFolder,
  });

  final String id;
  final String name;
  final String arabicName;
  final String style;

  /// Base for whole-surah files (mp3quran.net). Used as a fallback for
  /// "play whole surah" mode.
  final String baseAudioUrl;

  /// Folder name under https://everyayah.com/data/ used for per-ayah audio
  /// playback (the only way to start from a specific ayah and seek between
  /// them reliably). Each reciter has a different folder.
  final String everyAyahFolder;

  /// Whole-surah file from mp3quran.net.
  String surahUrl(int surahNumber) {
    final String padded = surahNumber.toString().padLeft(3, '0');
    return '$baseAudioUrl/$padded.mp3';
  }

  /// Per-ayah file from everyayah.com — supports starting from any ayah
  /// and auto-advancing one ayah at a time.
  String ayahUrl(int surahNumber, int ayahNumber) {
    final String s = surahNumber.toString().padLeft(3, '0');
    final String a = ayahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/$everyAyahFolder/$s$a.mp3';
  }
}
