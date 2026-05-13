import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/state/quran_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final int streak = quran.currentStreak;
    final int longest = quran.longestStreak;

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      glowColor: AppColors.emerald,
      glowOpacity: 0.10,
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[AppColors.emerald, AppColors.emeraldDeep],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.emerald.withValues(alpha: 0.45),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.local_fire_department_rounded,
                  color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      '$streak',
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.emeraldGlow,
                        fontFamily: 'Inter',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      context.t('home.dayStreak'),
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Text(
                  longest > 0
                      ? '${context.t('home.longest')}: $longest ${context.t('home.daysWord')} · ${context.t('home.keepLight')}'
                      : context.t('home.startStreak'),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          // 7-day mini calendar
          Row(
            children: List<Widget>.generate(7, (int i) {
              final bool active = i < streak.clamp(0, 7);
              return Container(
                margin: const EdgeInsets.only(left: 3),
                width: 6,
                height: 18 + (i * 2.0),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.emeraldGlow
                      : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: active
                      ? <BoxShadow>[
                          BoxShadow(
                            color: AppColors.emerald.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
