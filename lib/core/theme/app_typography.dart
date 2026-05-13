import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Premium typography system.
///
/// Latin: Inter (clean, fintech-grade)
/// Display: Cormorant Garamond (luxurious serif moments)
/// Arabic: Amiri / Scheherazade New (calligraphy-inspired) — loaded via google_fonts
class AppTypography {
  AppTypography._();

  static TextStyle displayLarge = GoogleFonts.cormorantGaramond(
    fontSize: 44,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static TextStyle displayMedium = GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static TextStyle displaySmall = GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
    height: 1.2,
  );

  static TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
    height: 1.25,
  );

  static TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
    height: 1.3,
  );

  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.35,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
    height: 1.45,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 1.4,
    height: 1.2,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.4,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
  );

  // Arabic — loaded via Google Fonts (no bundled .ttf required).
  static TextStyle arabicLarge = GoogleFonts.amiri(
    fontSize: 32,
    height: 2.1,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle arabicMedium = GoogleFonts.amiri(
    fontSize: 24,
    height: 2.0,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle arabicSmall = GoogleFonts.amiri(
    fontSize: 20,
    height: 1.9,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle arabicCalligraphy = GoogleFonts.scheherazadeNew(
    fontSize: 28,
    height: 2.0,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  /// Convenience: build an Amiri TextStyle with custom params.
  /// Use this anywhere Arabic appears inline so the font is consistent.
  static TextStyle arabic({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
    double height = 1.95,
  }) {
    return GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}
