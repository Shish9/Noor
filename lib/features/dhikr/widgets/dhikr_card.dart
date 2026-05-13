import 'package:flutter/material.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/models/dhikr.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// Premium dhikr counter card.
///
/// - Tap anywhere on the card to increment the count.
/// - Long-press to reset the counter for that phrase.
/// - Progress ring fills as you approach the target (or pulses when unlimited).
class DhikrCard extends StatelessWidget {
  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.count,
    required this.focused,
    required this.onIncrement,
    required this.onReset,
  });

  final Dhikr dhikr;
  final int count;
  final bool focused;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  Color _hex(String hex) {
    final String h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = _hex(dhikr.colorHex);
    final bool completed = !dhikr.isUnlimited && count >= dhikr.target;
    final double progress = dhikr.isUnlimited
        ? 0
        : (count / dhikr.target).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onIncrement,
      onLongPress: onReset,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        gradient: completed
            ? AppColors.emeraldCardGradient
            : AppColors.cardGradient,
        borderColor: completed
            ? accent.withValues(alpha: 0.5)
            : accent.withValues(alpha: 0.25),
        glowColor: focused || completed ? accent : null,
        glowOpacity: completed ? 0.18 : 0.10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Top row: counter ring + virtue
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CounterRing(
                  count: count,
                  target: dhikr.target,
                  progress: progress,
                  color: accent,
                  completed: completed,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dhikr.transliteration,
                        style: AppTypography.titleLarge.copyWith(
                          color: completed ? AppColors.emeraldGlow : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dhikr.translation,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          dhikr.virtue,
                          style: AppTypography.caption.copyWith(
                            color: accent,
                            fontSize: 10,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Arabic body
            Text(
              dhikr.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(
                fontSize: 24,
                color: AppColors.textPrimary,
                height: 1.85,
              ),
            ),
            const SizedBox(height: 8),
            // Hint row
            Row(
              children: <Widget>[
                const Icon(
                  Icons.touch_app_outlined,
                  size: 12,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Text(
                  context.t('dhikr.tapHint'),
                  style: AppTypography.caption.copyWith(fontSize: 10.5),
                ),
                const Spacer(),
                if (completed)
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.emeraldGlow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.t('common.dhikrCompleted'),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.emeraldGlow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRing extends StatelessWidget {
  const _CounterRing({
    required this.count,
    required this.target,
    required this.progress,
    required this.color,
    required this.completed,
  });

  final int count;
  final int target;
  final double progress;
  final Color color;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Background ring
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.surfaceMuted,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Active progress
          if (target > 0)
            SizedBox.expand(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 360),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: progress),
                builder: (BuildContext _, double v, Widget? __) {
                  return CircularProgressIndicator(
                    value: v,
                    strokeWidth: 4,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            ),
          // Inner glow disc
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  color.withValues(alpha: 0.32),
                  color.withValues(alpha: 0),
                ],
              ),
              boxShadow: completed
                  ? <BoxShadow>[
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 16,
                      ),
                    ]
                  : null,
            ),
          ),
          // Number
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$count',
                style: AppTypography.titleLarge.copyWith(
                  color: completed ? AppColors.emeraldGlow : color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              if (target > 0)
                Text(
                  '/ $target',
                  style: AppTypography.caption.copyWith(
                    fontSize: 9,
                    color: AppColors.textTertiary,
                    height: 1.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
