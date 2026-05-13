import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/data/daily_content.dart';
import '../../core/l10n/translations.dart';
import '../../core/state/quran_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
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

          const SizedBox(height: 14),

          // Streak widget
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: StreakWidget(),
          ).animate().fadeIn(duration: 500.ms, delay: 80.ms).slideY(begin: 0.1),

          const SizedBox(height: 18),

          // Continue reading
          if (quran.lastRead != null) ...<Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ContinueReadingCard(),
            ).animate().fadeIn(duration: 500.ms, delay: 140.ms).slideY(begin: 0.08),
            const SizedBox(height: 22),
          ],

          // Daily Ayah
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DailyAyahCard(),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.08),

          const SizedBox(height: 22),

          // Quick actions
          const QuickActions().animate().fadeIn(duration: 500.ms, delay: 240.ms),

          const SizedBox(height: 26),

          // Daily Dua
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DailyDuaCard(),
          ).animate().fadeIn(duration: 500.ms, delay: 280.ms).slideY(begin: 0.08),

          const SizedBox(height: 22),

          // Prayer reminder
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: PrayerReminderCard(),
          ).animate().fadeIn(duration: 500.ms, delay: 320.ms).slideY(begin: 0.08),

          const SizedBox(height: 28),

          // Recently played
          SectionHeader(title: context.t('section.recentlyPlayed')),
          const RecentlyPlayedStrip().animate().fadeIn(duration: 500.ms, delay: 360.ms),

          const SizedBox(height: 24),

          // Islamic quote
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              padding: const EdgeInsets.all(22),
              gradient: AppColors.goldCardGradient,
              borderColor: AppColors.gold.withValues(alpha: 0.25),
              glowColor: AppColors.gold,
              glowOpacity: 0.10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(Icons.format_quote_rounded, color: AppColors.goldLight),
                      const SizedBox(width: 8),
                      Text(context.t('section.reflection'),
                          style: AppTypography.label.copyWith(color: AppColors.goldLight)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    DailyContent.quoteForToday(),
                    style: AppTypography.displaySmall.copyWith(
                      fontSize: 20,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.08),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  today,
                  style: AppTypography.label.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Text(context.t(_greetingKey()),
                        style: AppTypography.headlineMedium),
                    const SizedBox(width: 6),
                    const Text('🤍', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  context.t('greeting.subtitle'),
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          // Logo / brand mark
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppColors.surface, AppColors.surfaceMuted],
              ),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 0.8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.emerald.withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'ن',
                style: AppTypography.arabic(
                  fontSize: 26,
                  color: AppColors.gold,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
