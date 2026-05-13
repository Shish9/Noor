import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/audio_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../audio/widgets/sound_wave.dart';

/// Slim glassy audio bar that appears at the top of the tafsir reader
/// while a recitation is playing for this surah.
class TafsirAudioBar extends StatelessWidget {
  const TafsirAudioBar({super.key, required this.surahName});
  final String surahName;

  String _fmt(Duration d) {
    final String m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final AudioState audio = context.watch<AudioState>();
    if (audio.currentSurahNumber == null) return const SizedBox.shrink();

    final double progress = audio.duration.inMilliseconds == 0
        ? 0
        : audio.position.inMilliseconds / audio.duration.inMilliseconds;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[
                  Color(0xCC0B0D10),
                  Color(0xCC050607),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.emerald.withValues(alpha: 0.3),
                width: 0.6,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.emerald.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 24,
                        height: 22,
                        child: SoundWave(small: true, bars: 4),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              surahName,
                              style: AppTypography.titleMedium
                                  .copyWith(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${audio.reciter.name} · ${_fmt(audio.position)} / ${_fmt(audio.duration)}',
                              style: AppTypography.caption,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: audio.togglePlay,
                        icon: Icon(
                          audio.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: AppColors.emeraldGlow,
                          size: 24,
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
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(18),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(height: 2, color: AppColors.surfaceMuted),
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
    );
  }
}
