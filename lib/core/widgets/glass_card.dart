import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Premium glassmorphism card with backdrop blur, subtle border,
/// and optional emerald or gold glow.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.blur = 18,
    this.gradient,
    this.borderColor,
    this.glowColor,
    this.glowOpacity = 0.18,
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

    final Widget content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.cardGradient,
            borderRadius: radius,
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 0.6,
            ),
          ),
          child: child,
        ),
      ),
    );

    final Widget wrapped = onTap == null
        ? content
        : Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              splashColor: AppColors.emerald.withValues(alpha: 0.06),
              highlightColor: AppColors.emerald.withValues(alpha: 0.03),
              child: content,
            ),
          );

    if (glowColor == null) return wrapped;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glowColor!.withValues(alpha: glowOpacity),
            blurRadius: 32,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: wrapped,
    );
  }
}
