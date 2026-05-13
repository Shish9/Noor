import '../models/reciter.dart';

/// Curated reciter catalog. Audio CDN: mp3quran.net (each surah served as
/// a single .mp3 named `001.mp3` … `114.mp3`).
class ReciterData {
  ReciterData._();

  static const List<Reciter> all = <Reciter>[
    // Modern legends
    Reciter(
      id: 'mishary',
      name: 'Mishary Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
      style: 'Murattal · Soft & Soothing',
      baseAudioUrl: 'https://server8.mp3quran.net/afs',
    ),
    Reciter(
      id: 'sudais',
      name: 'Abdul Rahman Al-Sudais',
      arabicName: 'عبد الرحمن السديس',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server11.mp3quran.net/sds',
    ),
    Reciter(
      id: 'shuraim',
      name: 'Saud Al-Shuraim',
      arabicName: 'سعود الشريم',
      style: 'Murattal · Deep & Reflective',
      baseAudioUrl: 'https://server7.mp3quran.net/shur',
    ),
    Reciter(
      id: 'maher',
      name: 'Maher Al-Muaiqly',
      arabicName: 'ماهر المعيقلي',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server12.mp3quran.net/maher',
    ),
    Reciter(
      id: 'ghamdi',
      name: 'Saad Al-Ghamdi',
      arabicName: 'سعد الغامدي',
      style: 'Murattal · Melodious',
      baseAudioUrl: 'https://server7.mp3quran.net/s_gmd',
    ),
    Reciter(
      id: 'shatri',
      name: 'Abu Bakr Al-Shatri',
      arabicName: 'أبو بكر الشاطري',
      style: 'Murattal · Heartfelt',
      baseAudioUrl: 'https://server11.mp3quran.net/shatri',
    ),
    Reciter(
      id: 'rifai',
      name: 'Hani Ar-Rifai',
      arabicName: 'هاني الرفاعي',
      style: 'Murattal · Emotional',
      baseAudioUrl: 'https://server8.mp3quran.net/rifai',
    ),
    Reciter(
      id: 'dosari',
      name: 'Yasser Al-Dosari',
      arabicName: 'ياسر الدوسري',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server11.mp3quran.net/yasser',
    ),
    Reciter(
      id: 'qatami',
      name: 'Nasser Al-Qatami',
      arabicName: 'ناصر القطامي',
      style: 'Murattal · Crystalline',
      baseAudioUrl: 'https://server6.mp3quran.net/qtm',
    ),
    Reciter(
      id: 'ajmi',
      name: 'Ahmed Al-Ajmi',
      arabicName: 'أحمد العجمي',
      style: 'Murattal · Powerful',
      baseAudioUrl: 'https://server10.mp3quran.net/ajm',
    ),
    Reciter(
      id: 'juhany',
      name: 'Abdullah Al-Juhany',
      arabicName: 'عبد الله الجهني',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server13.mp3quran.net/jhn',
    ),

    // Classical masters
    Reciter(
      id: 'minshawi',
      name: 'Mohamed Siddiq El-Minshawi',
      arabicName: 'محمد صديق المنشاوي',
      style: 'Murattal · Classical Egyptian',
      baseAudioUrl: 'https://server10.mp3quran.net/minsh',
    ),
    Reciter(
      id: 'husary',
      name: 'Mahmoud Khalil Al-Husary',
      arabicName: 'محمود خليل الحصري',
      style: 'Murattal · Tajweed Master',
      baseAudioUrl: 'https://server13.mp3quran.net/husr',
    ),
    Reciter(
      id: 'basit',
      name: 'Abdul Basit Abdul Samad',
      arabicName: 'عبد الباسط عبد الصمد',
      style: 'Murattal · The Golden Voice',
      baseAudioUrl: 'https://server7.mp3quran.net/basit',
    ),
    Reciter(
      id: 'banna',
      name: 'Mahmoud Ali Al-Banna',
      arabicName: 'محمود علي البنا',
      style: 'Murattal · Classical Egyptian',
      baseAudioUrl: 'https://server16.mp3quran.net/banna',
    ),
  ];

  static Reciter byId(String id) =>
      all.firstWhere((Reciter r) => r.id == id, orElse: () => all.first);
}
