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
import '../../core/widgets/arabic_pattern.dart';
import '../../core/widgets/glow_button.dart';
import '../shell/app_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const List<_OnboardPage> _pages = <_OnboardPage>[
    _OnboardPage(
      arabic: 'نُور',
      titleKey: 'onboarding.welcomeTitle',
      subtitleKey: 'onboarding.welcomeSub',
      icon: Icons.auto_awesome_rounded,
      accent: AppColors.gold,
    ),
    _OnboardPage(
      arabic: 'اقرأ',
      titleKey: 'onboarding.readTitle',
      subtitleKey: 'onboarding.readSub',
      icon: Icons.menu_book_rounded,
      accent: AppColors.emeraldGlow,
    ),
    _OnboardPage(
      arabic: 'ادعُ',
      titleKey: 'onboarding.duaTitle',
      subtitleKey: 'onboarding.duaSub',
      icon: Icons.spa_rounded,
      accent: AppColors.emeraldGlow,
    ),
    _OnboardPage(
      arabic: 'اذكر',
      titleKey: 'onboarding.notifTitle',
      subtitleKey: 'onboarding.notifSub',
      icon: Icons.notifications_active_rounded,
      accent: AppColors.gold,
    ),
  ];

  void _next() async {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      await context.read<AppState>().completeOnboarding();
      // Request notification permission and schedule defaults
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 24, intensity: 1.2),
          const Positioned.fill(child: ArabicPatternOverlay(opacity: 0.04)),
          SafeArea(
            child: Column(
              children: <Widget>[
                _TopBar(
                  index: _index,
                  total: _pages.length,
                  onSkip: _next,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (int i) => setState(() => _index = i),
                    itemBuilder: (BuildContext _, int i) =>
                        _OnboardPageView(page: _pages[i]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
                  child: GlowButton(
                    label: _index == _pages.length - 1
                        ? context.t('onboarding.begin')
                        : context.t('action.continue'),
                    icon: _index == _pages.length - 1
                        ? Icons.auto_awesome_rounded
                        : Icons.arrow_forward_rounded,
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.index, required this.total, required this.onSkip});
  final int index;
  final int total;
  final VoidCallback onSkip;

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
                  color: i == index ? AppColors.emerald : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
          if (index < total - 1)
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
    required this.accent,
  });

  final String arabic;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color accent;
}

class _OnboardPageView extends StatelessWidget {
  const _OnboardPageView({required this.page});
  final _OnboardPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Icon halo
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      page.accent.withValues(alpha: 0.32),
                      page.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ).animate(onPlay: (AnimationController c) => c.repeat(reverse: true))
                  .scale(
                      begin: const Offset(0.92, 0.92),
                      end: const Offset(1.08, 1.08),
                      duration: 3200.ms,
                      curve: Curves.easeInOut),
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface.withValues(alpha: 0.7),
                  border: Border.all(color: page.accent.withValues(alpha: 0.5), width: 1),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: page.accent.withValues(alpha: 0.45),
                      blurRadius: 28,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(page.icon, color: page.accent, size: 46),
              ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            ],
          ),
          const SizedBox(height: 36),
          Text(
            page.arabic,
            style: AppTypography.arabicLarge.copyWith(
              color: page.accent,
              fontSize: 38,
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
