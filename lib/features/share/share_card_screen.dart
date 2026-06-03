import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glow_button.dart';
import 'themes/share_theme.dart';
import 'widgets/story_card.dart';

class ShareCardScreen extends StatefulWidget {
  const ShareCardScreen({
    super.key,
    required this.arabic,
    required this.translation,
    this.reference,
  });

  final String arabic;
  final String translation;
  final String? reference;

  @override
  State<ShareCardScreen> createState() => _ShareCardScreenState();
}

class _ShareCardScreenState extends State<ShareCardScreen> {
  final ScreenshotController _shotCtrl = ScreenshotController();
  ShareTheme _theme = ShareTheme.themes.first;
  bool _saving = false;

  Future<Uint8List?> _capture() async {
    return _shotCtrl.capture(pixelRatio: 3.0);
  }

  Future<void> _saveToGallery() async {
    setState(() => _saving = true);
    try {
      final Uint8List? bytes = await _capture();
      if (bytes == null) return;
      final dynamic result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 95,
        name: 'quranapp_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (!mounted) return;
      final bool ok = result is Map && (result['isSuccess'] as bool? ?? false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Saved to gallery 🤍' : 'Save failed')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _share() async {
    setState(() => _saving = true);
    try {
      final Uint8List? bytes = await _capture();
      if (bytes == null) return;
      await Share.shareXFiles(
        <XFile>[
          XFile.fromData(
            bytes,
            name: 'quranapp_share.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Shared from Noor 🤍',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Share', style: AppTypography.titleLarge),
        backgroundColor: AppColors.background.withValues(alpha: 0.5),
      ),
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 12, intensity: 0.7),
          SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 90),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Screenshot(
                            controller: _shotCtrl,
                            child: StoryCard(
                              theme: _theme,
                              arabic: widget.arabic,
                              translation: widget.translation,
                              reference: widget.reference,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Theme picker
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: ShareTheme.themes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (BuildContext _, int i) {
                      final ShareTheme th = ShareTheme.themes[i];
                      final bool selected = th.id == _theme.id;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _theme = th);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 56,
                          decoration: BoxDecoration(
                            gradient: th.previewGradient,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? AppColors.emeraldGlow
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: selected
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: AppColors.emerald
                                          .withValues(alpha: 0.5),
                                      blurRadius: 14,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              th.label,
                              textAlign: TextAlign.center,
                              style: AppTypography.caption.copyWith(
                                color: th.textColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GlowButton(
                          label: _saving ? 'Saving...' : 'Save',
                          icon: Icons.download_rounded,
                          gradient: const LinearGradient(
                            colors: <Color>[AppColors.gold, AppColors.goldDeep],
                          ),
                          glowColor: AppColors.gold,
                          onPressed: _saving ? null : _saveToGallery,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GlowButton(
                          label: _saving ? 'Sharing...' : 'Share',
                          icon: Icons.ios_share_rounded,
                          onPressed: _saving ? null : _share,
                        ),
                      ),
                    ],
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
