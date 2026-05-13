import 'package:flutter/material.dart';

/// Noor color system — **Midnight + Gold**.
///
/// Inspired by the Noor design package: matte midnight blue surfaces, warm
/// antique gold accents, restrained palette that reads like an illuminated
/// manuscript instead of a tech app.
class AppColors {
  AppColors._();

  // ── Midnight backgrounds ──────────────────────────────────────────────
  static const Color background    = Color(0xFF0B1220); // --bg
  static const Color backgroundSoft = Color(0xFF0F172A); // --bg-soft
  static const Color surface       = Color(0xFF131C2E); // --surface
  static const Color surfaceElevated = Color(0xFF1A253B); // --surface-2
  static const Color surfaceMuted  = Color(0xFF1A253B);

  // ── Antique gold (the soul of the design) ─────────────────────────────
  static const Color gold      = Color(0xFFC9A961); // --gold
  static const Color goldLight = Color(0xFFD6B876); // --gold-soft
  static const Color goldDeep  = Color(0xFF8D7235); // --gold-deep
  static const Color goldShimmer = Color(0xFFE5CC85);

  // ── Backwards-compat: emerald aliases now mapped to gold so legacy
  //    widgets still render in the new palette without code churn.
  static const Color emerald     = gold;
  static const Color emeraldGlow = goldLight;
  static const Color emeraldDeep = goldDeep;
  static const Color emeraldSoft = goldDeep;

  // ── Text ──────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF3EAD8); // --fg
  static const Color textSecondary = Color(0xFFD8CDB3); // --fg-soft
  static const Color textTertiary  = Color(0xFF8A8772); // --muted
  static const Color textMuted     = Color(0xFF6B6957);

  // ── Hairlines, overlays ───────────────────────────────────────────────
  static const Color line          = Color(0x24C9A961); // --line  (gold @ 14%)
  static const Color lineSoft      = Color(0x0FFFFFFF); // --line-soft
  static const Color divider       = line;
  static const Color overlay       = Color(0xCC050810);
  static const Color shimmerBase   = Color(0xFF1A253B);
  static const Color shimmerHighlight = Color(0xFF24314A);

  // ── Glassmorphism (kept for shared widgets) ───────────────────────────
  static const Color glassFill         = Color(0x14C9A961);
  static const Color glassFillStrong   = Color(0x1FC9A961);
  static const Color glassBorder       = line;

  // ── Tab bar ───────────────────────────────────────────────────────────
  static const Color tabBg   = Color(0xC70B1220); // --tab-bg
  static const Color tabLine = Color(0x2EC9A961); // --tab-line

  // ── Pattern fills (NoorStar tint) ─────────────────────────────────────
  static const Color patternFg     = Color(0x29C9A961); // --pattern-fg
  static const Color patternFgSoft = Color(0x12C9A961); // --pattern-fg-soft

  // ── Accent backgrounds (selected pills, chips) ────────────────────────
  static const Color accentBg = Color(0x1FC9A961);

  // ── Gradients ─────────────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFF0F172A),
      Color(0xFF0B1220),
      Color(0xFF080E1A),
    ],
    stops: <double>[0.0, 0.5, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF1A253B),
      Color(0xFF131C2E),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0xFF131C2E),
      Color(0xFF0F1729),
    ],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[gold, goldDeep],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[goldShimmer, gold, goldDeep],
  );

  static const LinearGradient emeraldCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0x33C9A961),
      Color(0x0AC9A961),
    ],
  );

  static const LinearGradient goldCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Color(0x33C9A961),
      Color(0x0A8D7235),
    ],
  );

  static const RadialGradient ambientGlow = RadialGradient(
    center: Alignment.topCenter,
    radius: 1.4,
    colors: <Color>[
      Color(0x1FC9A961),
      Color(0x000B1220),
    ],
  );

  // Signature card shadow — soft, far, low-opacity (book-like)
  static List<BoxShadow> get cardShadow => <BoxShadow>[
        const BoxShadow(
          color: Color(0x8C000000),
          blurRadius: 60,
          offset: Offset(0, 30),
          spreadRadius: -30,
        ),
      ];
}
