import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/data/reciter_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/reciter.dart';
import '../../../core/state/audio_state.dart';
import '../../../core/state/settings_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Premium bottom sheet for picking the active reciter while reading.
///
/// - Selecting a reciter updates the default in `SettingsState`.
/// - If the surah is currently playing, audio resumes with the new reciter.
/// - If [autoPlaySurahNumber] is provided and nothing is currently playing,
///   playback starts automatically with the chosen reciter.
class ReciterPickerSheet extends StatelessWidget {
  const ReciterPickerSheet({
    super.key,
    this.autoPlaySurahNumber,
  });

  final int? autoPlaySurahNumber;

  static Future<void> show(
    BuildContext context, {
    int? autoPlaySurahNumber,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext _) => ReciterPickerSheet(
        autoPlaySurahNumber: autoPlaySurahNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsState settings = context.watch<SettingsState>();
    final AudioState audio = context.watch<AudioState>();
    final String selectedId = settings.reciterId;

    return DraggableScrollableSheet(
      initialChildSize: 0.66,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (BuildContext _, ScrollController controller) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF101316),
                Color(0xFF050607),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: AppColors.glassBorder, width: 0.6),
              left: BorderSide(color: AppColors.glassBorder, width: 0.6),
              right: BorderSide(color: AppColors.glassBorder, width: 0.6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: <Color>[
                            AppColors.emerald.withValues(alpha: 0.4),
                            AppColors.emerald.withValues(alpha: 0),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.headphones_rounded,
                        color: AppColors.emeraldGlow,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(context.t('audio.chooseReciter'),
                              style: AppTypography.titleLarge),
                          Text(
                            '${ReciterData.all.length} ${context.t('reciter.available')}',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, size: 22),
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  itemCount: ReciterData.all.length,
                  itemBuilder: (BuildContext _, int i) {
                    final Reciter r = ReciterData.all[i];
                    final bool selected = r.id == selectedId;
                    final bool isPlayingThis = audio.isPlaying &&
                        audio.reciter.id == r.id &&
                        audio.currentSurahNumber == autoPlaySurahNumber;
                    return _ReciterTile(
                      reciter: r,
                      selected: selected,
                      isPlaying: isPlayingThis,
                      onTap: () async {
                        HapticFeedback.selectionClick();
                        await context.read<SettingsState>().setReciter(r.id);
                        // If audio is currently playing, swap reciter live;
                        // otherwise start playback for the open surah.
                        if (audio.currentSurahNumber != null) {
                          await context.read<AudioState>().setReciter(r);
                        } else if (autoPlaySurahNumber != null) {
                          await context
                              .read<AudioState>()
                              .playSurah(autoPlaySurahNumber!, reciter: r);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReciterTile extends StatelessWidget {
  const _ReciterTile({
    required this.reciter,
    required this.selected,
    required this.isPlaying,
    required this.onTap,
  });

  final Reciter reciter;
  final bool selected;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.emeraldCardGradient : null,
              color: selected ? null : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? AppColors.emerald.withValues(alpha: 0.5)
                    : AppColors.glassBorder,
                width: 0.6,
              ),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: AppColors.emerald.withValues(alpha: 0.18),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[AppColors.gold, AppColors.goldDeep],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    reciter.name.substring(0, 1),
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        reciter.name,
                        style: AppTypography.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              reciter.style,
                              style: AppTypography.caption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPlaying) ...<Widget>[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.emerald.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                context.t('reciter.playing'),
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.emeraldGlow,
                                  fontSize: 9,
                                  letterSpacing: 0.8,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: <Color>[
                          AppColors.emeraldGlow,
                          AppColors.emerald,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: AppColors.background,
                    ),
                  )
                else
                  Text(
                    reciter.arabicName,
                    style: AppTypography.arabic(
                      fontSize: 16,
                      color: AppColors.gold,
                      height: 1.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
