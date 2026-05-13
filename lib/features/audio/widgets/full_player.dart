import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/surah_data.dart';
import '../../../core/l10n/format_helpers.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/surah.dart';
import '../../../core/state/audio_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import 'sound_wave.dart';

class FullPlayer extends StatelessWidget {
  const FullPlayer({super.key});

  String _fmt(Duration d) {
    final String m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showSpeedSheet(BuildContext context) {
    final AudioState audio = context.read<AudioState>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(context.t('audio.playbackSpeed'), style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              for (final double s in <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${s}x',
                      style: AppTypography.bodyLarge.copyWith(
                        color: audio.speed == s
                            ? AppColors.emeraldGlow
                            : AppColors.textPrimary,
                      )),
                  trailing: audio.speed == s
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.emeraldGlow)
                      : null,
                  onTap: () {
                    audio.setSpeed(s);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSleepSheet(BuildContext context) {
    final AudioState audio = context.read<AudioState>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(context.t('audio.sleepTimer'), style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              for (final int min in <int>[5, 10, 15, 30, 45, 60])
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('$min ${context.t('audio.minutes')}',
                      style: AppTypography.bodyLarge),
                  onTap: () {
                    audio.setSleepTimer(Duration(minutes: min));
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.t('audio.cancelTimer'),
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.gold)),
                onTap: () {
                  audio.setSleepTimer(null);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AudioState audio = context.watch<AudioState>();
    final int? num = audio.currentSurahNumber;
    if (num == null) return const SizedBox.shrink();
    final Surah surah = SurahData.byNumber(num);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      gradient: AppColors.emeraldCardGradient,
      borderColor: AppColors.emerald.withValues(alpha: 0.3),
      glowColor: AppColors.emerald,
      glowOpacity: 0.18,
      child: Column(
        children: <Widget>[
          // Now playing header
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.t('audio.nowPlaying'),
                  style: AppTypography.label.copyWith(
                    color: AppColors.emeraldGlow,
                    letterSpacing: 1.6,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              const SoundWave(small: true),
            ],
          ),
          const SizedBox(height: 22),
          // Album art (cosmetic — Arabic letter on glow disc)
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFF1A1D21), Color(0xFF050607)],
              ),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.emerald.withValues(alpha: 0.4),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                surah.nameArabic,
                textAlign: TextAlign.center,
                style: AppTypography.arabic(
                  fontSize: 36,
                  color: AppColors.gold,
                  height: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(Fmt.surahName(context, surah), style: AppTypography.headlineSmall),
          const SizedBox(height: 2),
          Text(Fmt.reciterName(context, audio.reciter), style: AppTypography.bodySmall),
          const SizedBox(height: 18),
          // Progress
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.emerald,
              inactiveTrackColor: AppColors.surfaceMuted,
              thumbColor: AppColors.emeraldGlow,
              overlayColor: AppColors.emerald.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              trackHeight: 3,
            ),
            child: Slider(
              min: 0,
              max: audio.duration.inMilliseconds.toDouble().clamp(1, double.infinity),
              value: audio.position.inMilliseconds
                  .toDouble()
                  .clamp(0, audio.duration.inMilliseconds.toDouble()),
              onChanged: (double v) =>
                  audio.seek(Duration(milliseconds: v.toInt())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_fmt(audio.position), style: AppTypography.caption),
                Text(_fmt(audio.duration), style: AppTypography.caption),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () => _showSleepSheet(context),
                icon: Icon(
                  Icons.bedtime_outlined,
                  color: audio.sleepTimer != null
                      ? AppColors.emeraldGlow
                      : AppColors.textTertiary,
                  size: 22,
                ),
              ),
              IconButton(
                onPressed: () => audio.seek(audio.position - const Duration(seconds: 10)),
                icon: const Icon(Icons.replay_10_rounded, size: 28),
                color: AppColors.textPrimary,
              ),
              GestureDetector(
                onTap: audio.togglePlay,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: <Color>[AppColors.emeraldGlow, AppColors.emerald],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.emerald.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    audio.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: AppColors.background,
                    size: 32,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => audio.seek(audio.position + const Duration(seconds: 10)),
                icon: const Icon(Icons.forward_10_rounded, size: 28),
                color: AppColors.textPrimary,
              ),
              IconButton(
                onPressed: () => _showSpeedSheet(context),
                icon: Text(
                  '${audio.speed}x',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
