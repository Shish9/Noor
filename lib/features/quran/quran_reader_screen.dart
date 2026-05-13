import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/data/surah_data.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/surah.dart';
import '../../core/state/audio_state.dart';
import '../../core/state/quran_state.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/shimmer_box.dart';
import 'widgets/ayah_tile.dart';
import 'widgets/reader_app_bar.dart';

class QuranReaderScreen extends StatefulWidget {
  const QuranReaderScreen({
    super.key,
    required this.surahNumber,
    this.ayahNumber,
  });

  final int surahNumber;
  final int? ayahNumber;

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  late int _surahNumber;
  final ScrollController _scroll = ScrollController();
  bool _distractionFree = false;

  @override
  void initState() {
    super.initState();
    _surahNumber = widget.surahNumber;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranState>().getSurah(_surahNumber);
      if (widget.ayahNumber != null) {
        // Scroll to roughly the right ayah after content loads.
        Future<void>.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          final double offset = (widget.ayahNumber! - 1) * 180.0;
          _scroll.animateTo(
            offset.clamp(0, _scroll.position.maxScrollExtent),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
          );
        });
      }
    });
  }

  void _changeSurah(int delta) {
    final int next = (_surahNumber + delta).clamp(1, 114);
    if (next == _surahNumber) return;
    setState(() => _surahNumber = next);
    context.read<QuranState>().getSurah(next);
    HapticFeedback.lightImpact();
    _scroll.jumpTo(0);
  }

  void _saveProgress(int ayahNum) {
    context.read<QuranState>().setLastRead(_surahNumber, ayahNum);
  }

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final SettingsState settings = context.watch<SettingsState>();
    final AudioState audio = context.watch<AudioState>();

    final Surah surah = SurahData.byNumber(_surahNumber);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: ReaderAppBar(
        surah: surah,
        distractionFree: _distractionFree,
        onToggleDistraction: () {
          setState(() => _distractionFree = !_distractionFree);
        },
        onPlay: () => context.read<AudioState>().playSurah(_surahNumber),
        isPlaying: audio.isPlaying && audio.currentSurahNumber == _surahNumber,
      ),
      body: Stack(
        children: <Widget>[
          if (!_distractionFree)
            const AnimatedBackground(particleCount: 14, intensity: 0.7),
          SafeArea(
            child: FutureBuilder<List<Ayah>>(
              future: quran.getSurah(_surahNumber),
              builder: (BuildContext _, AsyncSnapshot<List<Ayah>> snap) {
                if (!snap.hasData) {
                  return _buildSkeleton();
                }
                final List<Ayah> ayahs = snap.data!;
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (ScrollEndNotification n) {
                    final int approxAyah = ((n.metrics.pixels / 180).floor() + 1)
                        .clamp(1, ayahs.length);
                    _saveProgress(approxAyah);
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 100, 16, 220),
                    physics: const BouncingScrollPhysics(),
                    itemCount: ayahs.length + 2,
                    itemBuilder: (BuildContext _, int i) {
                      if (i == 0) return _SurahHeader(surah: surah);
                      if (i == ayahs.length + 1) {
                        return _SurahNavigator(
                          current: _surahNumber,
                          onPrev: () => _changeSurah(-1),
                          onNext: () => _changeSurah(1),
                        );
                      }
                      final Ayah a = ayahs[i - 1];
                      final bool isCurrent =
                          audio.isCurrentAyah(_surahNumber, a.number);
                      return AyahTile(
                        ayah: a,
                        surah: surah,
                        fontSize: settings.arabicFontSize,
                        showTransliteration: settings.showTransliteration,
                        bookmarked: quran.isBookmarked(a.reference),
                        isCurrentlyPlaying: isCurrent && audio.isPlaying,
                        isCurrentAyahPaused: isCurrent && !audio.isPlaying,
                        onBookmark: () => context
                            .read<QuranState>()
                            .toggleBookmark(a.reference),
                        onShare: () => Navigator.pushNamed(
                          context,
                          '/share',
                          arguments: <String, dynamic>{
                            'arabic': a.arabic,
                            'translation': a.translation,
                            'reference':
                                '${surah.nameTransliteration} ${a.surahNumber}:${a.number}',
                          },
                        ),
                        // Smart toggle: if this ayah is loaded, pause/resume
                        // in place; otherwise start playing this ayah.
                        onPlay: () => context
                            .read<AudioState>()
                            .toggleAyah(_surahNumber, a.number),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 200),
      itemCount: 6,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            ShimmerBox(height: 38, width: double.infinity, borderRadius: 12),
            SizedBox(height: 8),
            ShimmerBox(height: 16, width: 240),
            SizedBox(height: 6),
            ShimmerBox(height: 16, width: 180),
          ],
        ),
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, top: 8),
      child: GlassCard(
        gradient: AppColors.goldCardGradient,
        borderColor: AppColors.gold.withValues(alpha: 0.3),
        glowColor: AppColors.gold,
        glowOpacity: 0.10,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          children: <Widget>[
            Text(
              surah.nameArabic,
              style: AppTypography.arabic(
                fontSize: 44,
                color: AppColors.gold,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(surah.nameTransliteration, style: AppTypography.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${surah.meaning} · ${surah.ayahCount} ${context.t('settings.ayahs')} · ${surah.revelationPlace}',
              style: AppTypography.caption,
            ),
            if (surah.number != 1 && surah.number != 9) ...<Widget>[
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.glassBorder, width: 0.5),
                ),
                child: Text(
                  'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                  style: AppTypography.arabic(
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SurahNavigator extends StatelessWidget {
  const _SurahNavigator({
    required this.current,
    required this.onPrev,
    required this.onNext,
  });

  final int current;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: <Widget>[
          if (current > 1)
            Expanded(
              child: GlassCard(
                onTap: onPrev,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.arrow_back_rounded,
                        color: AppColors.emeraldGlow, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(context.t('quran.previous'),
                              style: AppTypography.caption.copyWith(
                                  color: AppColors.textTertiary)),
                          Text(
                            SurahData.byNumber(current - 1).nameTransliteration,
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (current > 1 && current < 114) const SizedBox(width: 12),
          if (current < 114)
            Expanded(
              child: GlassCard(
                onTap: onNext,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                glowColor: AppColors.emerald,
                glowOpacity: 0.10,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(context.t('quran.next'),
                              style: AppTypography.caption.copyWith(
                                  color: AppColors.textTertiary)),
                          Text(
                            SurahData.byNumber(current + 1).nameTransliteration,
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.emeraldGlow, size: 18),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
