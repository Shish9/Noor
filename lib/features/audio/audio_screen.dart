import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/reciter_data.dart';
import '../../core/data/surah_data.dart';
import '../../core/l10n/format_helpers.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/reciter.dart';
import '../../core/models/surah.dart';
import '../../core/state/audio_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';
import 'widgets/full_player.dart';
import 'widgets/sound_wave.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioState audio = context.watch<AudioState>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 200),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Text(context.t('audio.title'), style: AppTypography.displayMedium),
          const SizedBox(height: 4),
          Text(
            context.t('audio.subtitle'),
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 22),

          // Now playing
          if (audio.currentSurahNumber != null) ...<Widget>[
            const FullPlayer(),
            const SizedBox(height: 28),
          ],

          // Reciters
          Text(context.t('audio.reciters'), style: AppTypography.headlineSmall),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ReciterData.all.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (BuildContext _, int i) {
                final Reciter r = ReciterData.all[i];
                return _ReciterCard(reciter: r, selected: audio.reciter.id == r.id);
              },
            ),
          ),
          const SizedBox(height: 28),

          Text(context.t('audio.allSurahs'), style: AppTypography.headlineSmall),
          const SizedBox(height: 12),
          ...SurahData.all.take(20).map((Surah s) => _SurahAudioTile(surah: s)),
        ],
      ),
    );
  }
}

class _ReciterCard extends StatelessWidget {
  const _ReciterCard({required this.reciter, required this.selected});
  final Reciter reciter;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<AudioState>().setReciter(reciter),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: selected
              ? AppColors.emeraldCardGradient
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.emerald.withValues(alpha: 0.5)
                : AppColors.glassBorder,
            width: 0.6,
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.emerald.withValues(alpha: 0.2),
                    blurRadius: 18,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: <Color>[AppColors.gold, AppColors.goldDeep],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.32),
                    blurRadius: 14,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                reciter.name.substring(0, 1),
                style: AppTypography.titleLarge.copyWith(color: AppColors.background),
              ),
            ),
            const Spacer(),
            Text(
              Fmt.reciterName(context, reciter),
              style: AppTypography.titleMedium.copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 2),
            Text(
              reciter.style,
              style: AppTypography.caption.copyWith(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahAudioTile extends StatelessWidget {
  const _SurahAudioTile({required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final AudioState audio = context.watch<AudioState>();
    final bool isCurrent = audio.currentSurahNumber == surah.number;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
        borderRadius: 16,
        gradient: isCurrent ? AppColors.emeraldCardGradient : null,
        borderColor: isCurrent
            ? AppColors.emerald.withValues(alpha: 0.4)
            : null,
        onTap: () {
          if (isCurrent) {
            context.read<AudioState>().togglePlay();
          } else {
            context.read<AudioState>().playSurah(surah.number);
          }
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCurrent
                    ? const LinearGradient(
                        colors: <Color>[AppColors.emerald, AppColors.emeraldDeep],
                      )
                    : null,
                color: isCurrent ? null : AppColors.surfaceMuted,
                boxShadow: isCurrent
                    ? <BoxShadow>[
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.4),
                          blurRadius: 14,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isCurrent && audio.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: isCurrent ? AppColors.background : AppColors.textPrimary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(Fmt.surahName(context, surah), style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.meaning} · ${surah.ayahCount} ayahs',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            if (isCurrent && audio.isPlaying)
              const SizedBox(
                width: 28,
                height: 24,
                child: SoundWave(small: true),
              )
            else
              Text(
                surah.nameArabic,
                style: AppTypography.arabic(
                  fontSize: 18,
                  color: AppColors.gold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
