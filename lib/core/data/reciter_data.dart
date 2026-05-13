import '../models/reciter.dart';

/// Curated reciter catalog.
///
/// Whole-surah audio: mp3quran.net (one .mp3 per surah: 001.mp3 … 114.mp3).
/// Per-ayah audio:    everyayah.com/data/<folder>/<sss><aaa>.mp3
///                    e.g. https://everyayah.com/data/Alafasy_128kbps/067001.mp3
class ReciterData {
  ReciterData._();

  static const List<Reciter> all = <Reciter>[
    Reciter(
      id: 'mishary',
      name: 'Mishary Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
      style: 'Murattal · Soft & Soothing',
      baseAudioUrl: 'https://server8.mp3quran.net/afs',
      everyAyahFolder: 'Alafasy_128kbps',
    ),
    Reciter(
      id: 'sudais',
      name: 'Abdul Rahman Al-Sudais',
      arabicName: 'عبد الرحمن السديس',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server11.mp3quran.net/sds',
      everyAyahFolder: 'Abdurrahmaan_As-Sudais_192kbps',
    ),
    Reciter(
      id: 'shuraim',
      name: 'Saud Al-Shuraim',
      arabicName: 'سعود الشريم',
      style: 'Murattal · Deep & Reflective',
      baseAudioUrl: 'https://server7.mp3quran.net/shur',
      everyAyahFolder: 'Saood_ash-Shuraym_128kbps',
    ),
    Reciter(
      id: 'maher',
      name: 'Maher Al-Muaiqly',
      arabicName: 'ماهر المعيقلي',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server12.mp3quran.net/maher',
      everyAyahFolder: 'MaherAlMuaiqly128kbps',
    ),
    Reciter(
      id: 'ghamdi',
      name: 'Saad Al-Ghamdi',
      arabicName: 'سعد الغامدي',
      style: 'Murattal · Melodious',
      baseAudioUrl: 'https://server7.mp3quran.net/s_gmd',
      everyAyahFolder: 'Ghamadi_40kbps',
    ),
    Reciter(
      id: 'shatri',
      name: 'Abu Bakr Al-Shatri',
      arabicName: 'أبو بكر الشاطري',
      style: 'Murattal · Heartfelt',
      baseAudioUrl: 'https://server11.mp3quran.net/shatri',
      everyAyahFolder: 'Abu_Bakr_Ash-Shaatree_128kbps',
    ),
    Reciter(
      id: 'rifai',
      name: 'Hani Ar-Rifai',
      arabicName: 'هاني الرفاعي',
      style: 'Murattal · Emotional',
      baseAudioUrl: 'https://server8.mp3quran.net/rifai',
      everyAyahFolder: 'Hani_Rifai_192kbps',
    ),
    Reciter(
      id: 'dosari',
      name: 'Yasser Al-Dosari',
      arabicName: 'ياسر الدوسري',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server11.mp3quran.net/yasser',
      everyAyahFolder: 'Yasser_Ad-Dussary_128kbps',
    ),
    Reciter(
      id: 'qatami',
      name: 'Nasser Al-Qatami',
      arabicName: 'ناصر القطامي',
      style: 'Murattal · Crystalline',
      baseAudioUrl: 'https://server6.mp3quran.net/qtm',
      everyAyahFolder: 'Nasser_Alqatami_128kbps',
    ),
    Reciter(
      id: 'ajmi',
      name: 'Ahmed Al-Ajmi',
      arabicName: 'أحمد العجمي',
      style: 'Murattal · Powerful',
      baseAudioUrl: 'https://server10.mp3quran.net/ajm',
      everyAyahFolder: 'ahmed_ibn_ali_al_ajamy_128kbps',
    ),
    Reciter(
      id: 'juhany',
      name: 'Abdullah Al-Juhany',
      arabicName: 'عبد الله الجهني',
      style: 'Murattal · Imam of Makkah',
      baseAudioUrl: 'https://server13.mp3quran.net/jhn',
      everyAyahFolder: 'Abdullaah_3awwaad_Al-Juhaynee_128kbps',
    ),
    Reciter(
      id: 'minshawi',
      name: 'Mohamed Siddiq El-Minshawi',
      arabicName: 'محمد صديق المنشاوي',
      style: 'Murattal · Classical Egyptian',
      baseAudioUrl: 'https://server10.mp3quran.net/minsh',
      everyAyahFolder: 'Minshawy_Mujawwad_192kbps',
    ),
    Reciter(
      id: 'husary',
      name: 'Mahmoud Khalil Al-Husary',
      arabicName: 'محمود خليل الحصري',
      style: 'Murattal · Tajweed Master',
      baseAudioUrl: 'https://server13.mp3quran.net/husr',
      everyAyahFolder: 'Husary_128kbps',
    ),
    Reciter(
      id: 'basit',
      name: 'Abdul Basit Abdul Samad',
      arabicName: 'عبد الباسط عبد الصمد',
      style: 'Murattal · The Golden Voice',
      baseAudioUrl: 'https://server7.mp3quran.net/basit',
      everyAyahFolder: 'Abdul_Basit_Murattal_192kbps',
    ),
    Reciter(
      id: 'banna',
      name: 'Mahmoud Ali Al-Banna',
      arabicName: 'محمود علي البنا',
      style: 'Murattal · Classical Egyptian',
      baseAudioUrl: 'https://server16.mp3quran.net/banna',
      everyAyahFolder: 'mahmoud_ali_al-banna_32kbps',
    ),
  ];

  static Reciter byId(String id) =>
      all.firstWhere((Reciter r) => r.id == id, orElse: () => all.first);
}
