import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/surah_data.dart';
import '../../core/models/surah.dart';
import '../../core/state/app_state.dart';
import '../../core/state/audio_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'widgets/sound_wave.dart';

/// Floating mini player that appears above the bottom nav whenever audio is active.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioState audio = context.watch<AudioState>();
    final int? num = audio.currentSurahNumber;
    if (num == null) return const SizedBox.shrink();
    final Surah surah = SurahData.byNumber(num);
    final double progress = audio.duration.inMilliseconds == 0
        ? 0
        : audio.position.inMilliseconds / audio.duration.inMilliseconds;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
      child: GestureDetector(
        onTap: () => context.read<AppState>().setTab(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xCC0B0D10),
                    Color(0xCC050607),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.emerald.withValues(alpha: 0.3),
                  width: 0.7,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.emerald.withValues(alpha: 0.2),
                    blurRadius: 22,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: <Color>[
                                AppColors.surfaceMuted,
                                AppColors.surface,
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.4),
                              width: 0.5,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.emerald.withValues(alpha: 0.4),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            surah.nameArabic.characters.first,
                            style: AppTypography.arabic(
                              fontSize: 20,
                              color: AppColors.gold,
                              height: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                surah.nameTransliteration,
                                style: AppTypography.titleMedium.copyWith(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                audio.reciter.name,
                                style: AppTypography.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (audio.isPlaying)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: SizedBox(
                              width: 24,
                              height: 22,
                              child: SoundWave(small: true, bars: 4),
                            ),
                          ),
                        IconButton(
                          onPressed: audio.togglePlay,
                          icon: Icon(
                            audio.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: AppColors.emeraldGlow,
                            size: 26,
                          ),
                        ),
                        IconButton(
                          onPressed: audio.stop,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textTertiary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress hairline
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(22),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 2,
                          color: AppColors.surfaceMuted,
                        ),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 2,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  AppColors.emeraldGlow,
                                  AppColors.gold,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
