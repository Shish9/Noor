import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/reciter_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/surah.dart';
import '../../../core/state/settings_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'reciter_picker_sheet.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReaderAppBar({
    super.key,
    required this.surah,
    required this.distractionFree,
    required this.onToggleDistraction,
    required this.onPlay,
    required this.isPlaying,
  });

  final Surah surah;
  final bool distractionFree;
  final VoidCallback onToggleDistraction;
  final VoidCallback onPlay;
  final bool isPlaying;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final SettingsState settings = context.watch<SettingsState>();
    final String currentInitial = ReciterData.byId(settings.reciterId)
        .name
        .substring(0, 1);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: preferredSize.height + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.5),
            border: const Border(
              bottom: BorderSide(color: AppColors.divider, width: 0.5),
            ),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: AppColors.textPrimary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      surah.nameTransliteration,
                      style: AppTypography.titleLarge,
                    ),
                    Text(
                      '${context.t('quran.surah')} ${surah.number} · ${surah.ayahCount} ${context.t('settings.ayahs')}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleDistraction,
                tooltip: distractionFree
                    ? context.t('quran.showUI')
                    : context.t('quran.distractionFree'),
                icon: Icon(
                  distractionFree
                      ? Icons.visibility_rounded
                      : Icons.fullscreen_rounded,
                  color: distractionFree
                      ? AppColors.emeraldGlow
                      : AppColors.textPrimary,
                  size: 20,
                ),
              ),
              _ReciterChip(
                initial: currentInitial,
                onTap: () => ReciterPickerSheet.show(
                  context,
                  autoPlaySurahNumber: surah.number,
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: onPlay,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  color: AppColors.emeraldGlow,
                  size: 28,
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReciterChip extends StatelessWidget {
  const _ReciterChip({required this.initial, required this.onTap});
  final String initial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.t('reciter.chooseTooltip'),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: <Color>[AppColors.gold, AppColors.goldDeep],
            ),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.6),
              width: 0.6,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.35),
                blurRadius: 10,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.background,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
