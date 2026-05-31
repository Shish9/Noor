import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';
import '../../core/state/audio_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_background.dart';
import '../audio/mini_player.dart';
import '../duas/duas_screen.dart';
import '../home/home_screen.dart';
import '../prayer/prayer_screen.dart';
import '../profile/profile_screen.dart';
import '../quran/quran_screen.dart';
import 'glass_nav_bar.dart';

/// Main app shell with persistent bottom navigation, mini audio player,
/// and a single shared animated background.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState app = context.watch<AppState>();
    final AudioState audio = context.watch<AudioState>();

    final List<Widget> tabs = const <Widget>[
      HomeScreen(),
      QuranScreen(),
      DuasScreen(),
      PrayerScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> a) {
              return FadeTransition(
                opacity: a,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.015),
                    end: Offset.zero,
                  ).animate(a),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(app.currentTab),
              child: tabs[app.currentTab],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (audio.currentSurahNumber != null) const MiniPlayer(),
                GlassNavBar(
                  current: app.currentTab,
                  onTap: (int i) => context.read<AppState>().setTab(i),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
