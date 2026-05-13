import 'dart:math' as math;
import 'package:flutter/material.dart';

class NatureOverlay extends StatelessWidget {
  const NatureOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _NaturePainter(), size: Size.infinite);
  }
}

class _NaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Subtle leaf-shaped soft lights
    final math.Random r = math.Random(42);
    for (int i = 0; i < 14; i++) {
      final double x = r.nextDouble() * size.width;
      final double y = r.nextDouble() * size.height;
      final double radius = 30 + r.nextDouble() * 60;
      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFF34D399).withValues(alpha: 0.06 + r.nextDouble() * 0.05),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius));
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Bottom soft ground glow
    final Paint ground = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Colors.transparent,
          const Color(0xFF1F4F47).withValues(alpha: 0.4),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      ground,
    );
  }

  @override
  bool shouldRepaint(covariant _NaturePainter old) => false;
}
