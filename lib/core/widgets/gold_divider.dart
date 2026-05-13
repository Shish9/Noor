import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ornamental gold divider — two thin gold rules flanking a small lozenge +
/// concentric circles motif. Used between Arabic verse and English
/// translation on hero cards (Ayah of the Day, Quran reader).
class GoldDivider extends StatelessWidget {
  const GoldDivider({
    super.key,
    this.width = 200,
    this.color = AppColors.gold,
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 18,
      child: CustomPaint(painter: _GoldDividerPainter(color: color)),
    );
  }
}

class _GoldDividerPainter extends CustomPainter {
  _GoldDividerPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double cy = size.height / 2;
    final double cx = size.width / 2;

    final Paint thin = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final Paint thinner = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.4;
    final Paint mid = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    // Two flanking lines, leaving a 40px gap in the middle for the motif
    canvas.drawLine(Offset(6, cy), Offset(cx - 20, cy), thin);
    canvas.drawLine(Offset(cx + 20, cy), Offset(size.width - 6, cy), thin);

    // Center motif
    canvas.drawCircle(Offset(cx, cy), 3, mid);
    canvas.drawCircle(Offset(cx, cy), 6, thinner);

    // Vertical lozenge
    final Path vert = Path()
      ..moveTo(cx, cy - 8)
      ..lineTo(cx + 1, cy)
      ..lineTo(cx, cy + 8)
      ..lineTo(cx - 1, cy)
      ..close();
    canvas.drawPath(vert, thinner);

    // Horizontal lozenge
    final Path horiz = Path()
      ..moveTo(cx - 8, cy)
      ..lineTo(cx, cy - 1)
      ..lineTo(cx + 8, cy)
      ..lineTo(cx, cy + 1)
      ..close();
    canvas.drawPath(horiz, thinner);
  }

  @override
  bool shouldRepaint(covariant _GoldDividerPainter old) => old.color != color;
}
