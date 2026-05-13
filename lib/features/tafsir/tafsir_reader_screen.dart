import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/data/surah_data.dart';
import '../../core/data/tafsir_data.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/surah.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/arabic_pattern.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glow_button.dart';

/// Tafsir reader — currently in **Coming Soon** state.
///
/// The Tahsin Ibrahim Doski tafsir text is being prepared and will be
/// dropped into [TafsirData.entries] in a future update; this screen will
/// then automatically expand into the full reader without further changes.
class TafsirReaderScreen extends StatelessWidget {
  const TafsirReaderScreen({
    super.key,
    required this.surahNumber,
    this.ayahNumber,
  });

  final int surahNumber;
  final int? ayahNumber;

  @override
  Widget build(BuildContext context) {
    final Surah surah = SurahData.byNumber(surahNumber);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.t('tafsir.title'), style: AppTypography.titleLarge),
        backgroundColor: AppColors.background.withValues(alpha: 0.5),
      ),
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 14, intensity: 0.9),
          const Positioned.fill(child: ArabicPatternOverlay(opacity: 0.04)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 90, 24, 60),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _ComingSoonHero(surah: surah, ayahNumber: ayahNumber),
                    const SizedBox(height: 28),
                    _LanguagesPreview()
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 320.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 22),
                    _BackToReadingButton(label: context.t('action.backToReading'))
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 440.ms)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComingSoonHero extends StatelessWidget {
  const _ComingSoonHero({required this.surah, required this.ayahNumber});
  final Surah surah;
  final int? ayahNumber;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      gradient: AppColors.goldCardGradient,
      borderColor: AppColors.gold.withValues(alpha: 0.3),
      glowColor: AppColors.gold,
      glowOpacity: 0.16,
      child: Column(
        children: <Widget>[
          // Halo icon
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 160,
                height: 160,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Color(0x44D4AF37),
                      Color(0x00D4AF37),
                    ],
                  ),
                ),
              ).animate(onPlay: (AnimationController c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1.10, 1.10),
                    duration: 3200.ms,
                    curve: Curves.easeInOut,
                  ),
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface.withValues(alpha: 0.7),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.6),
                    width: 1,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.5),
                      blurRadius: 32,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.gold,
                  size: 38,
                ),
              ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.easeOutBack,
                  ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.4),
                width: 0.6,
              ),
            ),
            child: Text(
              context.t('tafsir.comingSoon'),
              style: AppTypography.label.copyWith(
                color: AppColors.goldLight,
                letterSpacing: 2.4,
                fontSize: 10,
              ),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 120.ms),
          const SizedBox(height: 16),
          Text(
            context.t('tafsir.title'),
            textAlign: TextAlign.center,
            style: AppTypography.displayMedium,
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.15),
          const SizedBox(height: 6),
          Text(
            ayahNumber != null
                ? 'For ${surah.nameTransliteration} · Ayah $ayahNumber'
                : 'For Surah ${surah.nameTransliteration}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 240.ms),
          const SizedBox(height: 18),
          Text(
            '${context.t('tafsir.preparing')}\n— ${TafsirData.author}',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 280.ms),
          const SizedBox(height: 18),
          Text(
            TafsirData.authorArabic,
            textAlign: TextAlign.center,
            style: AppTypography.arabic(
              fontSize: 22,
              color: AppColors.gold,
              height: 1.4,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 320.ms),
        ],
      ),
    );
  }
}

class _LanguagesPreview extends StatelessWidget {
  static const List<_LangChip> _chips = <_LangChip>[
    _LangChip('Arabic', 'العربية'),
    _LangChip('English', 'EN'),
    _LangChip('Kurdish (Sorani)', 'سۆرانی'),
    _LangChip('Kurdish (Badini)', 'بادینی'),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.translate_rounded,
                  size: 16, color: AppColors.emeraldGlow),
              const SizedBox(width: 8),
              Text(
                context.t('tafsir.plannedLanguages'),
                style: AppTypography.label.copyWith(
                  color: AppColors.emeraldGlow,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final _LangChip c in _chips)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(c.label,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(width: 8),
                      Text(c.native,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          )),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LangChip {
  const _LangChip(this.label, this.native);
  final String label;
  final String native;
}

class _BackToReadingButton extends StatelessWidget {
  const _BackToReadingButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlowButton(
      label: label,
      icon: Icons.menu_book_rounded,
      onPressed: () => Navigator.pop(context),
    );
  }
}
