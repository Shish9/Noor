import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../state/settings_state.dart';
import 'app_language.dart';

/// Translation tables for every UI string surfaced by the app chrome.
///
/// Strings inside the actual Quran/Dua/Adhkar text remain in their natural
/// languages (Arabic, English translation), since those are religious source
/// texts. Only the surrounding interface chrome is translated here.
class Translations {
  Translations._();

  /// Lookup map: key → translations per language.
  static const Map<String, Map<AppLanguage, String>> _data =
      <String, Map<AppLanguage, String>>{
    // ─────────────── Greetings ───────────────
    'greeting.morning': <AppLanguage, String>{
      AppLanguage.english: 'Good morning',
      AppLanguage.arabic: 'صباح الخير',
      AppLanguage.sorani: 'بەیانی باش',
      AppLanguage.badini: 'Sibe baş',
    },
    'greeting.afternoon': <AppLanguage, String>{
      AppLanguage.english: 'Good afternoon',
      AppLanguage.arabic: 'مساء الخير',
      AppLanguage.sorani: 'دواینیوەڕۆت باش',
      AppLanguage.badini: 'Êvarbaş',
    },
    'greeting.evening': <AppLanguage, String>{
      AppLanguage.english: 'Good evening',
      AppLanguage.arabic: 'مساء الخير',
      AppLanguage.sorani: 'ئێوارەت باش',
      AppLanguage.badini: 'Êvar baş',
    },
    'greeting.night': <AppLanguage, String>{
      AppLanguage.english: 'Peaceful night',
      AppLanguage.arabic: 'ليلة هادئة',
      AppLanguage.sorani: 'شەوێکی ئاسوودە',
      AppLanguage.badini: 'Şeveke aram',
    },
    'greeting.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'May your day be filled with light',
      AppLanguage.arabic: 'أسأل الله أن يملأ يومك بالنور',
      AppLanguage.sorani: 'با ڕۆژەکەت پڕ بێت لە ڕووناکی',
      AppLanguage.badini: 'Bila roja te tijî ronahî be',
    },

    // ─────────────── Tabs ───────────────
    'tab.home': <AppLanguage, String>{
      AppLanguage.english: 'Home',
      AppLanguage.arabic: 'الرئيسية',
      AppLanguage.sorani: 'سەرەکی',
      AppLanguage.badini: 'Mal',
    },
    'tab.quran': <AppLanguage, String>{
      AppLanguage.english: 'Quran',
      AppLanguage.arabic: 'القرآن',
      AppLanguage.sorani: 'قورئان',
      AppLanguage.badini: 'Qur\'an',
    },
    'tab.duas': <AppLanguage, String>{
      AppLanguage.english: 'Duas',
      AppLanguage.arabic: 'الأدعية',
      AppLanguage.sorani: 'دوعا',
      AppLanguage.badini: 'Dua',
    },
    'tab.audio': <AppLanguage, String>{
      AppLanguage.english: 'Audio',
      AppLanguage.arabic: 'الصوت',
      AppLanguage.sorani: 'دەنگ',
      AppLanguage.badini: 'Deng',
    },
    'tab.profile': <AppLanguage, String>{
      AppLanguage.english: 'Profile',
      AppLanguage.arabic: 'الملف الشخصي',
      AppLanguage.sorani: 'پرۆفایل',
      AppLanguage.badini: 'Profîl',
    },

    // ─────────────── Section headers ───────────────
    'section.continueReading': <AppLanguage, String>{
      AppLanguage.english: 'CONTINUE READING',
      AppLanguage.arabic: 'متابعة القراءة',
      AppLanguage.sorani: 'بەردەوام بە لە خوێندنەوە',
      AppLanguage.badini: 'Berdewamiya xwendinê',
    },
    'section.dailyAyah': <AppLanguage, String>{
      AppLanguage.english: 'AYAH OF THE DAY',
      AppLanguage.arabic: 'آية اليوم',
      AppLanguage.sorani: 'ئایەتی ڕۆژ',
      AppLanguage.badini: 'Ayeta rojê',
    },
    'section.dailyDua': <AppLanguage, String>{
      AppLanguage.english: 'DUA OF THE DAY',
      AppLanguage.arabic: 'دعاء اليوم',
      AppLanguage.sorani: 'دوعای ڕۆژ',
      AppLanguage.badini: 'Duaya rojê',
    },
    'section.recentlyPlayed': <AppLanguage, String>{
      AppLanguage.english: 'Recently Played',
      AppLanguage.arabic: 'تم تشغيله مؤخرًا',
      AppLanguage.sorani: 'دواین گوێگرتنەکان',
      AppLanguage.badini: 'Dawiya guhdarîkirinan',
    },
    'section.reflection': <AppLanguage, String>{
      AppLanguage.english: 'Reflection',
      AppLanguage.arabic: 'تأمل',
      AppLanguage.sorani: 'بیرکردنەوە',
      AppLanguage.badini: 'Hizirkirin',
    },
    'section.prayerTimes': <AppLanguage, String>{
      AppLanguage.english: 'PRAYER TIMES',
      AppLanguage.arabic: 'مواقيت الصلاة',
      AppLanguage.sorani: 'کاتەکانی نوێژ',
      AppLanguage.badini: 'Demên nimêjê',
    },

    // ─────────────── Common actions ───────────────
    'action.save': <AppLanguage, String>{
      AppLanguage.english: 'Save',
      AppLanguage.arabic: 'حفظ',
      AppLanguage.sorani: 'پاشەکەوتکردن',
      AppLanguage.badini: 'Tomarkirin',
    },
    'action.share': <AppLanguage, String>{
      AppLanguage.english: 'Share',
      AppLanguage.arabic: 'مشاركة',
      AppLanguage.sorani: 'هاوبەشی',
      AppLanguage.badini: 'Parvekirin',
    },
    'action.listen': <AppLanguage, String>{
      AppLanguage.english: 'Listen',
      AppLanguage.arabic: 'استمع',
      AppLanguage.sorani: 'گوێ بگرە',
      AppLanguage.badini: 'Guh bide',
    },
    'action.continue': <AppLanguage, String>{
      AppLanguage.english: 'Continue',
      AppLanguage.arabic: 'متابعة',
      AppLanguage.sorani: 'بەردەوام بە',
      AppLanguage.badini: 'Berdewam be',
    },
    'action.cancel': <AppLanguage, String>{
      AppLanguage.english: 'Cancel',
      AppLanguage.arabic: 'إلغاء',
      AppLanguage.sorani: 'پاشگەزبوونەوە',
      AppLanguage.badini: 'Betalkirin',
    },
    'action.resetAll': <AppLanguage, String>{
      AppLanguage.english: 'Reset all',
      AppLanguage.arabic: 'إعادة تعيين الكل',
      AppLanguage.sorani: 'هەمووی بکەرەوە',
      AppLanguage.badini: 'Hemûyî vegerîne',
    },
    'action.backToReading': <AppLanguage, String>{
      AppLanguage.english: 'Back to Reading',
      AppLanguage.arabic: 'العودة إلى القراءة',
      AppLanguage.sorani: 'گەڕانەوە بۆ خوێندنەوە',
      AppLanguage.badini: 'Vegera xwendinê',
    },

    // ─────────────── Dhikr ───────────────
    'dhikr.title': <AppLanguage, String>{
      AppLanguage.english: 'Dhikr',
      AppLanguage.arabic: 'الذكر',
      AppLanguage.sorani: 'زیکر',
      AppLanguage.badini: 'Zikir',
    },
    'dhikr.todayCount': <AppLanguage, String>{
      AppLanguage.english: 'dhikr today',
      AppLanguage.arabic: 'ذكر اليوم',
      AppLanguage.sorani: 'زیکر ئەمڕۆ',
      AppLanguage.badini: 'zikir îro',
    },
    'dhikr.startHint': <AppLanguage, String>{
      AppLanguage.english: 'Tap any phrase below to start counting',
      AppLanguage.arabic: 'اضغط على أي ذكر بالأسفل لبدء العد',
      AppLanguage.sorani: 'کلیک بکە لەسەر هەر ڕستەیەک بۆ دەستپێکردنی ژمارە',
      AppLanguage.badini: 'Li ser her vegotinekê bitikîne',
    },
    'dhikr.tapHint': <AppLanguage, String>{
      AppLanguage.english: 'Tap to count · Long-press to reset',
      AppLanguage.arabic: 'اضغط للعد · اضغط مطولاً لإعادة التعيين',
      AppLanguage.sorani: 'بۆ ژماردن کلیک بکە · بۆ سفرکردن درێژ بکە',
      AppLanguage.badini: 'Bitikîne ji bo hejmartinê · Dirêj bitikîne ji bo sifirkirin',
    },

    // ─────────────── Settings ───────────────
    'settings.title': <AppLanguage, String>{
      AppLanguage.english: 'Settings',
      AppLanguage.arabic: 'الإعدادات',
      AppLanguage.sorani: 'ڕێکخستنەکان',
      AppLanguage.badini: 'Mîheng',
    },
    'settings.language': <AppLanguage, String>{
      AppLanguage.english: 'Language',
      AppLanguage.arabic: 'اللغة',
      AppLanguage.sorani: 'زمان',
      AppLanguage.badini: 'Ziman',
    },
    'settings.notifications': <AppLanguage, String>{
      AppLanguage.english: 'Notifications',
      AppLanguage.arabic: 'الإشعارات',
      AppLanguage.sorani: 'ئاگاداریەکان',
      AppLanguage.badini: 'Agahdarî',
    },
    'settings.reading': <AppLanguage, String>{
      AppLanguage.english: 'Reading',
      AppLanguage.arabic: 'القراءة',
      AppLanguage.sorani: 'خوێندنەوە',
      AppLanguage.badini: 'Xwendin',
    },
    'settings.audio': <AppLanguage, String>{
      AppLanguage.english: 'Audio',
      AppLanguage.arabic: 'الصوت',
      AppLanguage.sorani: 'دەنگ',
      AppLanguage.badini: 'Deng',
    },
    'settings.languageChanged': <AppLanguage, String>{
      AppLanguage.english: 'Language changed to English',
      AppLanguage.arabic: 'تم تغيير اللغة إلى العربية',
      AppLanguage.sorani: 'زمان گۆڕدرا بۆ سۆرانی',
      AppLanguage.badini: 'Ziman hat guhertin bo Badînî',
    },

    // ─────────────── Profile ───────────────
    'profile.preferences': <AppLanguage, String>{
      AppLanguage.english: 'Preferences',
      AppLanguage.arabic: 'التفضيلات',
      AppLanguage.sorani: 'هەڵبژاردەکان',
      AppLanguage.badini: 'Hilbijartinên',
    },
    'profile.spiritual': <AppLanguage, String>{
      AppLanguage.english: 'Spiritual',
      AppLanguage.arabic: 'روحاني',
      AppLanguage.sorani: 'ڕۆحی',
      AppLanguage.badini: 'Ruhî',
    },
    'profile.about': <AppLanguage, String>{
      AppLanguage.english: 'About',
      AppLanguage.arabic: 'حول',
      AppLanguage.sorani: 'دەربارە',
      AppLanguage.badini: 'Derbarê',
    },
    'profile.bookmarks': <AppLanguage, String>{
      AppLanguage.english: 'My Bookmarks',
      AppLanguage.arabic: 'إشاراتي',
      AppLanguage.sorani: 'نیشاندانەکانم',
      AppLanguage.badini: 'Nîşandayînên min',
    },
    'profile.favoriteDuas': <AppLanguage, String>{
      AppLanguage.english: 'Favorite Duas',
      AppLanguage.arabic: 'الأدعية المفضلة',
      AppLanguage.sorani: 'دوعا دڵخوازەکان',
      AppLanguage.badini: 'Duayên jîr',
    },
    'profile.history': <AppLanguage, String>{
      AppLanguage.english: 'Reading History',
      AppLanguage.arabic: 'سجل القراءة',
      AppLanguage.sorani: 'مێژووی خوێندنەوە',
      AppLanguage.badini: 'Dîroka xwendinê',
    },
    'profile.dhikrCounter': <AppLanguage, String>{
      AppLanguage.english: 'Dhikr Counter',
      AppLanguage.arabic: 'عداد الذكر',
      AppLanguage.sorani: 'ژمێرەری زیکر',
      AppLanguage.badini: 'Hejmara zikrê',
    },
    'profile.tafsirSoon': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir (Coming Soon)',
      AppLanguage.arabic: 'التفسير (قريبًا)',
      AppLanguage.sorani: 'تەفسیر (بە زووی)',
      AppLanguage.badini: 'Tefsîr (Zû tê)',
    },
    'profile.aboutApp': <AppLanguage, String>{
      AppLanguage.english: 'About Noor',
      AppLanguage.arabic: 'حول نور',
      AppLanguage.sorani: 'دەربارەی نوور',
      AppLanguage.badini: 'Derbarê Noor',
    },
    'profile.shareApp': <AppLanguage, String>{
      AppLanguage.english: 'Share Noor with friends',
      AppLanguage.arabic: 'شارك نور مع الأصدقاء',
      AppLanguage.sorani: 'نوور لەگەڵ هاوڕێکانت هاوبەش بکە',
      AppLanguage.badini: 'Noor ji hevalan re bişîne',
    },
    'profile.rateApp': <AppLanguage, String>{
      AppLanguage.english: 'Rate the app',
      AppLanguage.arabic: 'قيّم التطبيق',
      AppLanguage.sorani: 'بەرنامە هەڵسەنگێنە',
      AppLanguage.badini: 'Bernameyê binirxîne',
    },
    'profile.streak': <AppLanguage, String>{
      AppLanguage.english: 'Day Streak',
      AppLanguage.arabic: 'سلسلة الأيام',
      AppLanguage.sorani: 'زنجیرەی ڕۆژەکان',
      AppLanguage.badini: 'Zincîra rojan',
    },
    'profile.assalam': <AppLanguage, String>{
      AppLanguage.english: 'Assalamu Alaikum',
      AppLanguage.arabic: 'السلام عليكم',
      AppLanguage.sorani: 'سڵاو لێت بێت',
      AppLanguage.badini: 'Selamûn aleykum',
    },
    'profile.journey': <AppLanguage, String>{
      AppLanguage.english: 'Your spiritual journey continues 🤍',
      AppLanguage.arabic: 'رحلتك الروحانية مستمرة 🤍',
      AppLanguage.sorani: 'گەشتی ڕۆحیت بەردەوامە 🤍',
      AppLanguage.badini: 'Rêwîtiya te ya ruhî berdewam e 🤍',
    },

    // ─────────────── Quick Actions ───────────────
    'quick.dhikr': <AppLanguage, String>{
      AppLanguage.english: 'Dhikr',
      AppLanguage.arabic: 'الذكر',
      AppLanguage.sorani: 'زیکر',
      AppLanguage.badini: 'Zikir',
    },
    'quick.tafsir': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir',
      AppLanguage.arabic: 'التفسير',
      AppLanguage.sorani: 'تەفسیر',
      AppLanguage.badini: 'Tefsîr',
    },

    // ─────────────── Tafsir Coming Soon ───────────────
    'tafsir.title': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir',
      AppLanguage.arabic: 'التفسير',
      AppLanguage.sorani: 'تەفسیر',
      AppLanguage.badini: 'Tefsîr',
    },
    'tafsir.comingSoon': <AppLanguage, String>{
      AppLanguage.english: 'COMING SOON',
      AppLanguage.arabic: 'قريبًا',
      AppLanguage.sorani: 'بە زووی',
      AppLanguage.badini: 'ZÛ TÊ',
    },
    'tafsir.preparing': <AppLanguage, String>{
      AppLanguage.english:
          'Verse-by-verse tafsir is being prepared with care 🤍',
      AppLanguage.arabic: 'التفسير آية بآية يُعدّ بعناية 🤍',
      AppLanguage.sorani:
          'تەفسیری ئایەت بە ئایەت بە وردی دەبینرێت 🤍',
      AppLanguage.badini:
          'Tefsîr ayet bi ayet bi baldarî tê amade kirin 🤍',
    },
    'tafsir.plannedLanguages': <AppLanguage, String>{
      AppLanguage.english: 'PLANNED LANGUAGES',
      AppLanguage.arabic: 'اللغات المخطط لها',
      AppLanguage.sorani: 'زمانە پلاندراوەکان',
      AppLanguage.badini: 'Zimanên plansazkirî',
    },

    // ─────────────── Settings body ───────────────
    'settings.hourlyReminders': <AppLanguage, String>{
      AppLanguage.english: 'Hourly dua reminders',
      AppLanguage.arabic: 'تذكيرات الأدعية كل ساعة',
      AppLanguage.sorani: 'بیرخستنەوەی دوعای کاتژمێرانە',
      AppLanguage.badini: 'Bîrxistinên dua yên seetane',
    },
    'settings.hourlyRemindersHint': <AppLanguage, String>{
      AppLanguage.english: 'Soft, calming notifications throughout the day',
      AppLanguage.arabic: 'إشعارات هادئة ولطيفة طوال اليوم',
      AppLanguage.sorani: 'ئاگاداری نەرم و ئارام بە درێژایی ڕۆژ',
      AppLanguage.badini: 'Agahdariyên nerm û aram di tev rojê de',
    },
    'settings.reminderInterval': <AppLanguage, String>{
      AppLanguage.english: 'Reminder interval',
      AppLanguage.arabic: 'فاصل التذكير',
      AppLanguage.sorani: 'ماوەی بیرخستنەوە',
      AppLanguage.badini: 'Navbera bîrxistinê',
    },
    'settings.everyXh': <AppLanguage, String>{
      AppLanguage.english: 'Every',
      AppLanguage.arabic: 'كل',
      AppLanguage.sorani: 'هەموو',
      AppLanguage.badini: 'Her',
    },
    'settings.silentMode': <AppLanguage, String>{
      AppLanguage.english: 'Silent mode',
      AppLanguage.arabic: 'الوضع الصامت',
      AppLanguage.sorani: 'دۆخی بێ دەنگ',
      AppLanguage.badini: 'Moda bê deng',
    },
    'settings.silentHint': <AppLanguage, String>{
      AppLanguage.english: 'Notifications without sound or vibration',
      AppLanguage.arabic: 'إشعارات بدون صوت أو اهتزاز',
      AppLanguage.sorani: 'ئاگادارییەکان بێ دەنگ یان لەرینەوە',
      AppLanguage.badini: 'Agahdariyên bê deng û lerizandin',
    },
    'settings.fontSize': <AppLanguage, String>{
      AppLanguage.english: 'Arabic font size',
      AppLanguage.arabic: 'حجم الخط العربي',
      AppLanguage.sorani: 'قەبارەی فۆنتی عەرەبی',
      AppLanguage.badini: 'Mezinahiya tîpa erebî',
    },
    'settings.showTransliteration': <AppLanguage, String>{
      AppLanguage.english: 'Show transliteration',
      AppLanguage.arabic: 'عرض النقحرة',
      AppLanguage.sorani: 'نیشاندانی دەنگنووسین',
      AppLanguage.badini: 'Nîşandana dengnivîsê',
    },
    'settings.transliterationHint': <AppLanguage, String>{
      AppLanguage.english: 'Latin pronunciation for Arabic verses',
      AppLanguage.arabic: 'النطق اللاتيني للآيات العربية',
      AppLanguage.sorani: 'دەربڕینی لاتینی بۆ ئایەتی عەرەبی',
      AppLanguage.badini: 'Bilêvkirina latînî ji bo ayetên erebî',
    },
    'settings.dailyGoal': <AppLanguage, String>{
      AppLanguage.english: 'Daily reading goal',
      AppLanguage.arabic: 'هدف القراءة اليومي',
      AppLanguage.sorani: 'ئامانجی خوێندنەوەی ڕۆژانە',
      AppLanguage.badini: 'Armanca xwendina rojane',
    },
    'settings.ayahs': <AppLanguage, String>{
      AppLanguage.english: 'ayahs',
      AppLanguage.arabic: 'آيات',
      AppLanguage.sorani: 'ئایەت',
      AppLanguage.badini: 'ayet',
    },
    'settings.defaultReciter': <AppLanguage, String>{
      AppLanguage.english: 'Default reciter',
      AppLanguage.arabic: 'القارئ الافتراضي',
      AppLanguage.sorani: 'قاریی بنەڕەتی',
      AppLanguage.badini: 'Qariyê bingehîn',
    },

    // ─────────────── Quran screen ───────────────
    'quran.title': <AppLanguage, String>{
      AppLanguage.english: 'The Holy Quran',
      AppLanguage.arabic: 'القرآن الكريم',
      AppLanguage.sorani: 'قورئانی پیرۆز',
      AppLanguage.badini: 'Qur\'ana Pîroz',
    },
    'quran.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'القرآن الكريم · 114 surahs · 6,236 ayahs',
      AppLanguage.arabic: 'القرآن الكريم · 114 سورة · 6,236 آية',
      AppLanguage.sorani: 'قورئانی پیرۆز · ١١٤ سورەت · ٦٬٢٣٦ ئایەت',
      AppLanguage.badini: 'Qur\'an · 114 sûre · 6,236 ayet',
    },
    'quran.searchHint': <AppLanguage, String>{
      AppLanguage.english: 'Search surah by name or number',
      AppLanguage.arabic: 'ابحث عن سورة بالاسم أو الرقم',
      AppLanguage.sorani: 'بە ناو یان ژمارە بگەڕێ بۆ سورەت',
      AppLanguage.badini: 'Bi nav an hejmar li sûreyê bigere',
    },
    'quran.filter.all': <AppLanguage, String>{
      AppLanguage.english: 'All',
      AppLanguage.arabic: 'الكل',
      AppLanguage.sorani: 'هەموو',
      AppLanguage.badini: 'Hemû',
    },
    'quran.filter.meccan': <AppLanguage, String>{
      AppLanguage.english: 'Meccan',
      AppLanguage.arabic: 'مكية',
      AppLanguage.sorani: 'مەککی',
      AppLanguage.badini: 'Mekkî',
    },
    'quran.filter.medinan': <AppLanguage, String>{
      AppLanguage.english: 'Medinan',
      AppLanguage.arabic: 'مدنية',
      AppLanguage.sorani: 'مەدەنی',
      AppLanguage.badini: 'Medenî',
    },
    'quran.surah': <AppLanguage, String>{
      AppLanguage.english: 'Surah',
      AppLanguage.arabic: 'سورة',
      AppLanguage.sorani: 'سورەت',
      AppLanguage.badini: 'Sûre',
    },
    'quran.previous': <AppLanguage, String>{
      AppLanguage.english: 'Previous',
      AppLanguage.arabic: 'السابق',
      AppLanguage.sorani: 'پێشوو',
      AppLanguage.badini: 'Berê',
    },
    'quran.next': <AppLanguage, String>{
      AppLanguage.english: 'Next',
      AppLanguage.arabic: 'التالي',
      AppLanguage.sorani: 'دواتر',
      AppLanguage.badini: 'Pişt',
    },
    'quran.readTafsir': <AppLanguage, String>{
      AppLanguage.english: 'Read Tafsir',
      AppLanguage.arabic: 'قراءة التفسير',
      AppLanguage.sorani: 'تەفسیر بخوێنە',
      AppLanguage.badini: 'Tefsîrê bixwîne',
    },
    'quran.distractionFree': <AppLanguage, String>{
      AppLanguage.english: 'Distraction-free',
      AppLanguage.arabic: 'وضع التركيز',
      AppLanguage.sorani: 'دۆخی بێ سەرلێشێواوی',
      AppLanguage.badini: 'Moda bê tevlihevî',
    },
    'quran.showUI': <AppLanguage, String>{
      AppLanguage.english: 'Show UI',
      AppLanguage.arabic: 'إظهار الواجهة',
      AppLanguage.sorani: 'پیشاندانی ڕووکار',
      AppLanguage.badini: 'Nîşandana navberê',
    },

    // ─────────────── Audio screen ───────────────
    'audio.title': <AppLanguage, String>{
      AppLanguage.english: 'Recitations',
      AppLanguage.arabic: 'التلاوات',
      AppLanguage.sorani: 'تیلاوەتەکان',
      AppLanguage.badini: 'Tîlawet',
    },
    'audio.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'Beautiful Quran recitations from world-renowned reciters',
      AppLanguage.arabic: 'تلاوات قرآنية بصوت أشهر القراء',
      AppLanguage.sorani: 'تیلاوەتی جوانی قورئان لە قاریە بەناوبانگەکانەوە',
      AppLanguage.badini: 'Tîlawetên xweş ên Qur\'anê ji qarîyên navdar',
    },
    'audio.reciters': <AppLanguage, String>{
      AppLanguage.english: 'Reciters',
      AppLanguage.arabic: 'القراء',
      AppLanguage.sorani: 'قاریەکان',
      AppLanguage.badini: 'Qarî',
    },
    'audio.allSurahs': <AppLanguage, String>{
      AppLanguage.english: 'All Surahs',
      AppLanguage.arabic: 'جميع السور',
      AppLanguage.sorani: 'هەموو سورەتەکان',
      AppLanguage.badini: 'Hemû sûre',
    },
    'audio.nowPlaying': <AppLanguage, String>{
      AppLanguage.english: 'NOW PLAYING',
      AppLanguage.arabic: 'يُشغّل الآن',
      AppLanguage.sorani: 'ئێستا دەنواندرێت',
      AppLanguage.badini: 'Niha tê lêdan',
    },
    'audio.playbackSpeed': <AppLanguage, String>{
      AppLanguage.english: 'Playback Speed',
      AppLanguage.arabic: 'سرعة التشغيل',
      AppLanguage.sorani: 'خێرایی نواندن',
      AppLanguage.badini: 'Lezê lêdanê',
    },
    'audio.sleepTimer': <AppLanguage, String>{
      AppLanguage.english: 'Sleep Timer',
      AppLanguage.arabic: 'مؤقت النوم',
      AppLanguage.sorani: 'کاتژمێری خەو',
      AppLanguage.badini: 'Demjimêra xewê',
    },
    'audio.minutes': <AppLanguage, String>{
      AppLanguage.english: 'minutes',
      AppLanguage.arabic: 'دقائق',
      AppLanguage.sorani: 'خولەک',
      AppLanguage.badini: 'deqîqe',
    },
    'audio.cancelTimer': <AppLanguage, String>{
      AppLanguage.english: 'Cancel timer',
      AppLanguage.arabic: 'إلغاء المؤقت',
      AppLanguage.sorani: 'پاشگەزبوونەوە لە کاتژمێر',
      AppLanguage.badini: 'Demjimêrê betal bike',
    },
    'audio.chooseReciter': <AppLanguage, String>{
      AppLanguage.english: 'Choose Reciter',
      AppLanguage.arabic: 'اختر القارئ',
      AppLanguage.sorani: 'قاری هەڵبژێرە',
      AppLanguage.badini: 'Qarî hilbijêre',
    },

    // ─────────────── Duas ───────────────
    'duas.title': <AppLanguage, String>{
      AppLanguage.english: 'Duas & Adhkar',
      AppLanguage.arabic: 'الأدعية والأذكار',
      AppLanguage.sorani: 'دوعا و زیکر',
      AppLanguage.badini: 'Dua û Zikir',
    },
    'duas.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'Authentic supplications for every moment',
      AppLanguage.arabic: 'أدعية صحيحة لكل لحظة',
      AppLanguage.sorani: 'دوعای ڕاست بۆ هەموو ساتێک',
      AppLanguage.badini: 'Duayên rast bo her demekê',
    },
    'duas.transliteration': <AppLanguage, String>{
      AppLanguage.english: 'TRANSLITERATION',
      AppLanguage.arabic: 'النقحرة',
      AppLanguage.sorani: 'دەنگنووسین',
      AppLanguage.badini: 'DENGNIVÎS',
    },
    'duas.translation': <AppLanguage, String>{
      AppLanguage.english: 'TRANSLATION',
      AppLanguage.arabic: 'الترجمة',
      AppLanguage.sorani: 'وەرگێڕان',
      AppLanguage.badini: 'WERGER',
    },
    'duas.reference': <AppLanguage, String>{
      AppLanguage.english: 'REFERENCE',
      AppLanguage.arabic: 'المصدر',
      AppLanguage.sorani: 'سەرچاوە',
      AppLanguage.badini: 'JÊDER',
    },
    'duas.shareStory': <AppLanguage, String>{
      AppLanguage.english: 'Share Story',
      AppLanguage.arabic: 'مشاركة كقصة',
      AppLanguage.sorani: 'هاوبەشکردن وەک چیرۆک',
      AppLanguage.badini: 'Wek çîrok parve bike',
    },
    'duas.copy': <AppLanguage, String>{
      AppLanguage.english: 'Copy',
      AppLanguage.arabic: 'نسخ',
      AppLanguage.sorani: 'کۆپی',
      AppLanguage.badini: 'Kopî',
    },
    'duas.send': <AppLanguage, String>{
      AppLanguage.english: 'Send',
      AppLanguage.arabic: 'إرسال',
      AppLanguage.sorani: 'ناردن',
      AppLanguage.badini: 'Şandin',
    },
    'duas.copied': <AppLanguage, String>{
      AppLanguage.english: 'Dua copied 🤍',
      AppLanguage.arabic: 'تم نسخ الدعاء 🤍',
      AppLanguage.sorani: 'دوعا کۆپی کرا 🤍',
      AppLanguage.badini: 'Dua hat kopîkirin 🤍',
    },

    // ─────────────── Onboarding ───────────────
    'onboarding.welcomeTitle': <AppLanguage, String>{
      AppLanguage.english: 'Welcome to Noor',
      AppLanguage.arabic: 'أهلاً بك في نور',
      AppLanguage.sorani: 'بەخێر بێیت بۆ نوور',
      AppLanguage.badini: 'Bi xêr hatî Noor',
    },
    'onboarding.welcomeSub': <AppLanguage, String>{
      AppLanguage.english:
          'A quiet space for the Quran, duas, and remembrance — designed to feel like light.',
      AppLanguage.arabic:
          'فضاء هادئ للقرآن والأدعية والذكر — مصمم ليشعرك بالنور.',
      AppLanguage.sorani:
          'شوێنێکی ئارام بۆ قورئان و دوعا و زیکر — وەکو ڕووناکی هەستی پێ بکەیت.',
      AppLanguage.badini:
          'Cihekî aram bo Qur\'an û dua û zikir — wek ronahiyê tê hîs kirin.',
    },
    'onboarding.readTitle': <AppLanguage, String>{
      AppLanguage.english: 'Read the Quran beautifully',
      AppLanguage.arabic: 'اقرأ القرآن بشكل جميل',
      AppLanguage.sorani: 'قورئان بە جوانی بخوێنەوە',
      AppLanguage.badini: 'Qur\'anê bi xweşî bixwîne',
    },
    'onboarding.readSub': <AppLanguage, String>{
      AppLanguage.english:
          'Pick up exactly where you left off. Bookmark verses. Listen along with reciters you love.',
      AppLanguage.arabic:
          'تابع من حيث توقفت تمامًا. احفظ الآيات. استمع لقرائك المفضلين.',
      AppLanguage.sorani:
          'بەردەوام بە لە ئەو شوێنەی کە مایتەوە. ئایەتەکان نیشانە بکە. گوێ بگرە لە قاریە دڵخوازەکانت.',
      AppLanguage.badini:
          'Ji cihê ku te dawî lê anî bidomîne. Ayetan tomar bike. Guh bide qarîyên dilxwaz.',
    },
    'onboarding.duaTitle': <AppLanguage, String>{
      AppLanguage.english: 'Find calm in dua',
      AppLanguage.arabic: 'اجد السكينة في الدعاء',
      AppLanguage.sorani: 'ئارامیی لە دوعادا بدۆزەرەوە',
      AppLanguage.badini: 'Aramiyê di duayê de bibîne',
    },
    'onboarding.duaSub': <AppLanguage, String>{
      AppLanguage.english:
          'Anxiety, sleep, protection, gratitude — authentic duas, beautifully presented.',
      AppLanguage.arabic:
          'القلق، النوم، الحماية، الامتنان — أدعية صحيحة، معروضة بجمال.',
      AppLanguage.sorani:
          'دڵەڕاوکێ، خەو، پاراستن، سوپاسگوزاری — دوعای ڕاست، بە جوانی پێشکەشکراو.',
      AppLanguage.badini:
          'Xemgînî, xew, parastin, spasî — duayên rast, bi xweşî pêşkêş kirin.',
    },
    'onboarding.notifTitle': <AppLanguage, String>{
      AppLanguage.english: 'Gentle reminders',
      AppLanguage.arabic: 'تذكيرات لطيفة',
      AppLanguage.sorani: 'بیرخستنەوەی نەرم',
      AppLanguage.badini: 'Bîrxistinên nerm',
    },
    'onboarding.notifSub': <AppLanguage, String>{
      AppLanguage.english:
          'Soft hourly notifications to bring your heart back to remembrance — your way.',
      AppLanguage.arabic:
          'إشعارات هادئة كل ساعة لتعيد قلبك إلى الذكر — على طريقتك.',
      AppLanguage.sorani:
          'ئاگاداری نەرمی کاتژمێرانە بۆ ئەوەی دڵت بگەڕێتەوە بۆ زیکر — بە شێوازی خۆت.',
      AppLanguage.badini:
          'Agahdariyên nerm yên seetane bo dilê te vegerîne ber zikrê — bi awayê xwe.',
    },
    'onboarding.skip': <AppLanguage, String>{
      AppLanguage.english: 'Skip',
      AppLanguage.arabic: 'تخطي',
      AppLanguage.sorani: 'بازدان',
      AppLanguage.badini: 'Bazdan',
    },
    'onboarding.begin': <AppLanguage, String>{
      AppLanguage.english: 'Begin Your Journey',
      AppLanguage.arabic: 'ابدأ رحلتك',
      AppLanguage.sorani: 'گەشتەکەت دەستپێ بکە',
      AppLanguage.badini: 'Rêwîtiya xwe dest pê bike',
    },

    // ─────────────── Home cards ───────────────
    'home.ayahCount': <AppLanguage, String>{
      AppLanguage.english: 'Ayah',
      AppLanguage.arabic: 'آية',
      AppLanguage.sorani: 'ئایەت',
      AppLanguage.badini: 'Ayet',
    },
    'home.ofWord': <AppLanguage, String>{
      AppLanguage.english: 'of',
      AppLanguage.arabic: 'من',
      AppLanguage.sorani: 'لە',
      AppLanguage.badini: 'ji',
    },
    'home.percentComplete': <AppLanguage, String>{
      AppLanguage.english: 'complete',
      AppLanguage.arabic: 'مكتمل',
      AppLanguage.sorani: 'تەواو',
      AppLanguage.badini: 'temam',
    },
    'home.goal': <AppLanguage, String>{
      AppLanguage.english: 'Goal',
      AppLanguage.arabic: 'الهدف',
      AppLanguage.sorani: 'ئامانج',
      AppLanguage.badini: 'Armanc',
    },
    'home.ayahsPerDay': <AppLanguage, String>{
      AppLanguage.english: 'ayahs/day',
      AppLanguage.arabic: 'آيات/يوم',
      AppLanguage.sorani: 'ئایەت/ڕۆژ',
      AppLanguage.badini: 'ayet/roj',
    },
    'home.recentEmpty': <AppLanguage, String>{
      AppLanguage.english: 'Your recent recitations will appear here',
      AppLanguage.arabic: 'ستظهر تلاواتك الأخيرة هنا',
      AppLanguage.sorani: 'دواین گوێگرتنەکانت لێرە دەردەکەون',
      AppLanguage.badini: 'Guhdarîkirinên te yên dawî dê li vir xuya bibin',
    },
    'home.dayStreak': <AppLanguage, String>{
      AppLanguage.english: 'day streak',
      AppLanguage.arabic: 'يوم متتالي',
      AppLanguage.sorani: 'ڕۆژ بە دوای یەکدا',
      AppLanguage.badini: 'roj li dû hev',
    },
    'home.longest': <AppLanguage, String>{
      AppLanguage.english: 'Longest',
      AppLanguage.arabic: 'الأطول',
      AppLanguage.sorani: 'درێژترین',
      AppLanguage.badini: 'Dirêjtirîn',
    },
    'home.daysWord': <AppLanguage, String>{
      AppLanguage.english: 'days',
      AppLanguage.arabic: 'أيام',
      AppLanguage.sorani: 'ڕۆژ',
      AppLanguage.badini: 'roj',
    },
    'home.keepLight': <AppLanguage, String>{
      AppLanguage.english: 'Keep your light alive',
      AppLanguage.arabic: 'حافظ على نورك',
      AppLanguage.sorani: 'ڕووناکیەکەت بپارێزە',
      AppLanguage.badini: 'Ronahiya xwe biparêze',
    },
    'home.startStreak': <AppLanguage, String>{
      AppLanguage.english: 'Read today to start your streak',
      AppLanguage.arabic: 'اقرأ اليوم لتبدأ سلسلتك',
      AppLanguage.sorani: 'ئەمڕۆ بخوێنەوە بۆ دەستپێکردنی زنجیرەکەت',
      AppLanguage.badini: 'Îro bixwîne ji bo destpêkirina zincîra xwe',
    },
    'home.next': <AppLanguage, String>{
      AppLanguage.english: 'Next',
      AppLanguage.arabic: 'التالي',
      AppLanguage.sorani: 'دواتر',
      AppLanguage.badini: 'Pişt',
    },
    'home.in': <AppLanguage, String>{
      AppLanguage.english: 'in',
      AppLanguage.arabic: 'بعد',
      AppLanguage.sorani: 'لە',
      AppLanguage.badini: 'di',
    },

    // ─────────────── Profile stats ───────────────
    'profile.bookmarksStat': <AppLanguage, String>{
      AppLanguage.english: 'Bookmarks',
      AppLanguage.arabic: 'الإشارات',
      AppLanguage.sorani: 'نیشاندانەکان',
      AppLanguage.badini: 'Nîşandayîn',
    },
    'profile.longestStreak': <AppLanguage, String>{
      AppLanguage.english: 'Longest Streak',
      AppLanguage.arabic: 'أطول سلسلة',
      AppLanguage.sorani: 'درێژترین زنجیرە',
      AppLanguage.badini: 'Zincîra Dirêjtirîn',
    },
    'profile.savedDuas': <AppLanguage, String>{
      AppLanguage.english: 'Saved Duas',
      AppLanguage.arabic: 'الأدعية المحفوظة',
      AppLanguage.sorani: 'دوعا پاشەکەوتکراوەکان',
      AppLanguage.badini: 'Duayên parastî',
    },
    'profile.dayStreakLabel': <AppLanguage, String>{
      AppLanguage.english: 'Day Streak',
      AppLanguage.arabic: 'سلسلة الأيام',
      AppLanguage.sorani: 'زنجیرەی ڕۆژەکان',
      AppLanguage.badini: 'Zincîra rojan',
    },

    // ─────────────── Reciter picker sheet ───────────────
    'reciter.available': <AppLanguage, String>{
      AppLanguage.english: 'reciters available',
      AppLanguage.arabic: 'قارئ متاح',
      AppLanguage.sorani: 'قاری بەردەستە',
      AppLanguage.badini: 'qarî di destê de',
    },
    'reciter.playing': <AppLanguage, String>{
      AppLanguage.english: 'PLAYING',
      AppLanguage.arabic: 'قيد التشغيل',
      AppLanguage.sorani: 'دەنواندرێت',
      AppLanguage.badini: 'Tê Lêdan',
    },
    'reciter.chooseTooltip': <AppLanguage, String>{
      AppLanguage.english: 'Choose reciter',
      AppLanguage.arabic: 'اختر القارئ',
      AppLanguage.sorani: 'قاری هەڵبژێرە',
      AppLanguage.badini: 'Qarî hilbijêre',
    },

    // ─────────────── Misc ───────────────
    'common.tafsirNotBundled': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir audio not yet bundled — coming soon 🤍',
      AppLanguage.arabic: 'تسجيل التفسير غير متاح بعد — قريبًا 🤍',
      AppLanguage.sorani: 'دەنگی تەفسیر هێشتا نییە — بە زووی 🤍',
      AppLanguage.badini: 'Dengê tefsîrê hîna ne hatiye amade kirin — zû tê 🤍',
    },
    'common.dhikrCompleted': <AppLanguage, String>{
      AppLanguage.english: 'Complete 🤍',
      AppLanguage.arabic: 'مكتمل 🤍',
      AppLanguage.sorani: 'تەواو 🤍',
      AppLanguage.badini: 'Temam 🤍',
    },
    'common.keepRemembrance': <AppLanguage, String>{
      AppLanguage.english: 'Keep your tongue moist with His remembrance 🤍',
      AppLanguage.arabic: 'حافظ على لسانك رطبًا بذكره 🤍',
      AppLanguage.sorani: 'زمانت بە زیکری ئەو تەڕ ڕابگرە 🤍',
      AppLanguage.badini: 'Zimanê xwe bi zikrê wî şîl bihêle 🤍',
    },
    'dhikr.resetTitle': <AppLanguage, String>{
      AppLanguage.english: 'Reset all counters?',
      AppLanguage.arabic: 'إعادة تعيين جميع العدادات؟',
      AppLanguage.sorani: 'هەموو ژمێرەکان بکەرەوە؟',
      AppLanguage.badini: 'Hemû hejmaran vegerîne?',
    },
    'dhikr.resetBody': <AppLanguage, String>{
      AppLanguage.english:
          'This will set every dhikr counter back to zero. Your day total will also reset.',
      AppLanguage.arabic:
          'سيُعاد كل عدّاد ذكر إلى الصفر. سيتم أيضًا إعادة تعيين إجمالي اليوم.',
      AppLanguage.sorani:
          'هەموو ژمێرەری زیکر دەگەڕێنرێتەوە بۆ سفر. کۆی ڕۆژیشت دەگەڕێنرێتەوە.',
      AppLanguage.badini:
          'Ev ê her hejmara zikrê vegerîne sifirê. Tevheyê rojê jî dê were vegerandin.',
    },
  };

  static String of(AppLanguage lang, String key) {
    final Map<AppLanguage, String>? row = _data[key];
    if (row == null) return key;
    return row[lang] ?? row[AppLanguage.english] ?? key;
  }
}

/// Convenience extension: `context.t('tab.home')`.
extension TranslationsContext on BuildContext {
  String t(String key) {
    final SettingsState settings = read<SettingsState>();
    return Translations.of(settings.language, key);
  }
}
