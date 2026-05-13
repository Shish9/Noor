import 'package:flutter/material.dart';

/// QuranApp luxury color system.
///
/// Matte black base · emerald green glow · refined gold accents.
class AppColors {
  AppColors._();

  // Backgrounds — pure matte black with subtle warm undertone for depth
  static const Color background = Color(0xFF050607);
  static const Color surface = Color(0xFF0B0D10);
  static const Color surfaceElevated = Color(0xFF101316);
  static const Color surfaceMuted = Color(0xFF1A1D21);

  // Emerald — primary brand glow
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldDeep = Color(0xFF047857);
  static const Color emeraldGlow = Color(0xFF34D399);
  static const Color emeraldSoft = Color(0xFF064E3B);

  // Gold — accent details, divine highlights
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE8C56A);
  static const Color goldDeep = Color(0xFF9A7B1B);
  static const Color goldShimmer = Color(0xFFF4D88A);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F4);
  static const Color textSecondary = Color(0xFFB6B7B9);
  static const Color textTertiary = Color(0xFF6B6E73);
  static const Color textMuted = Color(0xFF494C50);

  // Functional
  static const Color divider = Color(0x1AFFFFFF);
  static const Color overlay = Color(0x99000000);
  static const Color shimmerBase = Color(0xFF1A1D21);
  static const Color shimmerHighlight = Color(0xFF2A2D31);

  // Glassmorphism
  static const Color glassFill = Color(0x14FFFFFF);
  static const Color glassBorder = Color(0x26FFFFFF);
  static const Color glassFillStrong = Color(0x1FFFFFFF);

  // Gradients
  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[emerald, emeraldDeep],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[goldShimmer, gold, goldDeep],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF0A0E10),
      Color(0xFF050607),
      Color(0xFF030404),
    ],
    stops: <double>[0.0, 0.5, 1.0],
  );

  static const RadialGradient ambientGlow = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.4,
    colors: <Color>[
      Color(0x1F10B981),
      Color(0x00050607),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0x1AFFFFFF),
      Color(0x05FFFFFF),
    ],
  );

  static const LinearGradient emeraldCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0x3310B981),
      Color(0x0A047857),
    ],
  );

  static const LinearGradient goldCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0x33D4AF37),
      Color(0x0A9A7B1B),
    ],
  );
}
