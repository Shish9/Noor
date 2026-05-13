import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Ambient living background — soft emerald & gold particles drifting
/// behind a matte black gradient. Optimized to run at low cost.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    super.key,
    this.particleCount = 18,
    this.intensity = 1.0,
    this.includeGold = true,
  });

  final int particleCount;
  final double intensity;
  final bool includeGold;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final math.Random _rand = math.Random(7);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _particles = List<_Particle>.generate(widget.particleCount, (int i) {
      return _Particle(
        seed: _rand.nextDouble(),
        radius: 60 + _rand.nextDouble() * 140,
        speed: 0.05 + _rand.nextDouble() * 0.12,
        baseX: _rand.nextDouble(),
        baseY: _rand.nextDouble(),
        amplitude: 0.05 + _rand.nextDouble() * 0.18,
        gold: widget.includeGold && _rand.nextDouble() < 0.25,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: <Widget>[
            // Base matte black gradient
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
              child: SizedBox.expand(),
            ),
            // Ambient emerald glow at top
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.ambientGlow),
              child: SizedBox.expand(),
            ),
            // Drifting particles
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext _, Widget? __) {
                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    t: _controller.value,
                    intensity: widget.intensity,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.seed,
    required this.radius,
    required this.speed,
    required this.baseX,
    required this.baseY,
    required this.amplitude,
    required this.gold,
  });

  final double seed;
  final double radius;
  final double speed;
  final double baseX;
  final double baseY;
  final double amplitude;
  final bool gold;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.t,
    required this.intensity,
  });

  final List<_Particle> particles;
  final double t;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    for (final _Particle p in particles) {
      final double angle = (t + p.seed) * 2 * math.pi * p.speed * 4;
      final double x = (p.baseX + math.cos(angle) * p.amplitude) * size.width;
      final double y = (p.baseY + math.sin(angle * 0.8) * p.amplitude) * size.height;

      final Color base = p.gold ? AppColors.gold : AppColors.emerald;
      final double alphaPulse =
          0.05 + (math.sin((t + p.seed) * 2 * math.pi) + 1) * 0.04;

      final Paint paint = Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            base.withValues(alpha: alphaPulse * intensity),
            base.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: p.radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => true;
}
