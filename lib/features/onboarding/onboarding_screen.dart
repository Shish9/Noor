import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/translations.dart';
import '../../core/services/notification_service.dart';
import '../../core/state/app_state.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/gold_divider.dart';
import '../../core/widgets/noor_star.dart';
import '../shell/app_shell.dart';

/// Onboarding flow — pixel-faithful port of the Noor design.
///
/// 4 steps in the rotation:
///   0  Welcome              big rotating star + نُور + tagline + divider
///   1  Name entry           autofocusing text field
///   2  Reading / read aloud feature highlight
///   3  Gentle reminders     feature highlight
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final TextEditingController _nameCtrl = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  int _index = 0;

  static const int _nameIndex = 1;
  static const int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    final SettingsState settings =
        Provider.of<SettingsState>(context, listen: false);
    _nameCtrl.text = settings.userName;
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameCtrl.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  void _next() async {
    if (_index == _nameIndex) {
      _nameFocus.unfocus();
      final String trimmed = _nameCtrl.text.trim();
      if (trimmed.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t('onboarding.nameRequired'))),
        );
        return;
      }
      await context.read<SettingsState>().setUserName(trimmed);
    }

    if (_index < _totalPages - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    await context.read<AppState>().completeOnboarding();
    await NotificationService.instance.requestPermissions();
    await context.read<SettingsState>().setNotificationsEnabled(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const AppShell(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }

  String _ctaLabel(BuildContext ctx) {
    if (_index == _totalPages - 1) return ctx.t('onboarding.enterApp');
    if (_index == 0) return ctx.t('onboarding.continue');
    return ctx.t('action.continue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          // Centered rotating background NoorStar (from the design — 360px, opacity 0.3)
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Center(
              child: const NoorStar(
                size: 360,
                stroke: 0.4,
                color: Color(0x4DC9A961), // gold @ 30%
              )
                  .animate(onPlay: (AnimationController c) => c.repeat())
                  .rotate(
                    duration: const Duration(seconds: 90),
                    curve: Curves.linear,
                  ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                // Step indicator pills (top center)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_totalPages, (int i) {
                      final bool reached = i <= _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: i == _index ? 22 : 6,
                        decoration: BoxDecoration(
                          color: reached ? AppColors.gold : AppColors.line,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
                // Page contents
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (int i) {
                      setState(() => _index = i);
                      if (i == _nameIndex) {
                        Future<void>.delayed(
                            const Duration(milliseconds: 320), () {
                          if (mounted) _nameFocus.requestFocus();
                        });
                      } else {
                        _nameFocus.unfocus();
                      }
                    },
                    children: <Widget>[
                      const _WelcomePage(),
                      _NamePage(
                        controller: _nameCtrl,
                        focusNode: _nameFocus,
                        onSubmitted: (_) => _next(),
                      ),
                      const _ReadingPage(),
                      const _RemindersPage(),
                    ],
                  ),
                ),
                // Bottom row: skip + gold pill button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Skip (also functions as "done" on last page)
                      GestureDetector(
                        onTap: _index >= _nameIndex
                            ? () async {
                                await context
                                    .read<AppState>()
                                    .completeOnboarding();
                                if (!context.mounted) return;
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const AppShell(),
                                  ),
                                );
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            context.t('onboarding.skip'),
                            style: AppTypography.bodySmall.copyWith(
                              color: _index >= _nameIndex
                                  ? AppColors.textTertiary
                                  : Colors.transparent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      _GoldPill(label: _ctaLabel(context), onTap: _next),
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

// ─── Step 0: Welcome ─────────────────────────────────────────────────────
class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    final bool ar = context.watch<SettingsState>().isRtl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // "نُور" in 44px gold Amiri
          Text(
            'نُور',
            textAlign: TextAlign.center,
            style: AppTypography.arabic(
              fontSize: 44,
              color: AppColors.gold,
              height: 1.4,
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 18),
          // "أهلًا بك في نُور" — phrase with italic gold "نُور" at the end
          if (ar)
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: 'أهلًا بك في '),
                  TextSpan(
                    text: 'نُور',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppTypography.arabic(
                fontSize: 40,
                color: AppColors.textPrimary,
                height: 1.15,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 100.ms)
          else
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  const TextSpan(text: 'Welcome to '),
                  TextSpan(
                    text: 'Noor',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: AppTypography.displayLarge.copyWith(
                fontSize: 40,
                height: 1.1,
                letterSpacing: -0.4,
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: 14),
          // Italic Cormorant subtitle
          Text(
            context.t('onboarding.welcomeSub'),
            textAlign: TextAlign.center,
            style: ar
                ? AppTypography.arabic(
                    fontSize: 17,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  )
                : AppTypography.verseEnglish.copyWith(fontSize: 17),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 28),
          // Gold ornamental divider
          const GoldDivider(width: 120)
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms),
        ],
      ),
    );
  }
}

// ─── Step 1: Name entry ──────────────────────────────────────────────────
class _NamePage extends StatelessWidget {
  const _NamePage({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 60),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.heroGradient,
              border: Border.all(color: AppColors.gold, width: 1),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.gold,
              size: 44,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 30),
          Text(
            context.t('onboarding.nameTitle'),
            textAlign: TextAlign.center,
            style: AppTypography.displaySmall,
          ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
          const SizedBox(height: 12),
          Text(
            context.t('onboarding.nameSubtitle'),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 180.ms),
          const SizedBox(height: 36),
          TextField(
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22,
            ),
            cursorColor: AppColors.gold,
            decoration: InputDecoration(
              hintText: context.t('onboarding.namePlaceholder'),
              hintStyle: AppTypography.headlineMedium.copyWith(
                color: AppColors.textTertiary,
                fontSize: 22,
                fontStyle: FontStyle.italic,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: AppColors.line, width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColors.gold, width: 1),
              ),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 240.ms).slideY(begin: 0.1),
          const SizedBox(height: 14),
          Text(
            context.t('onboarding.nameHint'),
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 320.ms),
        ],
      ),
    );
  }
}

// ─── Step 2: Reading ─────────────────────────────────────────────────────
class _ReadingPage extends StatelessWidget {
  const _ReadingPage();

  @override
  Widget build(BuildContext context) {
    return _FeatureLayout(
      arabic: 'اقرأ',
      titleKey: 'onboarding.readTitle',
      subtitleKey: 'onboarding.readSub',
      icon: Icons.menu_book_rounded,
    );
  }
}

// ─── Step 3: Reminders ───────────────────────────────────────────────────
class _RemindersPage extends StatelessWidget {
  const _RemindersPage();

  @override
  Widget build(BuildContext context) {
    return _FeatureLayout(
      arabic: 'اذكر',
      titleKey: 'onboarding.notifTitle',
      subtitleKey: 'onboarding.notifSub',
      icon: Icons.notifications_active_rounded,
    );
  }
}

class _FeatureLayout extends StatelessWidget {
  const _FeatureLayout({
    required this.arabic,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });
  final String arabic;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.gold, width: 1),
            ),
            child: Icon(icon, color: AppColors.gold, size: 46),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 36),
          Text(
            arabic,
            style: AppTypography.arabic(
              fontSize: 38,
              color: AppColors.gold,
              height: 1.0,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 120.ms),
          const SizedBox(height: 20),
          Text(
            context.t(titleKey),
            textAlign: TextAlign.center,
            style: AppTypography.displaySmall,
          ).animate().fadeIn(duration: 600.ms, delay: 220.ms),
          const SizedBox(height: 14),
          Text(
            context.t(subtitleKey),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 320.ms),
        ],
      ),
    );
  }
}

// ─── Gold pill CTA button (matches design's .btn-gold) ───────────────────
class _GoldPill extends StatelessWidget {
  const _GoldPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.gold,
          borderRadius: BorderRadius.circular(999),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTypography.button.copyWith(
            color: const Color(0xFF1A1208),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
