import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/data/daily_content.dart';
import '../../core/l10n/translations.dart';
import '../../core/state/quran_state.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'widgets/continue_reading_card.dart';
import 'widgets/daily_ayah_card.dart';
import 'widgets/daily_dua_card.dart';
import 'widgets/prayer_reminder_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recently_played_strip.dart';
import 'widgets/streak_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 200, top: 8),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          // Greeting header
          const _GreetingHeader().animate().fadeIn(duration: 500.ms),

          const SizedBox(height: 20),

          // Next prayer hero
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: PrayerReminderCard(),
          ).animate().fadeIn(duration: 500.ms, delay: 60.ms).slideY(begin: 0.06),

          const SizedBox(height: 22),

          // Ayah of the day (ornamented book card)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: DailyAyahCard(),
          ).animate().fadeIn(duration: 500.ms, delay: 140.ms).slideY(begin: 0.06),

          // Continue Reading + Streak (2-column)
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (quran.lastRead != null)
                  const Expanded(flex: 14, child: ContinueReadingCard())
                else
                  Expanded(flex: 14, child: _ContinueEmpty(context.t)),
                const SizedBox(width: 12),
                const Expanded(flex: 10, child: StreakWidget()),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 220.ms).slideY(begin: 0.06),

          const SizedBox(height: 24),

          // Today's duas rail
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Text(
                  context.t('home.forMoment'),
                  style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                ),
                Text(
                  context.t('home.seeAll'),
                  style: AppTypography.button.copyWith(
                    color: AppColors.gold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const DailyDuaCard().animate().fadeIn(duration: 500.ms, delay: 300.ms),

          const SizedBox(height: 14),
          const QuickActions().animate().fadeIn(duration: 500.ms, delay: 360.ms),

          const SizedBox(height: 26),

          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
            child: Text(
              context.t('section.recentlyPlayed'),
              style: AppTypography.headlineMedium.copyWith(fontSize: 18),
            ),
          ),
          const RecentlyPlayedStrip().animate().fadeIn(duration: 500.ms, delay: 420.ms),
        ],
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  String _greetingKey() {
    final int h = DateTime.now().hour;
    if (h < 5) return 'greeting.night';
    if (h < 12) return 'greeting.morning';
    if (h < 17) return 'greeting.afternoon';
    if (h < 21) return 'greeting.evening';
    return 'greeting.night';
  }

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('EEEE · MMMM d').format(DateTime.now());
    final String name = context.watch<SettingsState>().userName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            today,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          // Greeting line — Cormorant in foreground color
          Text(
            context.t(_greetingKey()),
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 32,
              height: 1.1,
            ),
          ),
          // Name (or default subtitle if no name yet) — italic gold
          Text(
            name.isNotEmpty ? name : context.t('greeting.subtitle'),
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.gold,
              fontStyle: FontStyle.italic,
              fontSize: name.isNotEmpty ? 32 : 22,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueEmpty extends StatelessWidget {
  const _ContinueEmpty(this.t);
  final String Function(String) t;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 0.7),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('OPEN A SURAH',
              style: AppTypography.eyebrow.copyWith(fontSize: 10)),
          const SizedBox(height: 6),
          Text(
            t('home.openSurahToStart'),
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
