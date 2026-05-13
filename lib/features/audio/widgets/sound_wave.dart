import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Animated audio wave visualization — five vertical bars pulsing.
class SoundWave extends StatefulWidget {
  const SoundWave({super.key, this.color, this.small = false, this.bars = 5});

  final Color? color;
  final bool small;
  final int bars;

  @override
  State<SoundWave> createState() => _SoundWaveState();
}

class _SoundWaveState extends State<SoundWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (BuildContext _, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List<Widget>.generate(widget.bars, (int i) {
            final double phase = (_ctrl.value + i * 0.18) * 2 * math.pi;
            final double v = 0.3 + (math.sin(phase) + 1) / 2 * 0.7;
            final double h = (widget.small ? 18 : 36) * v;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.small ? 1.2 : 2,
              ),
              child: Container(
                width: widget.small ? 2.4 : 4,
                height: h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      (widget.color ?? AppColors.emeraldGlow),
                      (widget.color ?? AppColors.emerald).withValues(alpha: 0.6),
                    ],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: (widget.color ?? AppColors.emerald)
                          .withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
