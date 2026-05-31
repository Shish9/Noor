import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/l10n/translations.dart';
import '../../core/theme/app_colors.dart';

/// Pill-shaped tab bar with backdrop blur, hairline gold border, and a small
/// gold dot under the active tab — matches the Noor design package.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({super.key, required this.current, required this.onTap});

  final int current;
  final ValueChanged<int> onTap;

  static const List<_NavItem> _items = <_NavItem>[
    _NavItem('tab.home', Icons.home_outlined, Icons.home_rounded),
    _NavItem('tab.quran', Icons.menu_book_outlined, Icons.menu_book_rounded),
    _NavItem('tab.duas', Icons.spa_outlined, Icons.spa_rounded),
    _NavItem('tab.prayer', Icons.explore_outlined, Icons.explore_rounded),
    _NavItem('tab.profile', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0x000B1220),
              Color(0x9E0B1220),
              Color(0xFF0B1220),
            ],
            stops: <double>[0.0, 0.45, 1.0],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.tabBg,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.tabLine, width: 0.6),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(_items.length, (int i) {
                  final _NavItem item = _items[i];
                  return _NavButton(
                    label: context.t(item.labelKey),
                    iconActive: item.iconActive,
                    iconInactive: item.iconInactive,
                    selected: current == i,
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
  const _NavItem(this.labelKey, this.iconInactive, this.iconActive);
  final String labelKey;
  final IconData iconInactive;
  final IconData iconActive;
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    selected ? iconActive : iconInactive,
                    size: 22,
                    color: selected ? AppColors.gold : AppColors.textTertiary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: selected ? AppColors.gold : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              if (selected)
                Positioned(
                  bottom: -2,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
