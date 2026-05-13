import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/state/quran_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Streak card — flame icon + STREAK eyebrow, large numeral + days, 7-bar
/// mini graph at the bottom (matches the Noor design package).
class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final int streak = quran.currentStreak;

    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: <Widget>[
              const Icon(Icons.local_fire_department_rounded,
                  color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                'STREAK',
                style: AppTypography.eyebrow.copyWith(
                  letterSpacing: 1.1,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    '$streak',
                    style: AppTypography.displayMedium.copyWith(fontSize: 32),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.t('home.daysWord'),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: List<Widget>.generate(7, (int i) {
                  final bool active = i < streak.clamp(0, 7);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 6 ? 0 : 3),
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: active ? AppColors.gold : AppColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
