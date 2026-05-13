import 'package:flutter/material.dart';

import '../../../core/data/daily_content.dart';
import '../../../core/data/surah_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/surah.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/arabic_pattern.dart';
import '../../../core/widgets/glass_card.dart';

class DailyAyahCard extends StatelessWidget {
  const DailyAyahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Ayah ayah = DailyContent.ayahForToday();
    final Surah surah = SurahData.byNumber(ayah.surahNumber);

    return Stack(
      children: <Widget>[
        GlassCard(
          padding: const EdgeInsets.all(24),
          glowColor: AppColors.emerald,
          glowOpacity: 0.10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      context.t('section.dailyAyah'),
                      style: AppTypography.label.copyWith(
                        color: AppColors.goldLight,
                        letterSpacing: 1.6,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    surah.nameArabic,
                    style: AppTypography.arabic(
                      fontSize: 22,
                      color: AppColors.gold,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Center(
                child: Text(
                  ayah.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: AppTypography.arabicMedium.copyWith(
                    fontSize: 26,
                    height: 1.95,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  '"${ayah.translation}"',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '— ${surah.nameTransliteration} ${ayah.surahNumber}:${ayah.number}',
                  style: AppTypography.caption.copyWith(color: AppColors.gold),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _ActionChip(
                    icon: Icons.bookmark_border_rounded,
                    label: context.t('action.save'),
                    onTap: () {},
                  ),
                  _ActionChip(
                    icon: Icons.headphones_rounded,
                    label: context.t('action.listen'),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/quran/reader',
                      arguments: <String, dynamic>{
                        'surah': ayah.surahNumber,
                        'ayah': ayah.number,
                      },
                    ),
                  ),
                  _ActionChip(
                    icon: Icons.ios_share_rounded,
                    label: context.t('action.share'),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/share',
                      arguments: <String, dynamic>{
                        'arabic': ayah.arabic,
                        'translation': ayah.translation,
                        'reference': '${surah.nameTransliteration} ${ayah.surahNumber}:${ayah.number}',
                      },
                    ),
                    highlight: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: 140,
            height: 140,
            child: ArabicPatternOverlay(opacity: 0.05, scale: 0.7),
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.emerald.withValues(alpha: 0.16)
              : AppColors.surfaceMuted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: highlight
                ? AppColors.emerald.withValues(alpha: 0.4)
                : AppColors.glassBorder,
            width: 0.6,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon,
                size: 16,
                color: highlight ? AppColors.emeraldGlow : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: highlight ? AppColors.emeraldGlow : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
