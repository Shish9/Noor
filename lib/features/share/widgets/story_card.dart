import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/arabic_pattern.dart';
import '../themes/share_theme.dart';
import 'mosque_silhouette.dart';
import 'nature_overlay.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({
    super.key,
    required this.theme,
    required this.arabic,
    required this.translation,
    this.reference,
  });

  final ShareTheme theme;
  final String arabic;
  final String translation;
  final String? reference;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: theme.background),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Soft glow halo
          if (theme.useGlow)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.4,
                    colors: <Color>[
                      theme.accentColor.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          // Patterns / decorations
          if (theme.useArabicPattern)
            Positioned.fill(
              child: ArabicPatternOverlay(
                color: theme.accentColor,
                opacity: 0.08,
                scale: 1.4,
              ),
            ),
          if (theme.useMosqueSilhouette)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MosqueSilhouette(),
            ),
          if (theme.useNature) const Positioned.fill(child: NatureOverlay()),

          // Top brand mark
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: <Color>[
                          theme.accentColor,
                          theme.accentColor.withValues(alpha: 0.6),
                        ],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: theme.accentColor.withValues(alpha: 0.5),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'ن',
                        style: GoogleFonts.amiri(
                          fontSize: 22,
                          color: const Color(0xFF050607),
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NOOR',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 4.5,
                      color: theme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 100, 28, 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Decorative divider
                Container(
                  width: 50,
                  height: 1,
                  color: theme.accentColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 30),
                // Arabic
                Text(
                  arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: theme.style == ShareCardStyle.luxury ? 30 : 28,
                    height: 2.0,
                    color: theme.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                // Translation
                Text(
                  '"$translation"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textColor.withValues(alpha: 0.85),
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                    letterSpacing: 0.1,
                  ),
                ),
                if (reference != null) ...<Widget>[
                  const SizedBox(height: 24),
                  Container(
                    width: 30,
                    height: 1,
                    color: theme.accentColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    reference!,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.accentColor,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom watermark
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'noor.app',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.textColor.withValues(alpha: 0.4),
                  letterSpacing: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
