import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/data/dhikr_data.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/dhikr.dart';
import '../../core/services/storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glass_card.dart';
import 'widgets/dhikr_card.dart';

class DhikrScreen extends StatefulWidget {
  const DhikrScreen({super.key});

  @override
  State<DhikrScreen> createState() => _DhikrScreenState();
}

class _DhikrScreenState extends State<DhikrScreen> {
  final ScrollController _scroll = ScrollController();
  String? _focusedDhikrId;

  void _increment(String id) {
    setState(() {
      _focusedDhikrId = id;
    });
    StorageService.instance.incrementDhikr(id);
    HapticFeedback.lightImpact();
  }

  void _reset(String id) {
    StorageService.instance.resetDhikr(id);
    HapticFeedback.heavyImpact();
    setState(() {});
  }

  void _resetAll() {
    showDialog<void>(
      context: context,
      builder: (BuildContext _) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(context.t('dhikr.resetTitle'),
              style: AppTypography.titleLarge),
          content: Text(
            context.t('dhikr.resetBody'),
            style: AppTypography.bodyMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t('action.cancel'),
                  style: AppTypography.button
                      .copyWith(color: AppColors.textTertiary)),
            ),
            TextButton(
              onPressed: () {
                StorageService.instance.resetAllDhikr();
                Navigator.pop(context);
                setState(() {});
              },
              child: Text(context.t('action.resetAll'),
                  style: AppTypography.button.copyWith(color: AppColors.gold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> counts = StorageService.instance.dhikrCounts;
    final int todayTotal = StorageService.instance.dhikrToday;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.t('dhikr.title'), style: AppTypography.titleLarge),
        backgroundColor: AppColors.background.withValues(alpha: 0.5),
        actions: <Widget>[
          IconButton(
            tooltip: context.t('action.resetAll'),
            onPressed: _resetAll,
            icon: const Icon(Icons.refresh_rounded),
            color: AppColors.textSecondary,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 14, intensity: 0.8),
          SafeArea(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 60),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                _Header(
                  todayTotal: todayTotal,
                  todayLabel: context.t('dhikr.todayCount'),
                  startHint: context.t('dhikr.startHint'),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.05, end: 0),
                const SizedBox(height: 18),
                ...List<Widget>.generate(DhikrData.all.length, (int i) {
                  final Dhikr d = DhikrData.all[i];
                  final int count = counts[d.id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: DhikrCard(
                      dhikr: d,
                      count: count,
                      focused: _focusedDhikrId == d.id,
                      onIncrement: () => _increment(d.id),
                      onReset: () => _reset(d.id),
                    ).animate().fadeIn(
                          duration: 380.ms,
                          delay: (60 * i).ms,
                        ).slideY(begin: 0.06, end: 0),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.todayTotal,
    required this.todayLabel,
    required this.startHint,
  });
  final int todayTotal;
  final String todayLabel;
  final String startHint;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(22),
      gradient: AppColors.emeraldCardGradient,
      borderColor: AppColors.emerald.withValues(alpha: 0.3),
      glowColor: AppColors.emerald,
      glowOpacity: 0.16,
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Color(0x3310B981),
                      Color(0x0010B981),
                    ],
                  ),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: <Color>[
                      AppColors.emeraldGlow,
                      AppColors.emeraldDeep,
                    ],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.emerald.withValues(alpha: 0.5),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.spa_rounded,
                  color: AppColors.background,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      '$todayTotal',
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.emeraldGlow,
                        fontFamily: 'Inter',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      todayLabel,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  todayTotal == 0
                      ? startHint
                      : context.t('common.keepRemembrance'),
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
