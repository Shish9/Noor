import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/surah_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/surah.dart';
import '../../../core/state/quran_state.dart';
import '../../../core/state/settings_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final SettingsState settings = context.watch<SettingsState>();
    final Map<String, dynamic>? last = quran.lastRead;
    if (last == null) return const SizedBox.shrink();

    final int surahNum = last['surah'] as int;
    final int ayahNum = last['ayah'] as int;
    final Surah surah = SurahData.byNumber(surahNum);
    final double progress = ayahNum / surah.ayahCount;

    return GlassCard(
      gradient: AppColors.emeraldCardGradient,
      borderColor: AppColors.emerald.withValues(alpha: 0.3),
      glowColor: AppColors.emerald,
      glowOpacity: 0.16,
      onTap: () => Navigator.pushNamed(
        context,
        '/quran/reader',
        arguments: <String, dynamic>{'surah': surahNum, 'ayah': ayahNum},
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.t('section.continueReading'),
                  style: AppTypography.label.copyWith(
                    color: AppColors.emeraldGlow,
                    letterSpacing: 1.6,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.emeraldGlow, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      surah.nameTransliteration,
                      style: AppTypography.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${context.t('home.ayahCount')} $ayahNum ${context.t('home.ofWord')} ${surah.ayahCount} · ${surah.meaning}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                surah.nameArabic,
                style: AppTypography.arabic(
                  fontSize: 32,
                  color: AppColors.gold,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 6,
                  color: AppColors.surfaceMuted,
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[AppColors.emeraldGlow, AppColors.emerald],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${(progress * 100).toStringAsFixed(0)}% ${context.t('home.percentComplete')}',
                style: AppTypography.caption,
              ),
              Text(
                '${context.t('home.goal')}: ${settings.dailyReadingGoal} ${context.t('home.ayahsPerDay')}',
                style: AppTypography.caption.copyWith(color: AppColors.gold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
