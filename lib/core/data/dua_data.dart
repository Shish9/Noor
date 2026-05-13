import 'package:flutter/material.dart';

import '../models/dua.dart';

class DuaData {
  DuaData._();

  static const List<DuaCategory> categories = <DuaCategory>[
    DuaCategory(
      id: 'anxiety',
      name: 'Anxiety & Stress',
      subtitle: 'Find calm in remembrance',
      icon: 'spa',
      gradientStartHex: '#10B981',
      gradientEndHex: '#047857',
    ),
    DuaCategory(
      id: 'patience',
      name: 'Patience',
      subtitle: 'Strength through hardship',
      icon: 'self_improvement',
      gradientStartHex: '#D4AF37',
      gradientEndHex: '#9A7B1B',
    ),
    DuaCategory(
      id: 'forgiveness',
      name: 'Forgiveness',
      subtitle: 'Return to your Lord',
      icon: 'favorite',
      gradientStartHex: '#34D399',
      gradientEndHex: '#10B981',
    ),
    DuaCategory(
      id: 'rizq',
      name: 'Rizq (Provision)',
      subtitle: 'Sustenance & blessings',
      icon: 'eco',
      gradientStartHex: '#E8C56A',
      gradientEndHex: '#D4AF37',
    ),
    DuaCategory(
      id: 'sleep',
      name: 'Sleep',
      subtitle: 'Peaceful rest, protected nights',
      icon: 'nightlight',
      gradientStartHex: '#10B981',
      gradientEndHex: '#064E3B',
    ),
    DuaCategory(
      id: 'protection',
      name: 'Protection',
      subtitle: 'Shielded by His mercy',
      icon: 'shield',
      gradientStartHex: '#34D399',
      gradientEndHex: '#047857',
    ),
    DuaCategory(
      id: 'sadness',
      name: 'Sadness',
      subtitle: 'Comfort in His remembrance',
      icon: 'water_drop',
      gradientStartHex: '#D4AF37',
      gradientEndHex: '#064E3B',
    ),
    DuaCategory(
      id: 'gratitude',
      name: 'Gratitude',
      subtitle: 'Thank Him for every breath',
      icon: 'auto_awesome',
      gradientStartHex: '#F4D88A',
      gradientEndHex: '#10B981',
    ),
    DuaCategory(
      id: 'healing',
      name: 'Healing',
      subtitle: 'Cure for body and soul',
      icon: 'healing',
      gradientStartHex: '#34D399',
      gradientEndHex: '#064E3B',
    ),
    DuaCategory(
      id: 'knowledge',
      name: 'Knowledge',
      subtitle: 'Light for the seeker',
      icon: 'school',
      gradientStartHex: '#E8C56A',
      gradientEndHex: '#9A7B1B',
    ),
    DuaCategory(
      id: 'travel',
      name: 'Travel',
      subtitle: 'Safe paths, easy returns',
      icon: 'flight',
      gradientStartHex: '#10B981',
      gradientEndHex: '#1F4F47',
    ),
    DuaCategory(
      id: 'family',
      name: 'Family',
      subtitle: 'Love, unity & blessings',
      icon: 'family',
      gradientStartHex: '#D4AF37',
      gradientEndHex: '#10B981',
    ),
    DuaCategory(
      id: 'jumua',
      name: 'Friday (Jumu\'ah)',
      subtitle: 'The blessed day',
      icon: 'mosque',
      gradientStartHex: '#34D399',
      gradientEndHex: '#D4AF37',
    ),
    DuaCategory(
      id: 'morning',
      name: 'Morning Adhkar',
      subtitle: 'Begin your day with light',
      icon: 'wb_sunny',
      gradientStartHex: '#F4D88A',
      gradientEndHex: '#D4AF37',
    ),
    DuaCategory(
      id: 'evening',
      name: 'Evening Adhkar',
      subtitle: 'Seal your day in peace',
      icon: 'bedtime',
      gradientStartHex: '#10B981',
      gradientEndHex: '#0B0D10',
    ),
  ];

  static DuaCategory categoryById(String id) =>
      categories.firstWhere((DuaCategory c) => c.id == id, orElse: () => categories.first);

  static IconData iconForCategory(String iconName) {
    switch (iconName) {
      case 'spa': return Icons.spa_rounded;
      case 'self_improvement': return Icons.self_improvement_rounded;
      case 'favorite': return Icons.favorite_rounded;
      case 'eco': return Icons.eco_rounded;
      case 'nightlight': return Icons.nightlight_round;
      case 'shield': return Icons.shield_rounded;
      case 'water_drop': return Icons.water_drop_rounded;
      case 'wb_sunny': return Icons.wb_sunny_rounded;
      case 'bedtime': return Icons.bedtime_rounded;
      case 'auto_awesome': return Icons.auto_awesome_rounded;
      case 'healing': return Icons.healing_rounded;
      case 'school': return Icons.school_rounded;
      case 'flight': return Icons.flight_rounded;
      case 'family': return Icons.family_restroom_rounded;
      case 'mosque': return Icons.mosque_rounded;
      default: return Icons.menu_book_rounded;
    }
  }

  static const List<Dua> all = <Dua>[
    // ─────────────────────────── Anxiety & Stress ───────────────────────────
    Dua(
      id: 'anxiety_1',
      categoryId: 'anxiety',
      title: 'Dua for Anxiety',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ',
      transliteration: 'Allahumma inni a\'udhu bika minal-hammi wal-hazan, wa a\'udhu bika minal-\'ajzi wal-kasal',
      translation: 'O Allah, I seek refuge in You from anxiety and sorrow, and I seek refuge in You from weakness and laziness.',
      reference: 'Sahih al-Bukhari 6369',
    ),
    Dua(
      id: 'anxiety_2',
      categoryId: 'anxiety',
      title: 'When Distressed',
      arabic: 'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ',
      transliteration: 'La ilaha illallahul-\'Adheemul-Haleem, la ilaha illallahu Rabbul-\'Arshil-\'Adheem',
      translation: 'There is no deity worthy of worship except Allah, the Magnificent, the Forbearing. There is no deity worthy of worship except Allah, Lord of the Magnificent Throne.',
      reference: 'Sahih al-Bukhari 6346',
    ),
    Dua(
      id: 'anxiety_3',
      categoryId: 'anxiety',
      title: 'Sufficient is Allah',
      arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal-wakeel',
      translation: 'Sufficient for us is Allah, and He is the best Disposer of affairs.',
      reference: 'Quran 3:173',
    ),
    Dua(
      id: 'anxiety_4',
      categoryId: 'anxiety',
      title: 'Yunus\'s Dua',
      arabic: 'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
      transliteration: 'La ilaha illa anta subhanaka inni kuntu minadh-dhalimeen',
      translation: 'There is no deity except You; exalted are You. Indeed, I have been of the wrongdoers.',
      reference: 'Quran 21:87',
    ),
    Dua(
      id: 'anxiety_5',
      categoryId: 'anxiety',
      title: 'When Overwhelmed',
      arabic: 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ',
      transliteration: 'Ya Hayyu ya Qayyum, bi rahmatika astagheeth, aslih li sha\'ni kullahu, wa la takilni ila nafsi tarfata \'ayn',
      translation: 'O Ever-Living, O Self-Sustaining, I seek help through Your mercy. Set right all my affairs, and do not leave me to myself for the blink of an eye.',
      reference: 'Sunan an-Nasa\'i, al-Hakim',
    ),
    Dua(
      id: 'anxiety_6',
      categoryId: 'anxiety',
      title: 'For Ease',
      arabic: 'اللَّهُمَّ لَا سَهْلَ إِلَّا مَا جَعَلْتَهُ سَهْلًا، وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلًا',
      transliteration: 'Allahumma la sahla illa ma ja\'altahu sahla, wa anta taj\'alul-hazna idha shi\'ta sahla',
      translation: 'O Allah, nothing is easy except what You make easy, and You make the difficult easy if You will.',
      reference: 'Ibn Hibban',
    ),

    // ───────────────────────────── Patience ─────────────────────────────────
    Dua(
      id: 'patience_1',
      categoryId: 'patience',
      title: 'Pour Patience Upon Us',
      arabic: 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَثَبِّتْ أَقْدَامَنَا',
      transliteration: 'Rabbana afrigh \'alayna sabran wa thabbit aqdamana',
      translation: 'Our Lord, pour upon us patience and plant firmly our feet.',
      reference: 'Quran 2:250',
    ),
    Dua(
      id: 'patience_2',
      categoryId: 'patience',
      title: 'In Times of Trial',
      arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ، اللَّهُمَّ أْجُرْنِي فِي مُصِيبَتِي وَأَخْلِفْ لِي خَيْرًا مِنْهَا',
      transliteration: 'Inna lillahi wa inna ilayhi raji\'un, Allahumma ajurni fi musibati wa akhlif li khayran minha',
      translation: 'Indeed we belong to Allah and indeed to Him we will return. O Allah, reward me in this affliction and replace it for me with something better.',
      reference: 'Sahih Muslim 918',
    ),
    Dua(
      id: 'patience_3',
      categoryId: 'patience',
      title: 'Steadfastness',
      arabic: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً',
      transliteration: 'Rabbana la tuzigh quloobana ba\'da idh hadaytana wa hab lana min ladunka rahmah',
      translation: 'Our Lord, let not our hearts deviate after You have guided us, and grant us from Yourself mercy.',
      reference: 'Quran 3:8',
    ),
    Dua(
      id: 'patience_4',
      categoryId: 'patience',
      title: 'Strength of Heart',
      arabic: 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ',
      transliteration: 'Ya muqallibal-quloob, thabbit qalbi \'ala deenik',
      translation: 'O Turner of hearts, keep my heart firm upon Your religion.',
      reference: 'Jami\' at-Tirmidhi 3522',
    ),
    Dua(
      id: 'patience_5',
      categoryId: 'patience',
      title: 'Rely Upon Him',
      arabic: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ۖ عَلَيْهِ تَوَكَّلْتُ ۖ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      transliteration: 'Hasbiyallahu la ilaha illa hu, \'alayhi tawakkaltu wa huwa Rabbul-\'arshil-\'adheem',
      translation: 'Allah is sufficient for me. There is no deity except Him. On Him I have relied, and He is the Lord of the Mighty Throne.',
      reference: 'Quran 9:129',
    ),

    // ─────────────────────────── Forgiveness ────────────────────────────────
    Dua(
      id: 'forgiveness_1',
      categoryId: 'forgiveness',
      title: 'Sayyidul Istighfar',
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ',
      transliteration: 'Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana \'abduka, wa ana \'ala \'ahdika wa wa\'dika mastata\'tu, a\'udhu bika min sharri ma sana\'tu',
      translation: 'O Allah, You are my Lord, none has the right to be worshipped but You. You created me and I am Your servant, and I keep Your covenant and promise as best I can. I seek refuge in You from the evil of what I have done.',
      reference: 'Sahih al-Bukhari 6306',
    ),
    Dua(
      id: 'forgiveness_2',
      categoryId: 'forgiveness',
      title: 'Lord, Forgive Me',
      arabic: 'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      transliteration: 'Rabbighfir li wa tub \'alayya innaka antat-Tawwabur-Raheem',
      translation: 'My Lord, forgive me and accept my repentance. Indeed, You are the Acceptor of repentance, the Merciful.',
      reference: 'Sunan Abi Dawud 1516',
    ),
    Dua(
      id: 'forgiveness_3',
      categoryId: 'forgiveness',
      title: 'Wronged Myself',
      arabic: 'رَبَّنَا ظَلَمْنَا أَنفُسَنَا وَإِن لَّمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
      transliteration: 'Rabbana dhalamna anfusana wa in lam taghfir lana wa tarhamna lanakunanna minal-khasirin',
      translation: 'Our Lord, we have wronged ourselves, and if You do not forgive us and have mercy upon us, we will surely be among the losers.',
      reference: 'Quran 7:23',
    ),
    Dua(
      id: 'forgiveness_4',
      categoryId: 'forgiveness',
      title: 'A Heart Drawn Back',
      arabic: 'رَبِّ اغْفِرْ لِي خَطِيئَتِي وَجَهْلِي، وَإِسْرَافِي فِي أَمْرِي، وَمَا أَنْتَ أَعْلَمُ بِهِ مِنِّي',
      transliteration: 'Rabbighfir li khati\'ati wa jahli, wa israfi fi amri, wa ma anta a\'lamu bihi minni',
      translation: 'My Lord, forgive me my errors, my ignorance, my excess in my affairs, and what You know better about me than I do.',
      reference: 'Sahih al-Bukhari 6398',
    ),
    Dua(
      id: 'forgiveness_5',
      categoryId: 'forgiveness',
      title: 'Pardon Me',
      arabic: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
      transliteration: 'Allahumma innaka \'afuwwun kareem, tuhibbul-\'afwa fa\'fu \'anni',
      translation: 'O Allah, You are the Pardoner, the Generous, You love to pardon — so pardon me.',
      reference: 'Jami\' at-Tirmidhi 3513',
    ),

    // ─────────────────────────────── Rizq ──────────────────────────────────
    Dua(
      id: 'rizq_1',
      categoryId: 'rizq',
      title: 'Lawful Provision',
      arabic: 'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      transliteration: 'Allahumma akfini bi halalika \'an haramika, wa aghnini bi fadlika \'amman siwaka',
      translation: 'O Allah, suffice me with what You have made lawful instead of what You have made unlawful, and make me independent of all others besides You.',
      reference: 'Jami\' at-Tirmidhi 3563',
    ),
    Dua(
      id: 'rizq_2',
      categoryId: 'rizq',
      title: 'Goodness in This Life & Next',
      arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
      transliteration: 'Rabbana atina fid-dunya hasanah wa fil-akhirati hasanah wa qina \'adhaban-nar',
      translation: 'Our Lord, give us in this world good and in the Hereafter good, and protect us from the punishment of the Fire.',
      reference: 'Quran 2:201',
    ),
    Dua(
      id: 'rizq_3',
      categoryId: 'rizq',
      title: 'Open the Doors',
      arabic: 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ',
      transliteration: 'Allahummaftah li abwaba rahmatika',
      translation: 'O Allah, open for me the doors of Your mercy.',
      reference: 'Sahih Muslim 713',
    ),
    Dua(
      id: 'rizq_4',
      categoryId: 'rizq',
      title: 'Best of Provision',
      arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',
      transliteration: 'Allahumma inni as\'aluka \'ilman nafi\'an, wa rizqan tayyiban, wa \'amalan mutaqabbala',
      translation: 'O Allah, I ask You for beneficial knowledge, good provision, and accepted deeds.',
      reference: 'Ibn Majah 925',
    ),
    Dua(
      id: 'rizq_5',
      categoryId: 'rizq',
      title: 'Treasures of the Heavens',
      arabic: 'اللَّهُمَّ رَبَّ السَّمَاوَاتِ وَرَبَّ الْأَرْضِ وَرَبَّ كُلِّ شَيْءٍ، أَنْتَ الَّذِي رَزَقْتَنِي',
      transliteration: 'Allahumma Rabbas-samawati wa Rabbal-ardi wa Rabba kulli shay\', antal-ladhi razaqtani',
      translation: 'O Allah, Lord of the heavens and the earth and Lord of all things — You are the One who has provided for me.',
      reference: 'Authentic Sunnah',
    ),

    // ─────────────────────────────── Sleep ─────────────────────────────────
    Dua(
      id: 'sleep_1',
      categoryId: 'sleep',
      title: 'Before Sleeping',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      transliteration: 'Bismika Allahumma amutu wa ahya',
      translation: 'In Your name, O Allah, I die and I live.',
      reference: 'Sahih al-Bukhari 6324',
    ),
    Dua(
      id: 'sleep_2',
      categoryId: 'sleep',
      title: 'Entrusting the Soul',
      arabic: 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ',
      transliteration: 'Allahumma aslamtu nafsi ilayk, wa fawwadtu amri ilayk, wa alja\'tu dhahri ilayk, raghbatan wa rahbatan ilayk',
      translation: 'O Allah, I submit my soul to You, entrust my affair to You, and rely upon You — out of hope in You and fear of You.',
      reference: 'Sahih al-Bukhari 247',
    ),
    Dua(
      id: 'sleep_3',
      categoryId: 'sleep',
      title: 'Upon Waking',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
      transliteration: 'Alhamdu lillahil-ladhi ahyana ba\'da ma amatana wa ilayhin-nushur',
      translation: 'Praise is to Allah who has brought us back to life after causing us to die, and to Him is the resurrection.',
      reference: 'Sahih al-Bukhari 6312',
    ),
    Dua(
      id: 'sleep_4',
      categoryId: 'sleep',
      title: 'Against Bad Dreams',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati min ghadabihi wa \'iqabihi, wa sharri \'ibadihi, wa min hamazatish-shayatin',
      translation: 'I seek refuge in the perfect words of Allah from His wrath and punishment, from the evil of His servants, and from the whisperings of devils.',
      reference: 'Abu Dawud 3893',
    ),

    // ─────────────────────────── Protection ─────────────────────────────────
    Dua(
      id: 'protection_1',
      categoryId: 'protection',
      title: 'Refuge from Evil',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati min sharri ma khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      reference: 'Sahih Muslim 2708',
    ),
    Dua(
      id: 'protection_2',
      categoryId: 'protection',
      title: 'Morning & Evening Shield',
      arabic: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
      transliteration: 'Bismillahil-ladhi la yadurru ma\'asmihi shay\'un fil-ardi wa la fis-sama\'i wa Huwas-Samee\'ul-\'Aleem',
      translation: 'In the name of Allah with whose name nothing on earth or in the heaven can cause harm — and He is the All-Hearing, the All-Knowing.',
      reference: 'Sunan Abi Dawud 5088',
    ),
    Dua(
      id: 'protection_3',
      categoryId: 'protection',
      title: 'From Every Direction',
      arabic: 'اللَّهُمَّ احْفَظْنِي مِنْ بَيْنِ يَدَيَّ، وَمِنْ خَلْفِي، وَعَنْ يَمِينِي، وَعَنْ شِمَالِي، وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي',
      transliteration: 'Allahumma ihfadhni min bayni yadayya, wa min khalfi, wa \'an yameeni, wa \'an shimali, wa min fawqi, wa a\'udhu bi \'adhamatika an ughtala min tahti',
      translation: 'O Allah, protect me from in front of me, behind me, on my right, on my left, and from above me; and I seek refuge in Your greatness from being struck down from beneath me.',
      reference: 'Abu Dawud 5074',
    ),
    Dua(
      id: 'protection_4',
      categoryId: 'protection',
      title: 'Three Refuges',
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۞ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۞ قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
      transliteration: 'Qul Huwallahu ahad / Qul a\'udhu bi Rabbil-falaq / Qul a\'udhu bi Rabbin-nas',
      translation: 'Recite Surahs Al-Ikhlas, Al-Falaq, and An-Nas — three times each, morning and evening.',
      reference: 'Abu Dawud 5082',
    ),
    Dua(
      id: 'protection_5',
      categoryId: 'protection',
      title: 'Family Protection',
      arabic: 'أُعِيذُكُمْ بِكَلِمَاتِ اللَّهِ التَّامَّةِ مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
      transliteration: 'U\'eedhukum bi kalimatillahit-tammah, min kulli shaytanin wa hammah, wa min kulli \'aynin lammah',
      translation: 'I seek refuge for you in the perfect words of Allah, from every devil and venomous creature, and from every evil eye.',
      reference: 'Sahih al-Bukhari 3371',
    ),

    // ────────────────────────────── Sadness ─────────────────────────────────
    Dua(
      id: 'sadness_1',
      categoryId: 'sadness',
      title: 'For Inner Peace',
      arabic: 'اللَّهُمَّ إِنِّي عَبْدُكَ، وَابْنُ عَبْدِكَ، وَابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ',
      transliteration: 'Allahumma inni \'abduka, wabnu \'abdika, wabnu amatika, nasiyati biyadika, madin fiyya hukmuka, \'adlun fiyya qada\'uka',
      translation: 'O Allah, I am Your servant, son of Your servant, son of Your female servant. My forelock is in Your hand. Your command over me is forever executed and Your decree over me is just.',
      reference: 'Musnad Ahmad 3712',
    ),
    Dua(
      id: 'sadness_2',
      categoryId: 'sadness',
      title: 'Light in Darkness',
      arabic: 'اللَّهُمَّ اجْعَلْ فِي قَلْبِي نُورًا، وَفِي بَصَرِي نُورًا، وَفِي سَمْعِي نُورًا، وَعَنْ يَمِينِي نُورًا، وَعَنْ يَسَارِي نُورًا',
      transliteration: 'Allahumma j\'al fi qalbi noora, wa fi basari noora, wa fi sam\'i noora, wa \'an yameeni noora, wa \'an yasari noora',
      translation: 'O Allah, place light in my heart, light in my sight, light in my hearing, light to my right, and light to my left.',
      reference: 'Sahih al-Bukhari 6316',
    ),
    Dua(
      id: 'sadness_3',
      categoryId: 'sadness',
      title: 'Lift the Burden',
      arabic: 'رَبِّ اشْرَحْ لِي صَدْرِي ۞ وَيَسِّرْ لِي أَمْرِي ۞ وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي ۞ يَفْقَهُوا قَوْلِي',
      transliteration: 'Rabbish-rah li sadri / wa yassir li amri / wahlul \'uqdatan min lisani / yafqahu qawli',
      translation: 'My Lord, expand for me my chest, ease for me my task, and untie the knot from my tongue, that they may understand my speech.',
      reference: 'Quran 20:25–28',
    ),

    // ────────────────────────────── Gratitude ───────────────────────────────
    Dua(
      id: 'gratitude_1',
      categoryId: 'gratitude',
      title: 'Help Me Give Thanks',
      arabic: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ، وَشُكْرِكَ، وَحُسْنِ عِبَادَتِكَ',
      transliteration: 'Allahumma a\'inni \'ala dhikrika, wa shukrika, wa husni \'ibadatika',
      translation: 'O Allah, help me to remember You, to thank You, and to worship You in the best manner.',
      reference: 'Abu Dawud 1522',
    ),
    Dua(
      id: 'gratitude_2',
      categoryId: 'gratitude',
      title: 'For Every Blessing',
      arabic: 'اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ، فَمِنْكَ وَحْدَكَ لَا شَرِيكَ لَكَ، فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ',
      transliteration: 'Allahumma ma asbaha bi min ni\'matin aw bi ahadin min khalqika, faminka wahdaka la sharika lak, falakal-hamdu walakash-shukr',
      translation: 'O Allah, whatever blessing has come to me or anyone of Your creation this morning is from You alone, without partner. To You is all praise and all thanks.',
      reference: 'Abu Dawud 5073',
    ),
    Dua(
      id: 'gratitude_3',
      categoryId: 'gratitude',
      title: 'Praise Beyond Measure',
      arabic: 'الْحَمْدُ لِلَّهِ حَمْدًا كَثِيرًا طَيِّبًا مُبَارَكًا فِيهِ',
      transliteration: 'Alhamdu lillahi hamdan katheeran tayyiban mubarakan fih',
      translation: 'All praise is for Allah, abundant praise, pure and full of blessing.',
      reference: 'Sahih al-Bukhari 799',
    ),
    Dua(
      id: 'gratitude_4',
      categoryId: 'gratitude',
      title: 'Sulayman\'s Gratitude',
      arabic: 'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَىٰ وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحًا تَرْضَاهُ',
      transliteration: 'Rabbi awzi\'ni an ashkura ni\'mataka allati an\'amta \'alayya wa \'ala walidayya wa an a\'mala salihan tardah',
      translation: 'My Lord, enable me to be grateful for Your favor which You have bestowed upon me and upon my parents, and to do righteousness of which You approve.',
      reference: 'Quran 27:19',
    ),

    // ────────────────────────────── Healing ─────────────────────────────────
    Dua(
      id: 'healing_1',
      categoryId: 'healing',
      title: 'For Cure',
      arabic: 'اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَأْسَ، اشْفِ أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا',
      transliteration: 'Allahumma Rabban-nas, adhhibil-ba\'s, ishfi antash-Shafi, la shifa\'a illa shifa\'uka, shifa\'an la yughadiru saqama',
      translation: 'O Allah, Lord of mankind, remove the affliction. Heal — You are the Healer. There is no cure but Yours, a cure that leaves no illness behind.',
      reference: 'Sahih al-Bukhari 5675',
    ),
    Dua(
      id: 'healing_2',
      categoryId: 'healing',
      title: 'Refuge from Disease',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْبَرَصِ، وَالْجُنُونِ، وَالْجُذَامِ، وَمِنْ سَيِّئِ الْأَسْقَامِ',
      transliteration: 'Allahumma inni a\'udhu bika minal-barasi, wal-junooni, wal-judhami, wa min sayyi\'il-asqam',
      translation: 'O Allah, I seek refuge in You from leprosy, madness, all disfiguring illness, and every evil disease.',
      reference: 'Abu Dawud 1554',
    ),
    Dua(
      id: 'healing_3',
      categoryId: 'healing',
      title: 'Self-Healing',
      arabic: 'بِسْمِ اللَّهِ، أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ',
      transliteration: 'Bismillah, a\'udhu billahi wa qudratihi min sharri ma ajidu wa uhadhir',
      translation: 'In the name of Allah. I seek refuge in Allah and His power from the evil of what I find and what I fear.',
      reference: 'Sahih Muslim 2202',
    ),
    Dua(
      id: 'healing_4',
      categoryId: 'healing',
      title: 'Health & Well-being',
      arabic: 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي',
      transliteration: 'Allahumma \'afini fi badani, Allahumma \'afini fi sam\'i, Allahumma \'afini fi basari',
      translation: 'O Allah, give me well-being in my body, O Allah, give me well-being in my hearing, O Allah, give me well-being in my sight.',
      reference: 'Abu Dawud 5090',
    ),

    // ───────────────────────────── Knowledge ────────────────────────────────
    Dua(
      id: 'knowledge_1',
      categoryId: 'knowledge',
      title: 'Increase Me',
      arabic: 'رَّبِّ زِدْنِي عِلْمًا',
      transliteration: 'Rabbi zidni \'ilma',
      translation: 'My Lord, increase me in knowledge.',
      reference: 'Quran 20:114',
    ),
    Dua(
      id: 'knowledge_2',
      categoryId: 'knowledge',
      title: 'Beneficial Knowledge',
      arabic: 'اللَّهُمَّ انْفَعْنِي بِمَا عَلَّمْتَنِي، وَعَلِّمْنِي مَا يَنْفَعُنِي، وَزِدْنِي عِلْمًا',
      transliteration: 'Allahumma anfa\'ni bima \'allamtani, wa \'allimni ma yanfa\'uni, wa zidni \'ilma',
      translation: 'O Allah, benefit me by what You have taught me, teach me what will benefit me, and increase me in knowledge.',
      reference: 'Ibn Majah 251',
    ),
    Dua(
      id: 'knowledge_3',
      categoryId: 'knowledge',
      title: 'Refuge from Useless Knowledge',
      arabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ عِلْمٍ لَا يَنْفَعُ، وَمِنْ قَلْبٍ لَا يَخْشَعُ',
      transliteration: 'Allahumma inni a\'udhu bika min \'ilmin la yanfa\', wa min qalbin la yakhsha\'',
      translation: 'O Allah, I seek refuge in You from knowledge that does not benefit, and from a heart that is not humble.',
      reference: 'Sahih Muslim 2722',
    ),
    Dua(
      id: 'knowledge_4',
      categoryId: 'knowledge',
      title: 'Wisdom & Understanding',
      arabic: 'اللَّهُمَّ فَقِّهْنِي فِي الدِّينِ',
      transliteration: 'Allahumma faqqihni fid-deen',
      translation: 'O Allah, grant me deep understanding of the religion.',
      reference: 'Sahih al-Bukhari 143',
    ),

    // ────────────────────────────── Travel ──────────────────────────────────
    Dua(
      id: 'travel_1',
      categoryId: 'travel',
      title: 'Travel Dua',
      arabic: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ ۞ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ',
      transliteration: 'Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila Rabbina lamunqalibun',
      translation: 'Glory be to Him who has subjected this to us, and we were not capable of it. And surely to our Lord we shall return.',
      reference: 'Sahih Muslim 1342',
    ),
    Dua(
      id: 'travel_2',
      categoryId: 'travel',
      title: 'Setting Out',
      arabic: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَٰذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا، وَاطْوِ عَنَّا بُعْدَهُ',
      transliteration: 'Allahumma inna nas\'aluka fi safarina hadhal-birra wat-taqwa, wa minal-\'amali ma tarda, Allahumma hawwin \'alayna safarana hadha, watwi \'anna bu\'dah',
      translation: 'O Allah, we ask You for righteousness and piety in this journey of ours, and for deeds that please You. O Allah, ease this journey for us and shorten its distance.',
      reference: 'Sahih Muslim 1342',
    ),
    Dua(
      id: 'travel_3',
      categoryId: 'travel',
      title: 'Returning Home',
      arabic: 'آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ',
      transliteration: 'Ayibuna ta\'ibuna \'abiduna li Rabbina hamidun',
      translation: 'We return, repenting, worshipping, and praising our Lord.',
      reference: 'Sahih Muslim 1345',
    ),
    Dua(
      id: 'travel_4',
      categoryId: 'travel',
      title: 'Stopping at a Place',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati min sharri ma khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      reference: 'Sahih Muslim 2708',
    ),

    // ────────────────────────────── Family ──────────────────────────────────
    Dua(
      id: 'family_1',
      categoryId: 'family',
      title: 'Coolness of the Eyes',
      arabic: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      transliteration: 'Rabbana hab lana min azwajina wa dhurriyyatina qurrata a\'yunin waj\'alna lil-muttaqeena imama',
      translation: 'Our Lord, grant us from among our spouses and offspring the comfort of our eyes, and make us a leader for the righteous.',
      reference: 'Quran 25:74',
    ),
    Dua(
      id: 'family_2',
      categoryId: 'family',
      title: 'For Parents',
      arabic: 'رَبِّ ارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
      transliteration: 'Rabbir-hamhuma kama rabbayani sagheera',
      translation: 'My Lord, have mercy on them (my parents) as they raised me when I was small.',
      reference: 'Quran 17:24',
    ),
    Dua(
      id: 'family_3',
      categoryId: 'family',
      title: 'Righteous Offspring',
      arabic: 'رَبِّ هَبْ لِي مِن لَّدُنكَ ذُرِّيَّةً طَيِّبَةً ۖ إِنَّكَ سَمِيعُ الدُّعَاءِ',
      transliteration: 'Rabbi hab li min ladunka dhurriyyatan tayyibah, innaka samee\'ud-du\'a',
      translation: 'My Lord, grant me from Yourself a good offspring. Indeed, You are the Hearer of supplication.',
      reference: 'Quran 3:38',
    ),
    Dua(
      id: 'family_4',
      categoryId: 'family',
      title: 'Bismillah Together',
      arabic: 'بِسْمِ اللَّهِ، اللَّهُمَّ جَنِّبْنَا الشَّيْطَانَ، وَجَنِّبِ الشَّيْطَانَ مَا رَزَقْتَنَا',
      transliteration: 'Bismillah, Allahumma jannibnash-shaytan, wa jannibish-shaytana ma razaqtana',
      translation: 'In the name of Allah. O Allah, keep Satan away from us and keep him away from what You have provided us.',
      reference: 'Sahih al-Bukhari 141',
    ),

    // ───────────────────────────── Friday ──────────────────────────────────
    Dua(
      id: 'jumua_1',
      categoryId: 'jumua',
      title: 'Salawat on the Prophet',
      arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ',
      transliteration: 'Allahumma salli \'ala Muhammad, wa \'ala ali Muhammad, kama sallayta \'ala Ibrahim, wa \'ala ali Ibrahim, innaka Hameedun Majeed',
      translation: 'O Allah, send blessings upon Muhammad and the family of Muhammad, as You sent blessings upon Ibrahim and the family of Ibrahim. Indeed, You are Praiseworthy and Glorious.',
      reference: 'Sahih al-Bukhari 3370',
    ),
    Dua(
      id: 'jumua_2',
      categoryId: 'jumua',
      title: 'The Hour of Acceptance',
      arabic: 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',
      transliteration: 'Allahumma a\'inni \'ala dhikrika wa shukrika wa husni \'ibadatika',
      translation: 'O Allah, help me to remember You, to thank You, and to worship You well.',
      reference: 'Abu Dawud 1522 — recommended in the last hour of Friday',
    ),
    Dua(
      id: 'jumua_3',
      categoryId: 'jumua',
      title: 'After Surat al-Kahf',
      arabic: 'الْحَمْدُ لِلَّهِ الَّذِي أَنزَلَ عَلَىٰ عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَل لَّهُ عِوَجًا',
      transliteration: 'Alhamdu lillahil-ladhi anzala \'ala \'abdihil-kitaba wa lam yaj\'al lahu \'iwaja',
      translation: 'Praise is to Allah who has sent down upon His servant the Book and has not made therein any deviance.',
      reference: 'Quran 18:1',
    ),

    // ─────────────────────────── Morning Adhkar ────────────────────────────
    Dua(
      id: 'morning_1',
      categoryId: 'morning',
      title: 'Morning Remembrance',
      arabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration: 'Asbahna wa asbahal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah',
      translation: 'We have entered the morning and at this very time all sovereignty belongs to Allah. Praise is to Allah. None has the right to be worshipped but Allah alone, who has no partner.',
      reference: 'Sahih Muslim 2723',
    ),
    Dua(
      id: 'morning_2',
      categoryId: 'morning',
      title: 'Light Upon Light',
      arabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
      transliteration: 'Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur',
      translation: 'O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the resurrection.',
      reference: 'Jami\' at-Tirmidhi 3391',
    ),
    Dua(
      id: 'morning_3',
      categoryId: 'morning',
      title: 'Master of Forgiveness',
      arabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ',
      transliteration: 'Allahumma anta Rabbi la ilaha illa anta, khalaqtani wa ana \'abduka',
      translation: 'O Allah, You are my Lord, none has the right to be worshipped but You. You created me and I am Your servant.',
      reference: 'Sahih al-Bukhari 6306 — Sayyidul Istighfar',
    ),
    Dua(
      id: 'morning_4',
      categoryId: 'morning',
      title: 'I am Pleased',
      arabic: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',
      transliteration: 'Raditu billahi Rabban, wa bil-Islami deenan, wa bi Muhammadin (saw) nabiyya',
      translation: 'I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet.',
      reference: 'Abu Dawud 5072',
    ),
    Dua(
      id: 'morning_5',
      categoryId: 'morning',
      title: 'Sufficient is Allah',
      arabic: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ ۖ عَلَيْهِ تَوَكَّلْتُ ۖ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
      transliteration: 'Hasbiyallahu la ilaha illa hu, \'alayhi tawakkaltu wa huwa Rabbul-\'arshil-\'adheem',
      translation: 'Allah is sufficient for me. There is no deity except Him. On Him I have relied, and He is the Lord of the Mighty Throne. (×7)',
      reference: 'Abu Dawud 5081',
    ),

    // ─────────────────────────── Evening Adhkar ────────────────────────────
    Dua(
      id: 'evening_1',
      categoryId: 'evening',
      title: 'Evening Remembrance',
      arabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      transliteration: 'Amsayna wa amsal-mulku lillah, wal-hamdu lillah, la ilaha illallahu wahdahu la sharika lah',
      translation: 'We have entered the evening and at this very time all sovereignty belongs to Allah. Praise is to Allah. None has the right to be worshipped but Allah alone, who has no partner.',
      reference: 'Sahih Muslim 2723',
    ),
    Dua(
      id: 'evening_2',
      categoryId: 'evening',
      title: 'Trust Before Sleep',
      arabic: 'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ',
      transliteration: 'Allahumma \'alimal-ghaybi wash-shahadah, fatiras-samawati wal-ard',
      translation: 'O Allah, Knower of the unseen and the seen, Originator of the heavens and the earth.',
      reference: 'Jami\' at-Tirmidhi 3392',
    ),
    Dua(
      id: 'evening_3',
      categoryId: 'evening',
      title: 'Refuge from the Night',
      arabic: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'udhu bi kalimatillahit-tammati min sharri ma khalaq',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created. (×3 in the evening)',
      reference: 'Sahih Muslim 2708',
    ),
    Dua(
      id: 'evening_4',
      categoryId: 'evening',
      title: 'Three Refuges Surahs',
      arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۞ قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۞ قُلْ أَعُوذُ بِرَبِّ النَّاسِ',
      transliteration: 'Qul Huwallahu ahad / Qul a\'udhu bi Rabbil-falaq / Qul a\'udhu bi Rabbin-nas',
      translation: 'Recite Surahs Al-Ikhlas, Al-Falaq, and An-Nas — three times each, morning and evening.',
      reference: 'Abu Dawud 5082',
    ),
  ];

  static List<Dua> byCategory(String categoryId) =>
      all.where((Dua d) => d.categoryId == categoryId).toList();

  static Dua? byId(String id) {
    try {
      return all.firstWhere((Dua d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Notification copy that rotates with each scheduled dua reminder.
  static const List<String> notificationTitles = <String>[
    'Take a moment to remember Allah 🤍',
    'Recite this dua for peace',
    'A small dua can brighten your day',
    'Pause. Breathe. Remember Him.',
    'Light from your Lord ✨',
    'A whisper to the Most Merciful',
    'Your heart is calling',
    'A gentle reminder for the soul',
    'One dua, one breath, one moment',
    'Return to Him, even briefly',
  ];
}
