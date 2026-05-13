import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/data/tafsir_data.dart';
import '../../../core/models/tafsir.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// One ayah's display: Arabic on top, the user-selected translation under
/// it, and a "Read Tafsir" disclosure button that expands the long-form
/// commentary with bookmark/share/play actions.
class AyahTafsirCard extends StatefulWidget {
  const AyahTafsirCard({
    super.key,
    required this.entry,
    required this.language,
    required this.arabicFontSize,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onShare,
    required this.onPlayQuran,
    required this.onPlayTafsir,
    this.startExpanded = false,
  });

  final AyahTafsir entry;
  final TafsirLanguage language;
  final double arabicFontSize;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;
  final VoidCallback onPlayQuran;
  final VoidCallback onPlayTafsir;
  final bool startExpanded;

  @override
  State<AyahTafsirCard> createState() => _AyahTafsirCardState();
}

class _AyahTafsirCardState extends State<AyahTafsirCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _ctrl;
  late final Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _expanded = widget.startExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: _expanded ? 1 : 0,
    );
    _curve = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _ctrl.forward() : _ctrl.reverse();
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final AyahTafsir e = widget.entry;
    final TafsirLanguage lang = widget.language;
    final String? translation = e.translation(lang);
    final String? tafsirText = e.tafsir(lang);
    final bool hasTafsir = tafsirText != null && tafsirText.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        gradient: _expanded ? AppColors.emeraldCardGradient : AppColors.cardGradient,
        borderColor: _expanded
            ? AppColors.emerald.withValues(alpha: 0.4)
            : AppColors.glassBorder,
        glowColor: _expanded ? AppColors.emerald : null,
        glowOpacity: 0.10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Ayah marker row
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
                    '${e.ayahNumber}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.emeraldGlow,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${e.surahNumber}:${e.ayahNumber}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                const Spacer(),
                _IconAction(
                  icon: widget.isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: widget.isFavorite
                      ? AppColors.gold
                      : AppColors.textTertiary,
                  onTap: widget.onToggleFavorite,
                ),
                _IconAction(
                  icon: Icons.play_arrow_rounded,
                  color: AppColors.textTertiary,
                  onTap: widget.onPlayQuran,
                ),
                _IconAction(
                  icon: Icons.ios_share_rounded,
                  color: AppColors.textTertiary,
                  onTap: widget.onShare,
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Arabic text
            Text(
              e.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(
                fontSize: widget.arabicFontSize,
                color: AppColors.textPrimary,
                height: 2.0,
              ),
            ),
            const SizedBox(height: 18),
            // Translation (selected language)
            if (translation != null && translation.isNotEmpty)
              Text(
                translation,
                textDirection: lang.textDirection,
                textAlign:
                    lang.isRtl ? TextAlign.right : TextAlign.left,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.65,
                  fontStyle: lang == TafsirLanguage.english
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              )
            else
              Text(
                'Translation in ${lang.englishName} not yet available for this ayah.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 16),
            // Read Tafsir button
            _ReadTafsirButton(
              expanded: _expanded,
              hasContent: hasTafsir,
              onTap: hasTafsir ? _toggle : null,
            ),
            // Expanded tafsir content
            ClipRect(
              child: AnimatedBuilder(
                animation: _curve,
                builder: (BuildContext _, Widget? child) {
                  return Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _curve.value,
                    child: Opacity(opacity: _curve.value, child: child),
                  );
                },
                child: hasTafsir
                    ? _ExpandedTafsir(
                        tafsir: tafsirText,
                        author: TafsirData.author,
                        language: lang,
                        onPlayTafsir: widget.onPlayTafsir,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadTafsirButton extends StatelessWidget {
  const _ReadTafsirButton({
    required this.expanded,
    required this.hasContent,
    required this.onTap,
  });

  final bool expanded;
  final bool hasContent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: <Color>[
                    Color(0x2210B981),
                    Color(0x1010B981),
                  ],
                )
              : null,
          color: enabled ? null : AppColors.surfaceMuted.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled
                ? AppColors.emerald.withValues(alpha: 0.4)
                : AppColors.glassBorder,
            width: 0.6,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              hasContent
                  ? (expanded ? Icons.menu_book_rounded : Icons.menu_book_outlined)
                  : Icons.hourglass_empty_rounded,
              size: 16,
              color: enabled ? AppColors.emeraldGlow : AppColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Text(
              hasContent
                  ? (expanded ? 'Hide Tafsir' : 'Read Tafsir')
                  : 'Tafsir coming soon',
              style: AppTypography.bodySmall.copyWith(
                color: enabled ? AppColors.emeraldGlow : AppColors.textTertiary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            if (hasContent) ...<Widget>[
              const SizedBox(width: 6),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 240),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.emeraldGlow,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExpandedTafsir extends StatelessWidget {
  const _ExpandedTafsir({
    required this.tafsir,
    required this.author,
    required this.language,
    required this.onPlayTafsir,
  });

  final String tafsir;
  final String author;
  final TafsirLanguage language;
  final VoidCallback onPlayTafsir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.transparent,
                  AppColors.emerald.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Author chip
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.auto_stories_rounded,
                      size: 12,
                      color: AppColors.goldLight,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tafsir · $author',
                      style: AppTypography.label.copyWith(
                        color: AppColors.goldLight,
                        fontSize: 9.5,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onPlayTafsir,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.emerald.withValues(alpha: 0.4),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.headphones_rounded,
                        size: 12,
                        color: AppColors.emeraldGlow,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Listen',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.emeraldGlow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Tafsir body
          Text(
            tafsir,
            textDirection: language.textDirection,
            textAlign: language.isRtl ? TextAlign.right : TextAlign.left,
            style: language == TafsirLanguage.arabic
                ? AppTypography.arabic(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    height: 1.85,
                  )
                : AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.7,
                    fontSize: 15.5,
                  ),
          ),
          const SizedBox(height: 8),
        ],
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
