import 'package:flutter/material.dart';

import '../../../core/data/dua_data.dart';
import '../../../core/models/dua.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/arabic_pattern.dart';
import '../../../core/widgets/glass_card.dart';

class DuaCategoryCard extends StatelessWidget {
  const DuaCategoryCard({super.key, required this.category});
  final DuaCategory category;

  Color _hex(String hex) {
    final String h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final Color start = _hex(category.gradientStartHex);
    final Color end = _hex(category.gradientEndHex);

    return Stack(
      children: <Widget>[
        GlassCard(
          padding: const EdgeInsets.all(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              start.withValues(alpha: 0.22),
              end.withValues(alpha: 0.06),
            ],
          ),
          borderColor: start.withValues(alpha: 0.30),
          glowColor: start,
          glowOpacity: 0.12,
          onTap: () => Navigator.pushNamed(
            context,
            '/duas/category',
            arguments: category.id,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      start.withValues(alpha: 0.5),
                      start.withValues(alpha: 0.0),
                    ],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: start.withValues(alpha: 0.5),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Icon(
                  DuaData.iconForCategory(category.icon),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                category.name,
                style: AppTypography.titleLarge.copyWith(
                  fontSize: 15,
                  height: 1.25,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                category.subtitle,
                style: AppTypography.caption.copyWith(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text(
                    '${DuaData.byCategory(category.id).length} duas',
                    style: AppTypography.caption.copyWith(color: start),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded,
                      size: 14, color: start.withValues(alpha: 0.8)),
                ],
              ),
            ],
          ),
        ),
        const Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: 70,
            height: 70,
            child: ArabicPatternOverlay(opacity: 0.04, scale: 0.5),
          ),
        ),
      ],
    );
  }
}
