import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/data/dua_data.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/dua.dart';
import '../../core/theme/app_typography.dart';
import 'widgets/dua_category_card.dart';

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(context.t('duas.title'), style: AppTypography.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    context.t('duas.subtitle'),
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 200),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext _, int i) {
                  final DuaCategory cat = DuaData.categories[i];
                  // Light entrance only (no per-card scale) — keeps first open
                  // of the grid smooth.
                  return DuaCategoryCard(category: cat).animate().fadeIn(
                        duration: 220.ms,
                        delay: (i * 22).ms,
                      );
                },
                childCount: DuaData.categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
