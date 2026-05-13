import 'package:flutter/material.dart';

import '../../../core/data/dua_data.dart';
import '../../../core/models/dua.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/noor_star.dart';

/// Horizontal rail of three du'a tiles for "this moment" — each tile is a
/// solid card with a NoorStar tucked into the top corner.
class DailyDuaCard extends StatelessWidget {
  const DailyDuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Dua> selection = DuaData.all.take(3).toList();
    if (selection.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: selection.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext _, int i) {
          final Dua d = selection[i];
          final Color hue = i == 0
              ? AppColors.gold
              : i == 1
                  ? AppColors.goldLight
                  : AppColors.goldDeep;
          return _DuaTile(dua: d, accent: hue);
        },
      ),
    );
  }
}

class _DuaTile extends StatelessWidget {
  const _DuaTile({required this.dua, required this.accent});
  final Dua dua;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/duas/detail',
        arguments: <String, dynamic>{
          'categoryId': dua.categoryId,
          'duaId': dua.id,
        },
      ),
      child: Container(
        width: 168,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line, width: 0.7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Positioned(
              right: -16,
              top: -16,
              child: IgnorePointer(
                child: NoorStar(
                  size: 72,
                  stroke: 0.4,
                  color: accent.withValues(alpha: 0.55),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'VERSE',
                  style: AppTypography.eyebrow.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.4,
                    fontSize: 10,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Text(
                    dua.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
