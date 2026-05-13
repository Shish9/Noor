import 'package:flutter/material.dart';

import '../../../core/data/dua_data.dart';
import '../../../core/l10n/translations.dart';
import '../../../core/models/dua.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class DailyDuaCard extends StatelessWidget {
  const DailyDuaCard({super.key});

  Dua _duaForToday() {
    final int idx = DateTime.now().day % DuaData.all.length;
    return DuaData.all[idx];
  }

  @override
  Widget build(BuildContext context) {
    final Dua dua = _duaForToday();

    return GlassCard(
      padding: const EdgeInsets.all(22),
      gradient: AppColors.emeraldCardGradient,
      borderColor: AppColors.emerald.withValues(alpha: 0.25),
      glowColor: AppColors.emeraldDeep,
      glowOpacity: 0.10,
      onTap: () => Navigator.pushNamed(
        context,
        '/duas/detail',
        arguments: <String, dynamic>{
          'categoryId': dua.categoryId,
          'duaId': dua.id,
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.t('section.dailyDua'),
                  style: AppTypography.label.copyWith(
                    color: AppColors.emeraldGlow,
                    letterSpacing: 1.6,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.spa_rounded,
                  color: AppColors.emeraldGlow, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Text(dua.title, style: AppTypography.titleLarge),
          const SizedBox(height: 14),
          Text(
            dua.arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: AppTypography.arabicMedium.copyWith(fontSize: 22, height: 1.85),
          ),
          const SizedBox(height: 10),
          Text(
            dua.translation,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
