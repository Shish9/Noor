import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Premium gradient button with emerald or gold glow halo.
class GlowButton extends StatefulWidget {
  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.glowColor,
    this.height = 56,
    this.fullWidth = true,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final Color? glowColor;
  final double height;
  final bool fullWidth;
  final bool outlined;

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final Gradient grad = widget.gradient ?? AppColors.emeraldGradient;
    final Color glow = widget.glowColor ?? AppColors.emerald;
    final bool enabled = widget.onPressed != null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            gradient: widget.outlined ? null : grad,
            color: widget.outlined ? Colors.transparent : null,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: widget.outlined
                ? Border.all(color: glow.withValues(alpha: 0.5), width: 1)
                : null,
            boxShadow: enabled
                ? <BoxShadow>[
                    BoxShadow(
                      color: glow.withValues(alpha: _pressed ? 0.45 : 0.32),
                      blurRadius: _pressed ? 16 : 28,
                      spreadRadius: _pressed ? 0 : 2,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.icon != null) ...<Widget>[
                Icon(
                  widget.icon,
                  size: 18,
                  color: widget.outlined ? glow : AppColors.background,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: AppTypography.button.copyWith(
                  color: widget.outlined ? glow : AppColors.background,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
