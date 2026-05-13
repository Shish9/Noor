import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Noor typography — **Cormorant Garamond + Manrope + Amiri Quran**.
///
/// Display & serif moments (greetings, surah names, ornamental headings):
///   Cormorant Garamond
/// Body & UI chrome (labels, buttons, captions, descriptions):
///   Manrope
/// Arabic Quran text (verses, dua bodies, brand letter):
///   Amiri Quran (with Amiri / Scheherazade New as fallbacks)
class AppTypography {
  AppTypography._();

  // ── Display (Cormorant Garamond serif) ────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.cormorantGaramond(
    fontSize: 44,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static TextStyle displayMedium = GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.1,
  );

  static TextStyle displaySmall = GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.2,
  );

  // ── Headlines (Cormorant for premium feel) ────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.cormorantGaramond(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.1,
  );

  static TextStyle headlineMedium = GoogleFonts.cormorantGaramond(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.2,
  );

  static TextStyle headlineSmall = GoogleFonts.cormorantGaramond(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
    height: 1.25,
  );

  // ── Titles (Manrope for compact strength) ─────────────────────────────
  static TextStyle titleLarge = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.35,
  );

  static TextStyle titleMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.4,
  );

  // ── Body (Manrope) ────────────────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0,
    height: 1.45,
  );

  // ── Eyebrow — the signature uppercase gold tracking style ─────────────
  static TextStyle eyebrow = GoogleFonts.manrope(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 1.98, // 0.18em at 11px
    height: 1.2,
  );

  // ── Labels & captions ─────────────────────────────────────────────────
  static TextStyle label = GoogleFonts.manrope(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.gold,
    letterSpacing: 1.98,
    height: 1.2,
  );

  static TextStyle button = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static TextStyle caption = GoogleFonts.manrope(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
    height: 1.3,
  );

  // ── Italic Cormorant for "verse translation" moments ──────────────────
  static TextStyle verseEnglish = GoogleFonts.cormorantGaramond(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    color: AppColors.textSecondary,
    letterSpacing: 0,
    height: 1.5,
  );

  // ── Arabic — Amiri Quran is the religious-text font of choice ─────────
  static TextStyle arabicLarge = GoogleFonts.amiriQuran(
    fontSize: 32,
    height: 2.1,
    color: AppColors.textPrimary,
  );

  static TextStyle arabicMedium = GoogleFonts.amiriQuran(
    fontSize: 24,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  static TextStyle arabicSmall = GoogleFonts.amiriQuran(
    fontSize: 20,
    height: 1.9,
    color: AppColors.textPrimary,
  );

  static TextStyle arabicCalligraphy = GoogleFonts.scheherazadeNew(
    fontSize: 28,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  /// Convenience: build an Amiri-Quran TextStyle inline.
  static TextStyle arabic({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.95,
  }) {
    return GoogleFonts.amiriQuran(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}
