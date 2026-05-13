import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Subtle horizontal action rail under the home content — small icon discs
/// (Quran / Duas / Audio / Dhikr / Tafsir) with monochrome gold accents.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_Action> actions = <_Action>[
      _Action(
        labelKey: 'tab.quran',
        icon: Icons.menu_book_rounded,
        onTap: () => context.read<AppState>().setTab(1),
      ),
      _Action(
        labelKey: 'tab.duas',
        icon: Icons.spa_rounded,
        onTap: () => context.read<AppState>().setTab(2),
      ),
      _Action(
        labelKey: 'tab.audio',
        icon: Icons.headphones_rounded,
        onTap: () => context.read<AppState>().setTab(3),
      ),
      _Action(
        labelKey: 'quick.dhikr',
        icon: Icons.spa_outlined,
        onTap: () => Navigator.pushNamed(context, '/dhikr'),
      ),
      _Action(
        labelKey: 'quick.tafsir',
        icon: Icons.auto_stories_rounded,
        onTap: () => Navigator.pushNamed(
          context,
          '/tafsir',
          arguments: <String, dynamic>{'surah': 1},
        ),
      ),
    ];

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext _, int i) => _ActionTile(a: actions[i]),
      ),
    );
  }
}

class _Action {
  _Action({required this.labelKey, required this.icon, required this.onTap});
  final String labelKey;
  final IconData icon;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.a});
  final _Action a;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: a.onTap,
      child: Container(
        width: 84,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line, width: 0.7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(a.icon, color: AppColors.gold, size: 22),
            const SizedBox(height: 6),
            Text(
              context.t(a.labelKey),
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
