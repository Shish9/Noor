import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/l10n/format_helpers.dart';
import '../../core/l10n/translations.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/noor_star.dart';
import 'package:provider/provider.dart';

/// Lock-screen notification preview — pixel-faithful port of the design's
/// `NotificationPreview`. Opens as a full-screen overlay from Settings.
///
/// Composition:
///   - Midnight gradient background with a huge faint NoorStar
///   - Top: date and big serif time
///   - 3 glassmorphic notification cards (hero · verse · streak)
///   - Bottom: "Close preview" pill
class LockscreenPreviewScreen extends StatelessWidget {
  const LockscreenPreviewScreen({super.key});

  String _time() {
    final DateTime now = DateTime.now();
    final String h = now.hour.toString().padLeft(2, '0');
    final String m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _date(BuildContext context) =>
      Fmt.headerDate(context, DateTime.now()).replaceAll('·', '،');

  @override
  Widget build(BuildContext context) {
    final bool ar = context.watch<SettingsState>().isRtl;
    return Scaffold(
      backgroundColor: const Color(0xFF060912),
      body: Stack(
        children: <Widget>[
          // Midnight gradient
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: <double>[0, 0.6, 1],
                  colors: <Color>[
                    Color(0xFF060912),
                    Color(0xFF131930),
                    Color(0xFF1A1F3D),
                  ],
                ),
              ),
            ),
          ),
          // Huge faint NoorStar covering the whole canvas
          const Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: NoorStar(
                  size: 1600,
                  stroke: 0.3,
                  color: Color(0x26C9A961), // gold @ 15%
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                // Date
                Text(
                  _date(context),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                // Big serif time
                Text(
                  Fmt.n(context, _time()),
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -3.2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 40),
                // Notification cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: <Widget>[
                      _NotifCard(
                        variant: _Variant.hero,
                        arabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                        body: context.t('notif.asrBody'),
                        time: context.t('notif.now'),
                        ar: ar,
                      ),
                      const SizedBox(height: 8),
                      _NotifCard(
                        variant: _Variant.verse,
                        arabic: 'لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
                        english:
                            'Allah does not burden a soul beyond that it can bear.',
                        refLabel: context.t('notif.verseRef'),
                        time:
                            '${context.t('notif.agoPrefix')} 7 ${context.t('notif.ago.min')}',
                        ar: ar,
                      ),
                      const SizedBox(height: 8),
                      _NotifCard(
                        variant: _Variant.streak,
                        body: context.t('notif.streakBody'),
                        time:
                            '${context.t('notif.agoPrefix')} 2 ${context.t('notif.ago.hour')}',
                        ar: ar,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Close pill
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            context.t('notif.close'),
                            style: AppTypography.button.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _Variant { hero, verse, streak }

class _NotifCard extends StatelessWidget {
  const _NotifCard({
    required this.variant,
    this.arabic,
    this.english,
    this.body,
    this.refLabel,
    required this.time,
    required this.ar,
  });

  final _Variant variant;
  final String? arabic;
  final String? english;
  final String? body;
  final String? refLabel;
  final String time;
  final bool ar;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          decoration: BoxDecoration(
            color: const Color(0x8C14121C),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.18),
              width: 0.6,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Top row: star · "Noor" name · time
              Row(
                children: <Widget>[
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: const NoorStar(
                      size: 16,
                      stroke: 0.6,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.t('notif.app'),
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      letterSpacing: 0.88,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    time,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Body
              if (variant == _Variant.hero) ...<Widget>[
                Text(
                  arabic ?? '',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTypography.arabic(
                    fontSize: 18,
                    color: const Color(0xFFE8C170),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body ?? '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: null,
                  ),
                ),
              ],
              if (variant == _Variant.verse) ...<Widget>[
                Text(
                  arabic ?? '',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: AppTypography.arabic(
                    fontSize: 16,
                    color: const Color(0xFFE8C170),
                    height: 1.8,
                  ),
                ),
                if (!ar && english != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    '"$english"',
                    style: AppTypography.verseEnglish.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  refLabel ?? '',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.gold.withValues(alpha: 0.7),
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (variant == _Variant.streak)
                Text(
                  body ?? '',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
