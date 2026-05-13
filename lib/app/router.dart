import 'package:flutter/material.dart';

import '../features/audio/audio_screen.dart';
import '../features/dhikr/dhikr_screen.dart';
import '../features/duas/dua_category_screen.dart';
import '../features/duas/dua_detail_screen.dart';
import '../features/duas/duas_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_screen.dart';
import '../features/quran/quran_reader_screen.dart';
import '../features/quran/quran_screen.dart';
import '../features/quran/surah_search_screen.dart';
import '../features/share/share_card_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/tafsir/tafsir_reader_screen.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _route(const AppShell(), settings);
      case '/onboarding':
        return _route(const OnboardingScreen(), settings);
      case '/home':
        return _route(const HomeScreen(), settings);
      case '/quran':
        return _route(const QuranScreen(), settings);
      case '/quran/reader':
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return _route(
          QuranReaderScreen(
            surahNumber: (args?['surah'] as int?) ?? 1,
            ayahNumber: args?['ayah'] as int?,
          ),
          settings,
        );
      case '/quran/search':
        return _route(const SurahSearchScreen(), settings);
      case '/audio':
        return _route(const AudioScreen(), settings);
      case '/duas':
        return _route(const DuasScreen(), settings);
      case '/duas/category':
        final String categoryId = settings.arguments as String? ?? 'anxiety';
        return _route(DuaCategoryScreen(categoryId: categoryId), settings);
      case '/duas/detail':
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return _route(
          DuaDetailScreen(
            categoryId: (args?['categoryId'] as String?) ?? 'anxiety',
            duaId: (args?['duaId'] as String?) ?? '',
          ),
          settings,
        );
      case '/profile':
        return _route(const ProfileScreen(), settings);
      case '/settings':
        return _route(const SettingsScreen(), settings);
      case '/share':
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return _route(
          ShareCardScreen(
            arabic: (args?['arabic'] as String?) ?? '',
            translation: (args?['translation'] as String?) ?? '',
            reference: args?['reference'] as String?,
          ),
          settings,
        );
      case '/tafsir':
        final Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
        return _route(
          TafsirReaderScreen(
            surahNumber: (args?['surah'] as int?) ?? 1,
            ayahNumber: args?['ayah'] as int?,
          ),
          settings,
        );
      case '/dhikr':
        return _route(const DhikrScreen(), settings);
    }
    return null;
  }

  static PageRouteBuilder<T> _route<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (BuildContext _, Animation<double> __, Animation<double> ___) => page,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondary,
        Widget child,
      ) {
        final Animation<double> curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
