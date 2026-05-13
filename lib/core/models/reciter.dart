class Reciter {
  const Reciter({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.style,
    required this.baseAudioUrl,
  });

  final String id;
  final String name;
  final String arabicName;
  final String style;
  final String baseAudioUrl;

  /// Returns audio URL for a specific surah using EveryAyah/QuranicAudio convention.
  String surahUrl(int surahNumber) {
    final String padded = surahNumber.toString().padLeft(3, '0');
    return '$baseAudioUrl/$padded.mp3';
  }
}
