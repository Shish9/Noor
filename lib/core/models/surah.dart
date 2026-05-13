class Surah {
  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.revelationPlace,
    required this.ayahCount,
    required this.meaning,
  });

  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final String revelationPlace; // 'Meccan' | 'Medinan'
  final int ayahCount;
  final String meaning;

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameTransliteration: json['nameTransliteration'] as String,
      revelationPlace: json['revelationPlace'] as String,
      ayahCount: json['ayahCount'] as int,
      meaning: json['meaning'] as String,
    );
  }
}

class Ayah {
  const Ayah({
    required this.surahNumber,
    required this.number,
    required this.arabic,
    required this.translation,
    required this.transliteration,
  });

  final int surahNumber;
  final int number;
  final String arabic;
  final String translation;
  final String transliteration;

  String get reference => 'Quran $surahNumber:$number';
}
