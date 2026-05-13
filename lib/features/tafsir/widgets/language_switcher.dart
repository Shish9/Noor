import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/tafsir.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Horizontal pill switcher for the four tafsir languages.
class TafsirLanguageSwitcher extends StatelessWidget {
  const TafsirLanguageSwitcher({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final TafsirLanguage current;
  final ValueChanged<TafsirLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: <Widget>[
          for (final TafsirLanguage lang in TafsirLanguage.values) ...<Widget>[
            _Pill(
              language: lang,
              selected: lang == current,
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged(lang);
              },
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final TafsirLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.emeraldGradient : null,
          color: selected ? null : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : AppColors.glassBorder,
            width: 0.6,
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.emerald.withValues(alpha: 0.32),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              language.label,
              style: AppTypography.bodySmall.copyWith(
                color: selected ? AppColors.background : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (language.isRtl) ...<Widget>[
              const SizedBox(width: 6),
              Text(
                language == TafsirLanguage.badini ? '◌' : '',
                style: AppTypography.caption.copyWith(
                  color: selected
                      ? AppColors.background.withValues(alpha: 0.6)
                      : AppColors.textTertiary,
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
