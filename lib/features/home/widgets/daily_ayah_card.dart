import 'package:flutter/material.dart';

import '../../../core/data/daily_content.dart';
import '../../../core/data/surah_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/surah.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/eyebrow.dart';
import '../../../core/widgets/gold_divider.dart';

/// Ayah-of-the-day card — large Arabic verse + ornamental gold divider +
/// italic Cormorant English translation + surah:ayah reference and actions.
class DailyAyahCard extends StatelessWidget {
  const DailyAyahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Ayah ayah = DailyContent.ayahForToday();
    final Surah surah = SurahData.byNumber(ayah.surahNumber);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/quran/reader',
        arguments: <String, dynamic>{
          'surah': ayah.surahNumber,
          'ayah': ayah.number,
        },
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line, width: 0.7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const EyebrowKey('section.dailyAyah'),
            const SizedBox(height: 18),

            // Arabic
            Text(
              ayah.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(
                fontSize: 28,
                color: AppColors.textPrimary,
                height: 2.0,
              ),
            ),

            const SizedBox(height: 16),
            const Center(child: GoldDivider(width: 160)),
            const SizedBox(height: 14),

            // English (italic Cormorant)
            Text(
              '"${ayah.translation}"',
              textAlign: TextAlign.center,
              style: AppTypography.verseEnglish,
            ),

            const SizedBox(height: 18),
            // Bottom: reference + actions
            Container(
              padding: const EdgeInsets.only(top: 14),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.lineSoft, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${surah.nameTransliteration.toUpperCase()} · ${ayah.surahNumber}:${ayah.number}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 0.88,
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.bookmark_border_rounded,
                            size: 18, color: AppColors.gold),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/share',
                          arguments: <String, dynamic>{
                            'arabic': ayah.arabic,
                            'translation': ayah.translation,
                            'reference':
                                '${surah.nameTransliteration} ${ayah.surahNumber}:${ayah.number}',
                          },
                        ),
                        child: const Icon(Icons.ios_share_rounded,
                            size: 18, color: AppColors.gold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
