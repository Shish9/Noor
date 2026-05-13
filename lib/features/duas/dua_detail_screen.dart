import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/data/dua_data.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/dua.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/arabic_pattern.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glow_button.dart';

class DuaDetailScreen extends StatefulWidget {
  const DuaDetailScreen({
    super.key,
    required this.categoryId,
    required this.duaId,
  });

  final String categoryId;
  final String duaId;

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  bool _favorited = false;

  @override
  void initState() {
    super.initState();
    _favorited = StorageService.instance.isDuaBookmarked(widget.duaId);
  }

  @override
  Widget build(BuildContext context) {
    final Dua? dua = DuaData.byId(widget.duaId);
    if (dua == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Dua not found', style: AppTypography.bodyLarge),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.4),
        title: Text(
          DuaData.categoryById(dua.categoryId).name,
          style: AppTypography.titleMedium,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _favorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _favorited ? AppColors.gold : AppColors.textSecondary,
            ),
            onPressed: () async {
              await StorageService.instance.toggleDuaBookmark(dua.id);
              setState(() => _favorited = !_favorited);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 14, intensity: 0.9),
          const Positioned.fill(child: ArabicPatternOverlay(opacity: 0.04)),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 60),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Text(dua.title, style: AppTypography.headlineMedium),
                const SizedBox(height: 28),
                // Arabic
                GlassCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 28),
                  glowColor: AppColors.emerald,
                  glowOpacity: 0.10,
                  child: Column(
                    children: <Widget>[
                      Text(
                        dua.arabic,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: AppTypography.arabicLarge.copyWith(
                          fontSize: 28,
                          height: 2.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                // Transliteration
                _Block(
                  label: context.t('duas.transliteration'),
                  child: Text(
                    dua.transliteration,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.gold,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Translation
                _Block(
                  label: context.t('duas.translation'),
                  child: Text(
                    dua.translation,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
                if (dua.reference != null) ...<Widget>[
                  const SizedBox(height: 14),
                  _Block(
                    label: context.t('duas.reference'),
                    child: Text(
                      dua.reference!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                // Actions
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GlowButton(
                        label: context.t('duas.shareStory'),
                        icon: Icons.ios_share_rounded,
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/share',
                          arguments: <String, dynamic>{
                            'arabic': dua.arabic,
                            'translation': dua.translation,
                            'reference': dua.reference,
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GlowButton(
                      label: context.t('duas.copy'),
                      icon: Icons.copy_rounded,
                      gradient: const LinearGradient(
                        colors: <Color>[AppColors.gold, AppColors.goldDeep],
                      ),
                      glowColor: AppColors.gold,
                      fullWidth: false,
                      onPressed: () async {
                        final String text =
                            '${dua.arabic}\n\n${dua.translation}\n— ${dua.reference ?? "Authentic Sunnah"}';
                        await Clipboard.setData(ClipboardData(text: text));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.t('duas.copied'))),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    GlowButton(
                      label: context.t('duas.send'),
                      icon: Icons.send_rounded,
                      outlined: true,
                      glowColor: AppColors.emerald,
                      fullWidth: false,
                      onPressed: () => Share.share(
                        '${dua.arabic}\n\n${dua.transliteration}\n\n"${dua.translation}"\n— ${dua.reference ?? "Authentic Sunnah"}\n\nShared from Noor 🤍',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.label.copyWith(color: AppColors.emeraldGlow),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
