import 'dart:math' as math;
import 'package:flutter/material.dart';

class MosqueSilhouette extends StatelessWidget {
  const MosqueSilhouette({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: <Widget>[
          // Crescent moon high above
          Positioned(
            top: -180,
            left: 60,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: const Color(0xFFE8C56A).withValues(alpha: 0.7),
                  width: 1,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFFE8C56A).withValues(alpha: 0.4),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          // Stars
          ...List<Widget>.generate(12, (int i) {
            final math.Random r = math.Random(i * 3 + 7);
            return Positioned(
              top: -200 + r.nextDouble() * 160,
              left: 20 + r.nextDouble() * 320,
              child: Container(
                width: 2 + r.nextDouble() * 2,
                height: 2 + r.nextDouble() * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.4 + r.nextDouble() * 0.5),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            );
          }),
          // Mosque silhouette
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 200),
              painter: _MosquePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MosquePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF000000),
          Color(0xFF050607),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;

    // Ground
    path.moveTo(0, h);
    path.lineTo(0, h * 0.65);
    // Left minaret
    path.lineTo(w * 0.18, h * 0.65);
    path.lineTo(w * 0.18, h * 0.18);
    path.lineTo(w * 0.20, h * 0.10);
    path.lineTo(w * 0.22, h * 0.18);
    path.lineTo(w * 0.22, h * 0.65);
    // Building
    path.lineTo(w * 0.30, h * 0.65);
    path.lineTo(w * 0.30, h * 0.42);
    // Main dome arc
    final Rect mainDome = Rect.fromLTWH(cx - w * 0.18, h * 0.10, w * 0.36, w * 0.36);
    path.arcTo(mainDome, math.pi, math.pi, false);
    path.lineTo(w * 0.70, h * 0.65);
    // Right minaret
    path.lineTo(w * 0.78, h * 0.65);
    path.lineTo(w * 0.78, h * 0.18);
    path.lineTo(w * 0.80, h * 0.10);
    path.lineTo(w * 0.82, h * 0.18);
    path.lineTo(w * 0.82, h * 0.65);
    // Right edge
    path.lineTo(w, h * 0.65);
    path.lineTo(w, h);
    path.close();

    canvas.drawPath(path, p);

    // Crescent atop main dome
    final Paint gold = Paint()
      ..color = const Color(0xFFE8C56A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, h * 0.06), 4, gold);
    canvas.drawLine(Offset(cx, h * 0.10), Offset(cx, h * 0.04), gold);
  }

  @override
  bool shouldRepaint(covariant _MosquePainter old) => false;
}
