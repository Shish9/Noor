import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/surah_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/surah.dart';
import '../../../core/state/quran_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/eyebrow.dart';

/// Continue-reading card — eyebrow, surah name in serif, ayah-of-total
/// progress text, thin gold progress rule. Designed to sit beside the
/// streak card on the home screen in a 14:10 column split.
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final Map<String, dynamic>? last = quran.lastRead;
    if (last == null) return const SizedBox.shrink();

    final int surahNum = last['surah'] as int;
    final int ayahNum = last['ayah'] as int;
    final Surah surah = SurahData.byNumber(surahNum);
    final double progress = (ayahNum / surah.ayahCount).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/quran/reader',
        arguments: <String, dynamic>{'surah': surahNum, 'ayah': ayahNum},
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        constraints: const BoxConstraints(minHeight: 116),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line, width: 0.7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const EyebrowKey('section.continueReading'),
                const SizedBox(height: 4),
                Text(
                  surah.nameTransliteration,
                  style: AppTypography.headlineMedium.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.t('home.ayahCount')} $ayahNum ${context.t('home.ofWord')} ${surah.ayahCount}',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: <Widget>[
                  Container(height: 4, color: AppColors.line),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(height: 4, color: AppColors.gold),
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
