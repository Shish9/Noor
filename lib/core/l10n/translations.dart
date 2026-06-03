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
    },
    'greeting.afternoon': <AppLanguage, String>{
      AppLanguage.english: 'Good afternoon',
      AppLanguage.arabic: 'مساء الخير',
    },
    'greeting.evening': <AppLanguage, String>{
      AppLanguage.english: 'Good evening',
      AppLanguage.arabic: 'مساء الخير',
    },
    'greeting.night': <AppLanguage, String>{
      AppLanguage.english: 'Peaceful night',
      AppLanguage.arabic: 'ليلة هادئة',
    },
    'greeting.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'May your day be filled with light',
      AppLanguage.arabic: 'أسأل الله أن يملأ يومك بالنور',
    },

    // ─────────────── Tabs ───────────────
    'tab.home': <AppLanguage, String>{
      AppLanguage.english: 'Home',
      AppLanguage.arabic: 'الرئيسية',
    },
    'tab.quran': <AppLanguage, String>{
      AppLanguage.english: 'Quran',
      AppLanguage.arabic: 'القرآن',
    },
    'tab.duas': <AppLanguage, String>{
      AppLanguage.english: 'Duas',
      AppLanguage.arabic: 'الأدعية',
    },
    'tab.audio': <AppLanguage, String>{
      AppLanguage.english: 'Audio',
      AppLanguage.arabic: 'الصوت',
    },
    'tab.prayer': <AppLanguage, String>{
      AppLanguage.english: 'Prayer',
      AppLanguage.arabic: 'الصلاة',
    },
    'tab.profile': <AppLanguage, String>{
      AppLanguage.english: 'Profile',
      AppLanguage.arabic: 'الملف الشخصي',
    },

    // ─────────────── Section headers ───────────────
    'section.continueReading': <AppLanguage, String>{
      AppLanguage.english: 'CONTINUE READING',
      AppLanguage.arabic: 'متابعة القراءة',
    },
    'section.dailyAyah': <AppLanguage, String>{
      AppLanguage.english: 'AYAH OF THE DAY',
      AppLanguage.arabic: 'آية اليوم',
    },
    'section.dailyDua': <AppLanguage, String>{
      AppLanguage.english: 'DUA OF THE DAY',
      AppLanguage.arabic: 'دعاء اليوم',
    },
    'section.recentlyPlayed': <AppLanguage, String>{
      AppLanguage.english: 'Recently Played',
      AppLanguage.arabic: 'تم تشغيله مؤخرًا',
    },
    'section.reflection': <AppLanguage, String>{
      AppLanguage.english: 'Reflection',
      AppLanguage.arabic: 'تأمل',
    },
    'section.prayerTimes': <AppLanguage, String>{
      AppLanguage.english: 'PRAYER TIMES',
      AppLanguage.arabic: 'مواقيت الصلاة',
    },

    // ─────────────── Common actions ───────────────
    'action.save': <AppLanguage, String>{
      AppLanguage.english: 'Save',
      AppLanguage.arabic: 'حفظ',
    },
    'action.share': <AppLanguage, String>{
      AppLanguage.english: 'Share',
      AppLanguage.arabic: 'مشاركة',
    },
    'action.listen': <AppLanguage, String>{
      AppLanguage.english: 'Listen',
      AppLanguage.arabic: 'استمع',
    },
    'action.continue': <AppLanguage, String>{
      AppLanguage.english: 'Continue',
      AppLanguage.arabic: 'متابعة',
    },
    'action.cancel': <AppLanguage, String>{
      AppLanguage.english: 'Cancel',
      AppLanguage.arabic: 'إلغاء',
    },
    'action.resetAll': <AppLanguage, String>{
      AppLanguage.english: 'Reset all',
      AppLanguage.arabic: 'إعادة تعيين الكل',
    },
    'action.backToReading': <AppLanguage, String>{
      AppLanguage.english: 'Back to Reading',
      AppLanguage.arabic: 'العودة إلى القراءة',
    },

    // ─────────────── Dhikr ───────────────
    'dhikr.title': <AppLanguage, String>{
      AppLanguage.english: 'Dhikr',
      AppLanguage.arabic: 'الذكر',
    },
    'dhikr.todayCount': <AppLanguage, String>{
      AppLanguage.english: 'dhikr today',
      AppLanguage.arabic: 'ذكر اليوم',
    },
    'dhikr.startHint': <AppLanguage, String>{
      AppLanguage.english: 'Tap any phrase below to start counting',
      AppLanguage.arabic: 'اضغط على أي ذكر بالأسفل لبدء العد',
    },
    'dhikr.tapHint': <AppLanguage, String>{
      AppLanguage.english: 'Tap to count · Long-press to reset',
      AppLanguage.arabic: 'اضغط للعد · اضغط مطولاً لإعادة التعيين',
    },

    // ─────────────── Settings ───────────────
    'settings.title': <AppLanguage, String>{
      AppLanguage.english: 'Settings',
      AppLanguage.arabic: 'الإعدادات',
    },
    'settings.language': <AppLanguage, String>{
      AppLanguage.english: 'Language',
      AppLanguage.arabic: 'اللغة',
    },
    'settings.notifications': <AppLanguage, String>{
      AppLanguage.english: 'Notifications',
      AppLanguage.arabic: 'الإشعارات',
    },
    'settings.reading': <AppLanguage, String>{
      AppLanguage.english: 'Reading',
      AppLanguage.arabic: 'القراءة',
    },
    'settings.audio': <AppLanguage, String>{
      AppLanguage.english: 'Audio',
      AppLanguage.arabic: 'الصوت',
    },
    'settings.languageChanged': <AppLanguage, String>{
      AppLanguage.english: 'Language changed to English',
      AppLanguage.arabic: 'تم تغيير اللغة إلى العربية',
    },

    // ─────────────── Profile ───────────────
    'profile.preferences': <AppLanguage, String>{
      AppLanguage.english: 'Preferences',
      AppLanguage.arabic: 'التفضيلات',
    },
    'profile.spiritual': <AppLanguage, String>{
      AppLanguage.english: 'Spiritual',
      AppLanguage.arabic: 'روحاني',
    },
    'profile.about': <AppLanguage, String>{
      AppLanguage.english: 'About',
      AppLanguage.arabic: 'حول',
    },
    'profile.bookmarks': <AppLanguage, String>{
      AppLanguage.english: 'My Bookmarks',
      AppLanguage.arabic: 'إشاراتي',
    },
    'profile.favoriteDuas': <AppLanguage, String>{
      AppLanguage.english: 'Favorite Duas',
      AppLanguage.arabic: 'الأدعية المفضلة',
    },
    'profile.history': <AppLanguage, String>{
      AppLanguage.english: 'Reading History',
      AppLanguage.arabic: 'سجل القراءة',
    },
    'profile.dhikrCounter': <AppLanguage, String>{
      AppLanguage.english: 'Dhikr Counter',
      AppLanguage.arabic: 'عداد الذكر',
    },
    'profile.tafsirSoon': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir (Coming Soon)',
      AppLanguage.arabic: 'التفسير (قريبًا)',
    },
    'profile.aboutApp': <AppLanguage, String>{
      AppLanguage.english: 'About Noor',
      AppLanguage.arabic: 'حول نور',
    },
    'profile.shareApp': <AppLanguage, String>{
      AppLanguage.english: 'Share Noor with friends',
      AppLanguage.arabic: 'شارك نور مع الأصدقاء',
    },
    'profile.rateApp': <AppLanguage, String>{
      AppLanguage.english: 'Rate the app',
      AppLanguage.arabic: 'قيّم التطبيق',
    },
    'profile.streak': <AppLanguage, String>{
      AppLanguage.english: 'Day Streak',
      AppLanguage.arabic: 'سلسلة الأيام',
    },
    'profile.assalam': <AppLanguage, String>{
      AppLanguage.english: 'Assalamu Alaikum',
      AppLanguage.arabic: 'السلام عليكم',
    },
    'profile.journey': <AppLanguage, String>{
      AppLanguage.english: 'Your spiritual journey continues 🤍',
      AppLanguage.arabic: 'رحلتك الروحانية مستمرة 🤍',
    },

    // ─────────────── Quick Actions ───────────────
    'quick.dhikr': <AppLanguage, String>{
      AppLanguage.english: 'Dhikr',
      AppLanguage.arabic: 'الذكر',
    },
    'quick.tafsir': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir',
      AppLanguage.arabic: 'التفسير',
    },

    // ─────────────── Tafsir Coming Soon ───────────────
    'tafsir.title': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir',
      AppLanguage.arabic: 'التفسير',
    },
    'tafsir.comingSoon': <AppLanguage, String>{
      AppLanguage.english: 'COMING SOON',
      AppLanguage.arabic: 'قريبًا',
    },
    'tafsir.preparing': <AppLanguage, String>{
      AppLanguage.english:
          'Verse-by-verse tafsir is being prepared with care 🤍',
      AppLanguage.arabic: 'التفسير آية بآية يُعدّ بعناية 🤍',
    },
    'tafsir.plannedLanguages': <AppLanguage, String>{
      AppLanguage.english: 'PLANNED LANGUAGES',
      AppLanguage.arabic: 'اللغات المخطط لها',
    },

    // ─────────────── Settings body ───────────────
    'settings.hourlyReminders': <AppLanguage, String>{
      AppLanguage.english: 'Hourly dua reminders',
      AppLanguage.arabic: 'تذكيرات الأدعية كل ساعة',
    },
    'settings.hourlyRemindersHint': <AppLanguage, String>{
      AppLanguage.english: 'Soft, calming notifications throughout the day',
      AppLanguage.arabic: 'إشعارات هادئة ولطيفة طوال اليوم',
    },
    'settings.reminderInterval': <AppLanguage, String>{
      AppLanguage.english: 'Reminder interval',
      AppLanguage.arabic: 'فاصل التذكير',
    },
    'settings.everyXh': <AppLanguage, String>{
      AppLanguage.english: 'Every',
      AppLanguage.arabic: 'كل',
    },
    'settings.silentMode': <AppLanguage, String>{
      AppLanguage.english: 'Silent mode',
      AppLanguage.arabic: 'الوضع الصامت',
    },
    'settings.silentHint': <AppLanguage, String>{
      AppLanguage.english: 'Notifications without sound or vibration',
      AppLanguage.arabic: 'إشعارات بدون صوت أو اهتزاز',
    },
    'settings.fontSize': <AppLanguage, String>{
      AppLanguage.english: 'Arabic font size',
      AppLanguage.arabic: 'حجم الخط العربي',
    },
    'settings.showTransliteration': <AppLanguage, String>{
      AppLanguage.english: 'Show transliteration',
      AppLanguage.arabic: 'عرض النقحرة',
    },
    'settings.transliterationHint': <AppLanguage, String>{
      AppLanguage.english: 'Latin pronunciation for Arabic verses',
      AppLanguage.arabic: 'النطق اللاتيني للآيات العربية',
    },
    'settings.dailyGoal': <AppLanguage, String>{
      AppLanguage.english: 'Daily reading goal',
      AppLanguage.arabic: 'هدف القراءة اليومي',
    },
    'settings.ayahs': <AppLanguage, String>{
      AppLanguage.english: 'ayahs',
      AppLanguage.arabic: 'آيات',
    },
    'settings.defaultReciter': <AppLanguage, String>{
      AppLanguage.english: 'Default reciter',
      AppLanguage.arabic: 'القارئ الافتراضي',
    },

    // ─────────────── Quran screen ───────────────
    'quran.title': <AppLanguage, String>{
      AppLanguage.english: 'The Holy Quran',
      AppLanguage.arabic: 'القرآن الكريم',
    },
    'quran.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'القرآن الكريم · 114 surahs · 6,236 ayahs',
      AppLanguage.arabic: 'القرآن الكريم · 114 سورة · 6,236 آية',
    },
    'quran.searchHint': <AppLanguage, String>{
      AppLanguage.english: 'Search surah by name or number',
      AppLanguage.arabic: 'ابحث عن سورة بالاسم أو الرقم',
    },
    'quran.filter.all': <AppLanguage, String>{
      AppLanguage.english: 'All',
      AppLanguage.arabic: 'الكل',
    },
    'quran.filter.meccan': <AppLanguage, String>{
      AppLanguage.english: 'Meccan',
      AppLanguage.arabic: 'مكية',
    },
    'quran.filter.medinan': <AppLanguage, String>{
      AppLanguage.english: 'Medinan',
      AppLanguage.arabic: 'مدنية',
    },
    'quran.surah': <AppLanguage, String>{
      AppLanguage.english: 'Surah',
      AppLanguage.arabic: 'سورة',
    },
    'quran.previous': <AppLanguage, String>{
      AppLanguage.english: 'Previous',
      AppLanguage.arabic: 'السابق',
    },
    'quran.next': <AppLanguage, String>{
      AppLanguage.english: 'Next',
      AppLanguage.arabic: 'التالي',
    },
    'quran.readTafsir': <AppLanguage, String>{
      AppLanguage.english: 'Read Tafsir',
      AppLanguage.arabic: 'قراءة التفسير',
    },
    'quran.distractionFree': <AppLanguage, String>{
      AppLanguage.english: 'Distraction-free',
      AppLanguage.arabic: 'وضع التركيز',
    },
    'quran.showUI': <AppLanguage, String>{
      AppLanguage.english: 'Show UI',
      AppLanguage.arabic: 'إظهار الواجهة',
    },

    // ─────────────── Audio screen ───────────────
    'audio.title': <AppLanguage, String>{
      AppLanguage.english: 'Recitations',
      AppLanguage.arabic: 'التلاوات',
    },
    'audio.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'Beautiful Quran recitations from world-renowned reciters',
      AppLanguage.arabic: 'تلاوات قرآنية بصوت أشهر القراء',
    },
    'audio.reciters': <AppLanguage, String>{
      AppLanguage.english: 'Reciters',
      AppLanguage.arabic: 'القراء',
    },
    'audio.allSurahs': <AppLanguage, String>{
      AppLanguage.english: 'All Surahs',
      AppLanguage.arabic: 'جميع السور',
    },
    'audio.nowPlaying': <AppLanguage, String>{
      AppLanguage.english: 'NOW PLAYING',
      AppLanguage.arabic: 'يُشغّل الآن',
    },
    'audio.playbackSpeed': <AppLanguage, String>{
      AppLanguage.english: 'Playback Speed',
      AppLanguage.arabic: 'سرعة التشغيل',
    },
    'audio.sleepTimer': <AppLanguage, String>{
      AppLanguage.english: 'Sleep Timer',
      AppLanguage.arabic: 'مؤقت النوم',
    },
    'audio.minutes': <AppLanguage, String>{
      AppLanguage.english: 'minutes',
      AppLanguage.arabic: 'دقائق',
    },
    'audio.cancelTimer': <AppLanguage, String>{
      AppLanguage.english: 'Cancel timer',
      AppLanguage.arabic: 'إلغاء المؤقت',
    },
    'audio.chooseReciter': <AppLanguage, String>{
      AppLanguage.english: 'Choose Reciter',
      AppLanguage.arabic: 'اختر القارئ',
    },

    // ─────────────── Duas ───────────────
    'duas.title': <AppLanguage, String>{
      AppLanguage.english: 'Duas & Adhkar',
      AppLanguage.arabic: 'الأدعية والأذكار',
    },
    'duas.subtitle': <AppLanguage, String>{
      AppLanguage.english: 'Authentic supplications for every moment',
      AppLanguage.arabic: 'أدعية صحيحة لكل لحظة',
    },
    'duas.transliteration': <AppLanguage, String>{
      AppLanguage.english: 'TRANSLITERATION',
      AppLanguage.arabic: 'النقحرة',
    },
    'duas.translation': <AppLanguage, String>{
      AppLanguage.english: 'TRANSLATION',
      AppLanguage.arabic: 'الترجمة',
    },
    'duas.reference': <AppLanguage, String>{
      AppLanguage.english: 'REFERENCE',
      AppLanguage.arabic: 'المصدر',
    },
    'duas.shareStory': <AppLanguage, String>{
      AppLanguage.english: 'Share Story',
      AppLanguage.arabic: 'مشاركة كقصة',
    },
    'duas.copy': <AppLanguage, String>{
      AppLanguage.english: 'Copy',
      AppLanguage.arabic: 'نسخ',
    },
    'duas.send': <AppLanguage, String>{
      AppLanguage.english: 'Send',
      AppLanguage.arabic: 'إرسال',
    },
    'duas.copied': <AppLanguage, String>{
      AppLanguage.english: 'Dua copied 🤍',
      AppLanguage.arabic: 'تم نسخ الدعاء 🤍',
    },

    // ─────────────── Onboarding ───────────────
    'onboarding.welcomeTitle': <AppLanguage, String>{
      AppLanguage.english: 'Welcome to Noor',
      AppLanguage.arabic: 'أهلاً بك في نور',
    },
    'onboarding.welcomeSub': <AppLanguage, String>{
      AppLanguage.english:
          'A quiet space for the Quran, duas, and remembrance — designed to feel like light.',
      AppLanguage.arabic:
          'فضاء هادئ للقرآن والأدعية والذكر — مصمم ليشعرك بالنور.',
    },
    'onboarding.readTitle': <AppLanguage, String>{
      AppLanguage.english: 'Read the Quran beautifully',
      AppLanguage.arabic: 'اقرأ القرآن بشكل جميل',
    },
    'onboarding.readSub': <AppLanguage, String>{
      AppLanguage.english:
          'Pick up exactly where you left off. Bookmark verses. Listen along with reciters you love.',
      AppLanguage.arabic:
          'تابع من حيث توقفت تمامًا. احفظ الآيات. استمع لقرائك المفضلين.',
    },
    'onboarding.duaTitle': <AppLanguage, String>{
      AppLanguage.english: 'Find calm in dua',
      AppLanguage.arabic: 'اجد السكينة في الدعاء',
    },
    'onboarding.duaSub': <AppLanguage, String>{
      AppLanguage.english:
          'Anxiety, sleep, protection, gratitude — authentic duas, beautifully presented.',
      AppLanguage.arabic:
          'القلق، النوم، الحماية، الامتنان — أدعية صحيحة، معروضة بجمال.',
    },
    'onboarding.notifTitle': <AppLanguage, String>{
      AppLanguage.english: 'Gentle reminders',
      AppLanguage.arabic: 'تذكيرات لطيفة',
    },
    'onboarding.notifSub': <AppLanguage, String>{
      AppLanguage.english:
          'Soft hourly notifications to bring your heart back to remembrance — your way.',
      AppLanguage.arabic:
          'إشعارات هادئة كل ساعة لتعيد قلبك إلى الذكر — على طريقتك.',
    },
    'onboarding.skip': <AppLanguage, String>{
      AppLanguage.english: 'Skip',
      AppLanguage.arabic: 'تخطي',
    },
    'onboarding.begin': <AppLanguage, String>{
      AppLanguage.english: 'Begin',
      AppLanguage.arabic: 'ابدأ',
    },
    'onboarding.enterApp': <AppLanguage, String>{
      AppLanguage.english: 'Enter Noor',
      AppLanguage.arabic: 'ادخل نور',
    },
    'onboarding.continue': <AppLanguage, String>{
      AppLanguage.english: 'Continue',
      AppLanguage.arabic: 'متابعة',
    },
    'onboarding.nameTitle': <AppLanguage, String>{
      AppLanguage.english: 'What should we call you?',
      AppLanguage.arabic: 'ما اسمك؟',
    },
    'onboarding.nameSubtitle': <AppLanguage, String>{
      AppLanguage.english:
          'We\'ll greet you with this name every time you open Noor.',
      AppLanguage.arabic:
          'سنحييك بهذا الاسم في كل مرة تفتح فيها نور.',
    },
    'onboarding.namePlaceholder': <AppLanguage, String>{
      AppLanguage.english: 'Your name',
      AppLanguage.arabic: 'اسمك',
    },
    'onboarding.nameHint': <AppLanguage, String>{
      AppLanguage.english: 'You can change this later in Settings.',
      AppLanguage.arabic: 'يمكنك تغييره لاحقًا في الإعدادات.',
    },
    'onboarding.nameRequired': <AppLanguage, String>{
      AppLanguage.english: 'Please enter your name to continue.',
      AppLanguage.arabic: 'الرجاء إدخال اسمك للمتابعة.',
    },

    // ─────────────── Home cards ───────────────
    'home.ayahCount': <AppLanguage, String>{
      AppLanguage.english: 'Ayah',
      AppLanguage.arabic: 'آية',
    },
    'home.ofWord': <AppLanguage, String>{
      AppLanguage.english: 'of',
      AppLanguage.arabic: 'من',
    },
    'home.percentComplete': <AppLanguage, String>{
      AppLanguage.english: 'complete',
      AppLanguage.arabic: 'مكتمل',
    },
    'home.goal': <AppLanguage, String>{
      AppLanguage.english: 'Goal',
      AppLanguage.arabic: 'الهدف',
    },
    'home.ayahsPerDay': <AppLanguage, String>{
      AppLanguage.english: 'ayahs/day',
      AppLanguage.arabic: 'آيات/يوم',
    },
    'home.recentEmpty': <AppLanguage, String>{
      AppLanguage.english: 'Your recent recitations will appear here',
      AppLanguage.arabic: 'ستظهر تلاواتك الأخيرة هنا',
    },
    'home.dayStreak': <AppLanguage, String>{
      AppLanguage.english: 'day streak',
      AppLanguage.arabic: 'يوم متتالي',
    },
    'home.longest': <AppLanguage, String>{
      AppLanguage.english: 'Longest',
      AppLanguage.arabic: 'الأطول',
    },
    'home.daysWord': <AppLanguage, String>{
      AppLanguage.english: 'days',
      AppLanguage.arabic: 'أيام',
    },
    'home.keepLight': <AppLanguage, String>{
      AppLanguage.english: 'Keep your light alive',
      AppLanguage.arabic: 'حافظ على نورك',
    },
    'home.startStreak': <AppLanguage, String>{
      AppLanguage.english: 'Read today to start your streak',
      AppLanguage.arabic: 'اقرأ اليوم لتبدأ سلسلتك',
    },
    'home.next': <AppLanguage, String>{
      AppLanguage.english: 'Next',
      AppLanguage.arabic: 'التالي',
    },
    'home.in': <AppLanguage, String>{
      AppLanguage.english: 'in',
      AppLanguage.arabic: 'بعد',
    },

    // ─────────────── Profile stats ───────────────
    'profile.bookmarksStat': <AppLanguage, String>{
      AppLanguage.english: 'Bookmarks',
      AppLanguage.arabic: 'الإشارات',
    },
    'profile.longestStreak': <AppLanguage, String>{
      AppLanguage.english: 'Longest Streak',
      AppLanguage.arabic: 'أطول سلسلة',
    },
    'profile.savedDuas': <AppLanguage, String>{
      AppLanguage.english: 'Saved Duas',
      AppLanguage.arabic: 'الأدعية المحفوظة',
    },
    'profile.dayStreakLabel': <AppLanguage, String>{
      AppLanguage.english: 'Day Streak',
      AppLanguage.arabic: 'سلسلة الأيام',
    },

    // ─────────────── Reciter picker sheet ───────────────
    'reciter.available': <AppLanguage, String>{
      AppLanguage.english: 'reciters available',
      AppLanguage.arabic: 'قارئ متاح',
    },
    'reciter.playing': <AppLanguage, String>{
      AppLanguage.english: 'PLAYING',
      AppLanguage.arabic: 'قيد التشغيل',
    },
    'reciter.chooseTooltip': <AppLanguage, String>{
      AppLanguage.english: 'Choose reciter',
      AppLanguage.arabic: 'اختر القارئ',
    },

    // ─────────────── Misc ───────────────
    'common.tafsirNotBundled': <AppLanguage, String>{
      AppLanguage.english: 'Tafsir audio not yet bundled — coming soon 🤍',
      AppLanguage.arabic: 'تسجيل التفسير غير متاح بعد — قريبًا 🤍',
    },
    'common.dhikrCompleted': <AppLanguage, String>{
      AppLanguage.english: 'Complete 🤍',
      AppLanguage.arabic: 'مكتمل 🤍',
    },
    'common.keepRemembrance': <AppLanguage, String>{
      AppLanguage.english: 'Keep your tongue moist with His remembrance 🤍',
      AppLanguage.arabic: 'حافظ على لسانك رطبًا بذكره 🤍',
    },
    'dhikr.resetTitle': <AppLanguage, String>{
      AppLanguage.english: 'Reset all counters?',
      AppLanguage.arabic: 'إعادة تعيين جميع العدادات؟',
    },
    'dhikr.resetBody': <AppLanguage, String>{
      AppLanguage.english:
          'This will set every dhikr counter back to zero. Your day total will also reset.',
      AppLanguage.arabic:
          'سيُعاد كل عدّاد ذكر إلى الصفر. سيتم أيضًا إعادة تعيين إجمالي اليوم.',
    },

    // ─────────────── Home (new for Midnight design) ───────────────
    'home.nextPrayer': <AppLanguage, String>{
      AppLanguage.english: 'NEXT PRAYER',
      AppLanguage.arabic: 'الصلاة القادمة',
    },
    'home.forMoment': <AppLanguage, String>{
      AppLanguage.english: 'For this moment',
      AppLanguage.arabic: 'لهذه اللحظة',
    },
    'home.seeAll': <AppLanguage, String>{
      AppLanguage.english: 'See all →',
      AppLanguage.arabic: 'عرض الكل ←',
    },
    'home.openSurahToStart': <AppLanguage, String>{
      AppLanguage.english: 'Open any surah from the Quran tab to begin.',
      AppLanguage.arabic: 'افتح أي سورة من تبويب القرآن للبدء.',
    },

    'home.openSurah': <AppLanguage, String>{
      AppLanguage.english: 'OPEN A SURAH',
      AppLanguage.arabic: 'افتح سورة',
    },
    'home.verse': <AppLanguage, String>{
      AppLanguage.english: 'VERSE',
      AppLanguage.arabic: 'آية',
    },
    'home.streakLabel': <AppLanguage, String>{
      AppLanguage.english: 'STREAK',
      AppLanguage.arabic: 'متتابع',
    },

    // Lock-screen notification preview
    'notif.app': <AppLanguage, String>{
      AppLanguage.english: 'NOOR',
      AppLanguage.arabic: 'نُور',
    },
    'notif.now': <AppLanguage, String>{
      AppLanguage.english: 'now',
      AppLanguage.arabic: 'الآن',
    },
    'notif.agoPrefix': <AppLanguage, String>{
      AppLanguage.english: '',
      AppLanguage.arabic: 'قبل',
    },
    'notif.ago.min': <AppLanguage, String>{
      AppLanguage.english: 'min ago',
      AppLanguage.arabic: 'د',
    },
    'notif.ago.hour': <AppLanguage, String>{
      AppLanguage.english: 'h ago',
      AppLanguage.arabic: 'س',
    },
    'notif.close': <AppLanguage, String>{
      AppLanguage.english: 'Close preview',
      AppLanguage.arabic: 'إغلاق المعاينة',
    },
    'notif.asrBody': <AppLanguage, String>{
      AppLanguage.english: 'It\'s time for Asr',
      AppLanguage.arabic: 'حان وقت العصر',
    },
    'notif.verseRef': <AppLanguage, String>{
      AppLanguage.english: 'AL-BAQARAH · 2:286',
      AppLanguage.arabic: 'البقرة ٢:٢٨٦',
    },
    'notif.streakBody': <AppLanguage, String>{
      AppLanguage.english:
          'You\'ve reached 14 days! Want to keep your Al-Mulk streak?',
      AppLanguage.arabic: 'وصلت إلى ١٤ يومًا! أتريد متابعة الملك؟',
    },
    'settings.previewNotif': <AppLanguage, String>{
      AppLanguage.english: 'Preview lock-screen notifications',
      AppLanguage.arabic: 'معاينة إشعارات شاشة القفل',
    },

    // Prayer screen
    'prayer.title': <AppLanguage, String>{
      AppLanguage.english: 'Prayer',
      AppLanguage.arabic: 'الصلاة',
    },
    'prayer.eyebrow': <AppLanguage, String>{
      AppLanguage.english: 'TODAY',
      AppLanguage.arabic: 'اليوم',
    },
    'prayer.tabTimes': <AppLanguage, String>{
      AppLanguage.english: 'Times',
      AppLanguage.arabic: 'الأوقات',
    },
    'prayer.tabQibla': <AppLanguage, String>{
      AppLanguage.english: 'Qibla',
      AppLanguage.arabic: 'القبلة',
    },
    'prayer.location': <AppLanguage, String>{
      AppLanguage.english: 'Mecca, Saudi Arabia',
      AppLanguage.arabic: 'مكة المكرمة، السعودية',
    },
    'prayer.locating': <AppLanguage, String>{
      AppLanguage.english: 'Finding your location…',
      AppLanguage.arabic: 'جارٍ تحديد موقعك…',
    },
    'prayer.enableLocation': <AppLanguage, String>{
      AppLanguage.english: 'Using default times. Enable location for accuracy.',
      AppLanguage.arabic: 'يتم استخدام أوقات افتراضية. فعّل الموقع للدقة.',
    },
    'prayer.enableCta': <AppLanguage, String>{
      AppLanguage.english: 'Enable',
      AppLanguage.arabic: 'تفعيل',
    },
    'prayer.method': <AppLanguage, String>{
      AppLanguage.english: 'Umm al-Qura · Hanafi',
      AppLanguage.arabic: 'أم القرى · حنفي',
    },
    'prayer.arc': <AppLanguage, String>{
      AppLanguage.english: 'SUN ARC',
      AppLanguage.arabic: 'قوس الشمس',
    },
    'prayer.markFajr': <AppLanguage, String>{
      AppLanguage.english: 'Fajr',
      AppLanguage.arabic: 'الفجر',
    },
    'prayer.markDhuhr': <AppLanguage, String>{
      AppLanguage.english: 'Dhuhr',
      AppLanguage.arabic: 'الظهر',
    },
    'prayer.markNow': <AppLanguage, String>{
      AppLanguage.english: 'Now',
      AppLanguage.arabic: 'الآن',
    },
    'prayer.markMaghrib': <AppLanguage, String>{
      AppLanguage.english: 'Maghrib',
      AppLanguage.arabic: 'المغرب',
    },
    'prayer.nowPill': <AppLanguage, String>{
      AppLanguage.english: 'NOW',
      AppLanguage.arabic: 'الآن',
    },

    // Qibla
    'qibla.direction': <AppLanguage, String>{
      AppLanguage.english: 'QIBLA DIRECTION',
      AppLanguage.arabic: 'اتجاه القبلة',
    },
    'qibla.alignTurn': <AppLanguage, String>{
      AppLanguage.english: 'Turn',
      AppLanguage.arabic: 'استدر',
    },
    'qibla.distance': <AppLanguage, String>{
      AppLanguage.english: 'DISTANCE',
      AppLanguage.arabic: 'المسافة',
    },
    'qibla.distanceValue': <AppLanguage, String>{
      AppLanguage.english: '8,210 km',
      AppLanguage.arabic: '٨٬٢١٠ كم',
    },
    'qibla.offset': <AppLanguage, String>{
      AppLanguage.english: 'MAGNETIC OFFSET',
      AppLanguage.arabic: 'انحراف مغناطيسي',
    },

    // Prayer names
    'prayer.fajr': <AppLanguage, String>{
      AppLanguage.english: 'Fajr',
      AppLanguage.arabic: 'الفجر',
    },
    'prayer.sunrise': <AppLanguage, String>{
      AppLanguage.english: 'Sunrise',
      AppLanguage.arabic: 'الشروق',
    },
    'prayer.dhuhr': <AppLanguage, String>{
      AppLanguage.english: 'Dhuhr',
      AppLanguage.arabic: 'الظهر',
    },
    'prayer.asr': <AppLanguage, String>{
      AppLanguage.english: 'Asr',
      AppLanguage.arabic: 'العصر',
    },
    'prayer.maghrib': <AppLanguage, String>{
      AppLanguage.english: 'Maghrib',
      AppLanguage.arabic: 'المغرب',
    },
    'prayer.isha': <AppLanguage, String>{
      AppLanguage.english: 'Isha',
      AppLanguage.arabic: 'العشاء',
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
