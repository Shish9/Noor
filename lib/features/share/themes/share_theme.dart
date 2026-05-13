import 'package:flutter/material.dart';

class ShareTheme {
  const ShareTheme({
    required this.id,
    required this.label,
    required this.background,
    required this.previewGradient,
    required this.textColor,
    required this.accentColor,
    required this.style,
    this.useArabicPattern = false,
    this.useMosqueSilhouette = false,
    this.useNature = false,
    this.useGlow = false,
  });

  final String id;
  final String label;
  final Gradient background;
  final Gradient previewGradient;
  final Color textColor;
  final Color accentColor;
  final ShareCardStyle style;
  final bool useArabicPattern;
  final bool useMosqueSilhouette;
  final bool useNature;
  final bool useGlow;

  static const List<ShareTheme> themes = <ShareTheme>[
    ShareTheme(
      id: 'minimal_black',
      label: 'Minimal\nBlack',
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF050607), Color(0xFF000000)],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF050607), Color(0xFF000000)],
      ),
      textColor: Color(0xFFF5F5F4),
      accentColor: Color(0xFFD4AF37),
      style: ShareCardStyle.minimal,
    ),
    ShareTheme(
      id: 'emerald_luxury',
      label: 'Emerald\nLuxury',
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFF064E3B),
          Color(0xFF0B0D10),
          Color(0xFF030404),
        ],
        stops: <double>[0.0, 0.55, 1.0],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFF10B981), Color(0xFF064E3B)],
      ),
      textColor: Color(0xFFF5F5F4),
      accentColor: Color(0xFFD4AF37),
      style: ShareCardStyle.luxury,
      useArabicPattern: true,
      useGlow: true,
    ),
    ShareTheme(
      id: 'gold_aesthetic',
      label: 'Gold\nAesthetic',
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFF1A1208),
          Color(0xFF050607),
          Color(0xFF0F0A04),
        ],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Color(0xFFD4AF37), Color(0xFF9A7B1B)],
      ),
      textColor: Color(0xFFF4D88A),
      accentColor: Color(0xFFD4AF37),
      style: ShareCardStyle.luxury,
      useArabicPattern: true,
      useGlow: true,
    ),
    ShareTheme(
      id: 'nature',
      label: 'Nature\nCalm',
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF0F1B1A),
          Color(0xFF071412),
          Color(0xFF030606),
        ],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF1F4F47), Color(0xFF0F1B1A)],
      ),
      textColor: Color(0xFFE8F0EE),
      accentColor: Color(0xFFD4AF37),
      style: ShareCardStyle.minimal,
      useNature: true,
    ),
    ShareTheme(
      id: 'mosque',
      label: 'Mosque\nSilhouette',
      background: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color(0xFF1A1A2E),
          Color(0xFF0E1B2C),
          Color(0xFF050607),
        ],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF1A1A2E), Color(0xFF050607)],
      ),
      textColor: Color(0xFFF5F5F4),
      accentColor: Color(0xFFE8C56A),
      style: ShareCardStyle.luxury,
      useMosqueSilhouette: true,
      useGlow: true,
    ),
    ShareTheme(
      id: 'soft_glow',
      label: 'Soft\nGlow',
      background: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFF101820),
          Color(0xFF050607),
        ],
      ),
      previewGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFF34D399), Color(0xFF101820)],
      ),
      textColor: Color(0xFFF5F5F4),
      accentColor: Color(0xFF34D399),
      style: ShareCardStyle.minimal,
      useGlow: true,
    ),
  ];
}

enum ShareCardStyle { minimal, luxury }
