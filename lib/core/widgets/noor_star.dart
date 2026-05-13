import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Signature **eight-point star** motif used across Noor — a square + a
/// 45°-rotated square overlapped, with three concentric circles inside.
///
/// Echoes the Islamic geometric tradition without being ornate. Used as
/// background pattern on hero cards, dua tiles, the brand mark, etc.
class NoorStar extends StatelessWidget {
  const NoorStar({
    super.key,
    this.size = 120,
    this.stroke = 0.6,
    this.color = AppColors.patternFg,
  });

  final double size;
  final double stroke;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _NoorStarPainter(stroke: stroke, color: color),
      ),
    );
  }
}

class _NoorStarPainter extends CustomPainter {
  _NoorStarPainter({required this.stroke, required this.color});
  final double stroke;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    final Offset c = Offset(size.width / 2, size.height / 2);
    final double r = size.width / 2;
    final double half = r * 0.7;

    // Square 1
    canvas.drawRect(
      Rect.fromCenter(center: c, width: half * 2, height: half * 2),
      paint,
    );

    // Square 2 — rotated 45°
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.pi / 4);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: half * 2, height: half * 2),
      paint,
    );
    canvas.restore();

    // Three concentric circles
    canvas.drawCircle(c, r * 0.78, paint);
    canvas.drawCircle(c, r * 0.50, paint);
    canvas.drawCircle(c, r * 0.22, paint);
  }

  @override
  bool shouldRepaint(covariant _NoorStarPainter old) =>
      old.stroke != stroke || old.color != color;
}
