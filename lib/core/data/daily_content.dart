import '../models/surah.dart';

/// Curated rotation of daily ayahs and inspirational Islamic quotes.
class DailyContent {
  DailyContent._();

  static const List<Ayah> dailyAyahs = <Ayah>[
    Ayah(
      surahNumber: 2,
      number: 286,
      arabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
      translation: 'Allah does not burden a soul beyond that it can bear.',
      transliteration: 'La yukallifullahu nafsan illa wus\'aha',
    ),
    Ayah(
      surahNumber: 94,
      number: 6,
      arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
      translation: 'Indeed, with hardship there is ease.',
      transliteration: 'Fa inna ma\'al-\'usri yusra',
    ),
    Ayah(
      surahNumber: 13,
      number: 28,
      arabic: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      translation: 'Verily, in the remembrance of Allah do hearts find rest.',
      transliteration: 'Ala bi dhikrillahi tatma\'innul qulub',
    ),
    Ayah(
      surahNumber: 65,
      number: 3,
      arabic: 'وَمَن يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
      translation: 'And whoever places his trust in Allah, He will be sufficient for him.',
      transliteration: 'Wa man yatawakkal \'alallahi fa huwa hasbuh',
    ),
    Ayah(
      surahNumber: 2,
      number: 152,
      arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
      translation: 'So remember Me; I will remember you.',
      transliteration: 'Fadhkuruni adhkurkum',
    ),
    Ayah(
      surahNumber: 39,
      number: 53,
      arabic: 'لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ',
      translation: 'Do not despair of the mercy of Allah.',
      transliteration: 'La taqnatu min rahmatillah',
    ),
    Ayah(
      surahNumber: 3,
      number: 159,
      arabic: 'فَإِذَا عَزَمْتَ فَتَوَكَّلْ عَلَى اللَّهِ',
      translation: 'Once you have decided, place your trust in Allah.',
      transliteration: 'Fa idha \'azamta fatawakkal \'alallah',
    ),
  ];

  static Ayah ayahForToday() {
    final int index = DateTime.now().day % dailyAyahs.length;
    return dailyAyahs[index];
  }

  static const List<String> quotes = <String>[
    'The best among you are those who have the best manners. — Prophet Muhammad ﷺ',
    'Allah is with those who are patient.',
    'When you cannot pray as you wish, pray as you can.',
    'Speak good, or remain silent.',
    'Be in this world as if you were a stranger or a traveler.',
    'Verily, deeds are by intentions.',
  ];

  static String quoteForToday() {
    final int index = DateTime.now().day % quotes.length;
    return quotes[index];
  }
}
