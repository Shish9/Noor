import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/data/dua_data.dart';
import '../../core/models/dua.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glass_card.dart';

class DuaCategoryScreen extends StatelessWidget {
  const DuaCategoryScreen({super.key, required this.categoryId});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    final DuaCategory cat = DuaData.categoryById(categoryId);
    final List<Dua> duas = DuaData.byCategory(categoryId);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(cat.name, style: AppTypography.titleLarge),
        backgroundColor: AppColors.background.withValues(alpha: 0.4),
      ),
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 12),
          SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 90, 16, 60),
              physics: const BouncingScrollPhysics(),
              itemCount: duas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (BuildContext _, int i) {
                final Dua d = duas[i];
                return _DuaSummaryTile(dua: d).animate().fadeIn(
                      duration: 320.ms,
                      delay: (i * 60).ms,
                    ).slideY(begin: 0.06, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaSummaryTile extends StatelessWidget {
  const _DuaSummaryTile({required this.dua});
  final Dua dua;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
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
              Expanded(
                child: Text(dua.title, style: AppTypography.titleLarge),
              ),
              const Icon(Icons.arrow_forward_rounded,
                  color: AppColors.emeraldGlow, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dua.arabic,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.arabicMedium.copyWith(fontSize: 22, height: 1.7),
          ),
          const SizedBox(height: 10),
          Text(
            dua.translation,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
