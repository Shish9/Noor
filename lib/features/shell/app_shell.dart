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

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 12),
          // Tabs are kept alive (built once, on first visit) so switching is
          // instant and scroll position / loaded data are preserved.
          _LazyTabs(current: app.currentTab),
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

/// Keeps each tab's state alive after first visit. Unvisited tabs render as a
/// cheap placeholder until the user opens them, so startup stays light while
/// switching between already-opened tabs is instant.
class _LazyTabs extends StatefulWidget {
  const _LazyTabs({required this.current});
  final int current;

  @override
  State<_LazyTabs> createState() => _LazyTabsState();
}

class _LazyTabsState extends State<_LazyTabs> {
  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    QuranScreen(),
    DuasScreen(),
    PrayerScreen(),
    ProfileScreen(),
  ];

  final Set<int> _loaded = <int>{};

  @override
  void initState() {
    super.initState();
    _loaded.add(widget.current);
  }

  @override
  void didUpdateWidget(covariant _LazyTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loaded.add(widget.current);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.current,
      children: <Widget>[
        for (int i = 0; i < _tabs.length; i++)
          if (_loaded.contains(i)) _tabs[i] else const SizedBox.shrink(),
      ],
    );
  }
}
