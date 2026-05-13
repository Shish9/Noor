import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/translations.dart';
import '../../core/services/notification_service.dart';
import '../../core/state/app_state.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/noor_star.dart';
import '../shell/app_shell.dart';

/// Onboarding flow.
///
/// Page 0  Welcome — full-screen "نُور" hero + tagline + Begin button
/// Page 1  Name entry — TextField, persists to SettingsState
/// Pages 2-4 Feature highlights (Read · Find calm · Reminders)
/// Final tap requests notification permissions and routes to AppShell.
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

  static const int _welcomeIndex = 0;
  static const int _nameIndex = 1;
  static const int _totalPages = 5;

  static const List<_OnboardPage> _featurePages = <_OnboardPage>[
    _OnboardPage(
      arabic: 'اقرأ',
      titleKey: 'onboarding.readTitle',
      subtitleKey: 'onboarding.readSub',
      icon: Icons.menu_book_rounded,
    ),
    _OnboardPage(
      arabic: 'ادعُ',
      titleKey: 'onboarding.duaTitle',
      subtitleKey: 'onboarding.duaSub',
      icon: Icons.spa_rounded,
    ),
    _OnboardPage(
      arabic: 'اذكر',
      titleKey: 'onboarding.notifTitle',
      subtitleKey: 'onboarding.notifSub',
      icon: Icons.notifications_active_rounded,
    ),
  ];

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

  bool _canAdvance() {
    if (_index == _nameIndex) {
      // Require a name (at least 1 character) before advancing.
      return _nameCtrl.text.trim().isNotEmpty;
    }
    return true;
  }

  void _next() async {
    // Save name when leaving the name page
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

    // Last page — finalize.
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
    if (_index == _welcomeIndex) return ctx.t('onboarding.begin');
    if (_index == _nameIndex) return ctx.t('action.continue');
    if (_index == _totalPages - 1) return ctx.t('onboarding.enterApp');
    return ctx.t('action.continue');
  }

  IconData _ctaIcon() {
    if (_index == _welcomeIndex) return Icons.auto_awesome_rounded;
    if (_index == _totalPages - 1) return Icons.auto_awesome_rounded;
    return Icons.arrow_forward_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 14, intensity: 0.8),
          SafeArea(
            child: Column(
              children: <Widget>[
                _TopBar(
                  index: _index,
                  total: _totalPages,
                  onSkip: _index >= _nameIndex ? _next : null,
                ),
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
                        onSubmitted: (_) {
                          if (_canAdvance()) _next();
                        },
                      ),
                      ..._featurePages
                          .map((p) => _FeaturePageView(page: p))
                          .toList(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
                  child: GlowButton(
                    label: _ctaLabel(context),
                    icon: _ctaIcon(),
                    onPressed: _next,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Welcome page — large brand mark + tagline. No icon halo, just the
/// signature NoorStar sitting behind a big serif "Noor".
class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              const NoorStar(
                size: 240,
                stroke: 0.6,
                color: AppColors.patternFg,
              )
                  .animate(onPlay: (AnimationController c) => c.repeat())
                  .rotate(duration: 60.seconds, curve: Curves.linear),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: Center(
                  child: Text(
                    'ن',
                    style: AppTypography.arabic(
                      fontSize: 64,
                      color: AppColors.gold,
                      height: 1.0,
                    ),
                  ),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            'Noor',
            style: AppTypography.displayLarge.copyWith(fontSize: 56),
          ).animate().fadeIn(duration: 500.ms, delay: 120.ms),
          const SizedBox(height: 4),
          Text(
            'نُور',
            style: AppTypography.arabic(
              fontSize: 36,
              color: AppColors.gold,
              height: 1.0,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          const SizedBox(height: 20),
          Text(
            context.t('onboarding.welcomeTitle'),
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 280.ms).slideY(begin: 0.15),
          const SizedBox(height: 12),
          Text(
            context.t('onboarding.welcomeSub'),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 360.ms).slideY(begin: 0.15),
        ],
      ),
    );
  }
}

/// Name entry page — single TextField on a soft midnight surface.
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.index, required this.total, this.onSkip});
  final int index;
  final int total;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: List<Widget>.generate(total, (int i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                margin: const EdgeInsets.only(right: 6),
                height: 4,
                width: i == index ? 26 : 14,
                decoration: BoxDecoration(
                  color: i == index ? AppColors.gold : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
          if (onSkip != null && index < total - 1)
            TextButton(
              onPressed: onSkip,
              child: Text(
                context.t('onboarding.skip'),
                style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
              ),
            ),
        ],
      ),
    );
  }
}

class _OnboardPage {
  const _OnboardPage({
    required this.arabic,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
  });

  final String arabic;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
}

class _FeaturePageView extends StatelessWidget {
  const _FeaturePageView({required this.page});
  final _OnboardPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon + soft halo
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Color(0x40C9A961),
                      Color(0x00C9A961),
                    ],
                  ),
                ),
              )
                  .animate(onPlay: (AnimationController c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.92, 0.92),
                    end: const Offset(1.08, 1.08),
                    duration: 3200.ms,
                    curve: Curves.easeInOut,
                  ),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.gold, width: 1),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.gold,
                  size: 46,
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              Icon(page.icon, color: AppColors.gold, size: 46),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            page.arabic,
            style: AppTypography.arabic(
              fontSize: 38,
              color: AppColors.gold,
              height: 1.0,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 120.ms),
          const SizedBox(height: 20),
          Text(
            context.t(page.titleKey),
            textAlign: TextAlign.center,
            style: AppTypography.displaySmall,
          ).animate().fadeIn(duration: 600.ms, delay: 220.ms).slideY(begin: 0.15),
          const SizedBox(height: 14),
          Text(
            context.t(page.subtitleKey),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 320.ms).slideY(begin: 0.15),
        ],
      ),
    );
  }
}
