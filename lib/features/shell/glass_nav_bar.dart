import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/l10n/translations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({super.key, required this.current, required this.onTap});

  final int current;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem('tab.home', Icons.home_rounded, Icons.home_outlined),
    _NavItem('tab.quran', Icons.menu_book_rounded, Icons.menu_book_outlined),
    _NavItem('tab.duas', Icons.spa_rounded, Icons.spa_outlined),
    _NavItem('tab.audio', Icons.graphic_eq_rounded, Icons.graphic_eq_rounded),
    _NavItem('tab.profile', Icons.person_rounded, Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              height: 68,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0x33101316),
                    Color(0x66050607),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.glassBorder, width: 0.6),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.emerald.withValues(alpha: 0.08),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(_items.length, (int i) {
                  final _NavItem item = _items[i];
                  final bool selected = current == i;
                  return _NavButton(
                    label: context.t(item.labelKey),
                    iconActive: item.iconActive,
                    iconInactive: item.iconInactive,
                    selected: selected,
                    onTap: () => onTap(i),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.labelKey, this.iconActive, this.iconInactive);
  final String labelKey;
  final IconData iconActive;
  final IconData iconInactive;
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.iconActive,
    required this.iconInactive,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData iconActive;
  final IconData iconInactive;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: selected ? 36 : 24,
                height: selected ? 36 : 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: selected
                      ? const RadialGradient(
                          colors: <Color>[
                            Color(0x4410B981),
                            Color(0x0010B981),
                          ],
                        )
                      : null,
                  boxShadow: selected
                      ? <BoxShadow>[
                          BoxShadow(
                            color: AppColors.emerald.withValues(alpha: 0.32),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  selected ? iconActive : iconInactive,
                  size: selected ? 22 : 21,
                  color: selected ? AppColors.emeraldGlow : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: AppTypography.caption.copyWith(
                  color: selected ? AppColors.emeraldGlow : AppColors.textTertiary,
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
