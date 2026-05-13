import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Subtle geometric Islamic pattern overlay — 8-point star tessellation.
/// Used in story cards, headers, and onboarding for visual identity.
class ArabicPatternOverlay extends StatelessWidget {
  const ArabicPatternOverlay({
    super.key,
    this.color,
    this.opacity = 0.06,
    this.scale = 1.0,
  });

  final Color? color;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _PatternPainter(
          color: (color ?? AppColors.gold).withValues(alpha: opacity),
          scale: scale,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter({required this.color, required this.scale});

  final Color color;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final double cell = 56 * scale;
    final int cols = (size.width / cell).ceil() + 1;
    final int rows = (size.height / cell).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final Offset center = Offset(c * cell, r * cell);
        _drawStar(canvas, paint, center, cell * 0.32);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final Path path = Path();
    for (int i = 0; i < 8; i++) {
      final double a1 = (i * math.pi / 4) - math.pi / 2;
      final double a2 = a1 + math.pi / 8;
      final Offset p1 = center + Offset(math.cos(a1), math.sin(a1)) * radius;
      final Offset p2 = center + Offset(math.cos(a2), math.sin(a2)) * radius * 0.45;
      if (i == 0) {
        path.moveTo(p1.dx, p1.dy);
      } else {
        path.lineTo(p1.dx, p1.dy);
      }
      path.lineTo(p2.dx, p2.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PatternPainter old) =>
      old.color != color || old.scale != scale;
}
