import '../models/dhikr.dart';

/// Curated dhikr (remembrance) phrases — the foundational tasbih and
/// authentic Sunnah dhikr.
class DhikrData {
  DhikrData._();

  static const List<Dhikr> all = <Dhikr>[
    Dhikr(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'SubhanAllah',
      translation: 'Glory be to Allah',
      target: 33,
      virtue: 'Recited 33 times after each prayer · Sahih Muslim 597',
      colorHex: '#10B981',
    ),
    Dhikr(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      translation: 'All praise is for Allah',
      target: 33,
      virtue: 'Fills the scale of good deeds · Sahih Muslim 223',
      colorHex: '#34D399',
    ),
    Dhikr(
      id: 'allahu_akbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      translation: 'Allah is the Greatest',
      target: 34,
      virtue: 'Completes the post-prayer tasbih · Sahih Muslim 597',
      colorHex: '#D4AF37',
    ),
    Dhikr(
      id: 'la_ilaha_illa_allah',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illa Allah',
      translation: 'There is no deity but Allah',
      target: 100,
      virtue: 'The best dhikr · Jami\' at-Tirmidhi 3383',
      colorHex: '#34D399',
    ),
    Dhikr(
      id: 'astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
      translation: 'I seek forgiveness from Allah',
      target: 100,
      virtue: 'The Prophet ﷺ sought forgiveness 100 times daily · Sahih Muslim 2702',
      colorHex: '#E8C56A',
    ),
    Dhikr(
      id: 'subhanallahi_wa_bihamdihi',
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      translation: 'Glory be to Allah and praise be to Him',
      target: 100,
      virtue: 'Sins forgiven though they be like sea foam · Sahih al-Bukhari 6405',
      colorHex: '#10B981',
    ),
    Dhikr(
      id: 'subhanallah_al_adheem',
      arabic: 'سُبْحَانَ اللَّهِ الْعَظِيمِ',
      transliteration: 'SubhanAllahil-\'Adheem',
      translation: 'Glory be to Allah, the Magnificent',
      target: 100,
      virtue: 'Beloved to Ar-Rahman, light on the tongue · Sahih al-Bukhari 6406',
      colorHex: '#34D399',
    ),
    Dhikr(
      id: 'la_hawla_wa_la_quwwata',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      translation: 'There is no power nor strength except with Allah',
      target: 0,
      virtue: 'A treasure from the treasures of Paradise · Sahih al-Bukhari 6409',
      colorHex: '#D4AF37',
    ),
    Dhikr(
      id: 'salawat',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
      transliteration: 'Allahumma salli \'ala Muhammad',
      translation: 'O Allah, send blessings upon Muhammad ﷺ',
      target: 0,
      virtue: 'Allah blesses you ten times for each salawat · Sahih Muslim 408',
      colorHex: '#E8C56A',
    ),
    Dhikr(
      id: 'hasbiyallahu',
      arabic: 'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ',
      transliteration: 'Hasbiyallahu la ilaha illa hu',
      translation: 'Allah is sufficient for me; there is no deity but Him',
      target: 7,
      virtue: 'Suffices in worldly and otherworldly worries · Abu Dawud 5081',
      colorHex: '#10B981',
    ),
    Dhikr(
      id: 'la_ilaha_illa_allah_wahdahu',
      arabic:
          'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
      transliteration:
          'La ilaha illa Allah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa \'ala kulli shay\'in qadeer',
      translation:
          'There is no deity but Allah alone, with no partner. To Him belongs sovereignty and praise, and He is over all things capable.',
      target: 10,
      virtue: 'Like freeing 10 slaves · 100 good deeds · Sahih al-Bukhari 3293',
      colorHex: '#34D399',
    ),
    Dhikr(
      id: 'rabbi_zidni_ilma',
      arabic: 'رَبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni \'ilma',
      translation: 'My Lord, increase me in knowledge',
      target: 0,
      virtue: 'A short dua loved by seekers of knowledge · Quran 20:114',
      colorHex: '#E8C56A',
    ),
  ];

  static Dhikr byId(String id) =>
      all.firstWhere((Dhikr d) => d.id == id, orElse: () => all.first);
}
