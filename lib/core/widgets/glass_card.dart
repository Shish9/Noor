import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Noor-style "book" card.
///
/// The original app used heavy backdrop blur + emerald glow. The Midnight
/// design language uses **solid surface fills + thin gold hairline borders +
/// soft far shadow** to read like an illuminated manuscript page rather than
/// a glass dashboard.
///
/// API kept identical to the previous GlassCard so every caller still works.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 22,
    this.blur = 0, // ignored — kept for backwards compat
    this.gradient,
    this.borderColor,
    this.glowColor,
    this.glowOpacity = 0.0,
    this.height,
    this.width,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? glowColor;
  final double glowOpacity;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRadius);

    final Widget content = Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? AppColors.surface : null,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? AppColors.line,
          width: 0.7,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: AppColors.gold.withValues(alpha: 0.06),
        highlightColor: AppColors.gold.withValues(alpha: 0.03),
        child: content,
      ),
    );
  }
}
