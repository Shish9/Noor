import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_Action> actions = <_Action>[
      _Action(
        label: context.t('tab.quran'),
        icon: Icons.menu_book_rounded,
        color: AppColors.emeraldGlow,
        onTap: () => context.read<AppState>().setTab(1),
      ),
      _Action(
        label: context.t('tab.duas'),
        icon: Icons.spa_rounded,
        color: AppColors.gold,
        onTap: () => context.read<AppState>().setTab(2),
      ),
      _Action(
        label: context.t('tab.audio'),
        icon: Icons.headphones_rounded,
        color: AppColors.emeraldGlow,
        onTap: () => context.read<AppState>().setTab(3),
      ),
      _Action(
        label: context.t('quick.dhikr'),
        icon: Icons.spa_rounded,
        color: AppColors.gold,
        onTap: () => Navigator.pushNamed(context, '/dhikr'),
      ),
      _Action(
        label: context.t('quick.tafsir'),
        icon: Icons.auto_stories_rounded,
        color: AppColors.emeraldGlow,
        onTap: () => Navigator.pushNamed(
          context,
          '/tafsir',
          arguments: <String, dynamic>{'surah': 1},
        ),
      ),
    ];

    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (BuildContext _, int i) => _ActionTile(action: actions[i]),
      ),
    );
  }
}

class _Action {
  _Action({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});
  final _Action action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        width: 84,
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: action.color.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    action.color.withValues(alpha: 0.32),
                    action.color.withValues(alpha: 0),
                  ],
                ),
              ),
              child: Icon(action.icon, color: action.color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
