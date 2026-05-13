import 'package:flutter/material.dart';

import '../l10n/translations.dart';
import '../state/settings_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'package:provider/provider.dart';

/// Tiny uppercase gold tracking label — the "eyebrow" sitting above section
/// titles ("AYAH OF THE DAY", "NEXT PRAYER", "PRAYER TIMES").
///
/// Skips the uppercase + wide tracking when the active language is RTL,
/// since Arabic doesn't follow the same convention.
class Eyebrow extends StatelessWidget {
  const Eyebrow(
    this.text, {
    super.key,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final SettingsState settings = context.watch<SettingsState>();
    final bool rtl = settings.isRtl;
    return Text(
      rtl ? text : text.toUpperCase(),
      style: AppTypography.eyebrow.copyWith(
        color: color ?? AppColors.gold,
        letterSpacing: rtl ? 0.5 : 1.98,
      ),
    );
  }
}

/// Shorter form: takes a translation key directly.
class EyebrowKey extends StatelessWidget {
  const EyebrowKey(this.translationKey, {super.key, this.color});
  final String translationKey;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Eyebrow(context.t(translationKey), color: color);
  }
}
