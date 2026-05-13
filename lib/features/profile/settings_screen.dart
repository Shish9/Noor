import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/reciter_data.dart';
import '../../core/l10n/app_language.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/reciter.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsState s = context.watch<SettingsState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.t('settings.title'), style: AppTypography.titleLarge),
      ),
      body: Stack(
        children: <Widget>[
          const AnimatedBackground(particleCount: 12, intensity: 0.7),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 60),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                _Section(title: context.t('settings.notifications')),
                _SettingsCard(
                  child: Column(
                    children: <Widget>[
                      _SwitchRow(
                        label: context.t('settings.hourlyReminders'),
                        subtitle: context.t('settings.hourlyRemindersHint'),
                        value: s.notificationsEnabled,
                        onChanged: s.setNotificationsEnabled,
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _IntervalRow(
                        value: s.notificationIntervalHours,
                        onChanged: s.setNotificationInterval,
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _SwitchRow(
                        label: context.t('settings.silentMode'),
                        subtitle: context.t('settings.silentHint'),
                        value: s.silentNotifications,
                        onChanged: s.setSilentNotifications,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _Section(title: context.t('settings.reading')),
                _SettingsCard(
                  child: Column(
                    children: <Widget>[
                      _SliderRow(
                        label: context.t('settings.fontSize'),
                        value: s.arabicFontSize,
                        min: 18,
                        max: 44,
                        onChanged: s.setArabicFontSize,
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _SwitchRow(
                        label: context.t('settings.showTransliteration'),
                        subtitle: context.t('settings.transliterationHint'),
                        value: s.showTransliteration,
                        onChanged: s.setShowTransliteration,
                      ),
                      const Divider(height: 1, color: AppColors.divider),
                      _StepperRow(
                        label: context.t('settings.dailyGoal'),
                        suffix: context.t('settings.ayahs'),
                        value: s.dailyReadingGoal,
                        min: 1,
                        max: 100,
                        step: 1,
                        onChanged: s.setDailyReadingGoal,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _Section(title: context.t('settings.audio')),
                _SettingsCard(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(context.t('settings.defaultReciter'),
                                style: AppTypography.titleMedium),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ReciterData.all.map((Reciter r) {
                                final bool selected = s.reciterId == r.id;
                                return GestureDetector(
                                  onTap: () => s.setReciter(r.id),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 9),
                                    decoration: BoxDecoration(
                                      gradient: selected
                                          ? AppColors.emeraldGradient
                                          : null,
                                      color:
                                          selected ? null : AppColors.surfaceMuted,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      r.name,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: selected
                                            ? AppColors.background
                                            : AppColors.textSecondary,
                                        fontWeight: selected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _Section(title: context.t('settings.language')),
                _SettingsCard(
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < AppLanguage.values.length; i++) ...<Widget>[
                        _LanguageRow(
                          language: AppLanguage.values[i],
                          selected: s.language == AppLanguage.values[i],
                          onTap: () async {
                            await s.setLanguage(AppLanguage.values[i]);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.t('settings.languageChanged'),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        if (i < AppLanguage.values.length - 1)
                          const Divider(height: 1, color: AppColors.divider),
                      ],
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

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.label.copyWith(color: AppColors.emeraldGlow),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: child,
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: AppTypography.bodyLarge),
                if (subtitle != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTypography.caption),
                ],
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _IntervalRow extends StatelessWidget {
  const _IntervalRow({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(context.t('settings.reminderInterval'),
              style: AppTypography.bodyLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: <int>[1, 2, 3, 4, 6, 12].map((int h) {
              final bool sel = value == h;
              return GestureDetector(
                onTap: () => onChanged(h),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? AppColors.emeraldGradient : null,
                    color: sel ? null : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '${context.t('settings.everyXh')} ${h}h',
                    style: AppTypography.bodySmall.copyWith(
                      color: sel ? AppColors.background : AppColors.textSecondary,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(label, style: AppTypography.bodyLarge)),
              Text('${value.toInt()}',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.emeraldGlow)),
            ],
          ),
          Slider(value: value, min: min, max: max, onChanged: onChanged),
          // Live preview
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.centerRight,
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(
                fontSize: value,
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.suffix,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String label;
  final String suffix;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: AppTypography.bodyLarge)),
          IconButton(
            onPressed: value > min ? () => onChanged(value - step) : null,
            icon: const Icon(Icons.remove_rounded),
            color: AppColors.emeraldGlow,
          ),
          Text('$value $suffix', style: AppTypography.bodyMedium),
          IconButton(
            onPressed: value < max ? () => onChanged(value + step) : null,
            icon: const Icon(Icons.add_rounded),
            color: AppColors.emeraldGlow,
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: <Widget>[
            // Native script badge
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected
                    ? const LinearGradient(
                        colors: <Color>[AppColors.emerald, AppColors.emeraldDeep],
                      )
                    : null,
                color: selected ? null : AppColors.surfaceMuted,
                boxShadow: selected
                    ? <BoxShadow>[
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.4),
                          blurRadius: 12,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                language == AppLanguage.english
                    ? 'A'
                    : (language.native.isNotEmpty
                        ? language.native.characters.first
                        : '·'),
                style: language.isRtl
                    ? AppTypography.arabic(
                        fontSize: 16,
                        color: selected
                            ? AppColors.background
                            : AppColors.gold,
                        height: 1.0,
                      )
                    : AppTypography.titleMedium.copyWith(
                        color: selected
                            ? AppColors.background
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    language.native,
                    style: language.isRtl
                        ? AppTypography.arabic(
                            fontSize: 18,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          )
                        : AppTypography.bodyLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    language.englishName,
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: selected ? AppColors.emeraldGlow : AppColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
