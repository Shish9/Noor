import 'package:flutter/material.dart';

import '../../../core/models/surah.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class AyahTile extends StatelessWidget {
  const AyahTile({
    super.key,
    required this.ayah,
    required this.surah,
    required this.fontSize,
    required this.showTransliteration,
    required this.bookmarked,
    required this.onBookmark,
    required this.onShare,
    required this.onPlay,
    required this.isCurrentlyPlaying,
    required this.isCurrentAyahPaused,
    this.highlighted = false,
  });

  final Ayah ayah;
  final Surah surah;
  final double fontSize;
  final bool showTransliteration;
  final bool bookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  /// Called when the user taps the play/pause icon on THIS ayah. The
  /// caller (reader) decides whether it's a fresh play or a toggle of
  /// the already-loaded ayah.
  final VoidCallback onPlay;
  /// True iff this exact ayah is loaded AND currently playing audio.
  final bool isCurrentlyPlaying;
  /// True iff this exact ayah is loaded but paused (so the button shows
  /// "play" and a tap resumes from the saved position).
  final bool isCurrentAyahPaused;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        gradient: highlighted ? AppColors.emeraldCardGradient : AppColors.cardGradient,
        borderColor: highlighted
            ? AppColors.emerald.withValues(alpha: 0.4)
            : AppColors.glassBorder,
        glowColor: highlighted ? AppColors.emerald : null,
        glowOpacity: 0.10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Ayah number marker
            Row(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.emerald.withValues(alpha: 0.14),
                    border: Border.all(
                      color: AppColors.emerald.withValues(alpha: 0.4),
                      width: 0.6,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${ayah.number}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.emeraldGlow,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                _IconAction(
                  icon: bookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: bookmarked ? AppColors.gold : AppColors.textTertiary,
                  onTap: onBookmark,
                ),
                const SizedBox(width: 4),
                _IconAction(
                  icon: isCurrentlyPlaying
                      ? Icons.pause_circle_filled_rounded
                      : (isCurrentAyahPaused
                          ? Icons.play_circle_fill_rounded
                          : Icons.play_arrow_rounded),
                  color: (isCurrentlyPlaying || isCurrentAyahPaused)
                      ? AppColors.gold
                      : AppColors.textTertiary,
                  onTap: onPlay,
                ),
                const SizedBox(width: 4),
                _IconAction(
                  icon: Icons.ios_share_rounded,
                  color: AppColors.textTertiary,
                  onTap: onShare,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Arabic
            Text(
              ayah.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(
                fontSize: fontSize,
                color: AppColors.textPrimary,
                height: 2.0,
              ),
            ),
            if (showTransliteration && ayah.transliteration.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                ayah.transliteration,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.gold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              ayah.translation,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.color, required this.onTap});
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
