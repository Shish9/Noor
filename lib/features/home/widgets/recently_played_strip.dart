import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/reciter_data.dart';
import '../../../core/data/surah_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/reciter.dart';
import '../../../core/models/surah.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/state/audio_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class RecentlyPlayedStrip extends StatelessWidget {
  const RecentlyPlayedStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recent = StorageService.instance.recentlyPlayed;

    if (recent.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.glassBorder, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              const Icon(Icons.graphic_eq_rounded, color: AppColors.textTertiary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.t('home.recentEmpty'),
                  style: AppTypography.bodySmall,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: recent.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (BuildContext _, int i) {
          final Map<String, dynamic> item = recent[i];
          final Surah s = SurahData.byNumber(item['surah'] as int);
          final Reciter r = ReciterData.byId(item['reciter'] as String);
          return _RecentTile(surah: s, reciter: r);
        },
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.surah, required this.reciter});
  final Surah surah;
  final Reciter reciter;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<AudioState>().playSurah(surah.number, reciter: reciter),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[AppColors.emerald, AppColors.emeraldDeep],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x6610B981),
                    blurRadius: 14,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: AppColors.background, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    surah.nameTransliteration,
                    style: AppTypography.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reciter.name,
                    style: AppTypography.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
