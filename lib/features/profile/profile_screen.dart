import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/translations.dart';
import '../../core/services/storage_service.dart';
import '../../core/state/quran_state.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/arabic_pattern.dart';
import '../../core/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final SettingsState settings = context.watch<SettingsState>();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 200),
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          // Hero card
          Stack(
            children: <Widget>[
              GlassCard(
                padding: const EdgeInsets.all(28),
                gradient: AppColors.emeraldCardGradient,
                borderColor: AppColors.emerald.withValues(alpha: 0.3),
                glowColor: AppColors.emerald,
                glowOpacity: 0.16,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: <Color>[AppColors.gold, AppColors.goldDeep],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.5),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'ن',
                          style: AppTypography.arabic(
                            fontSize: 44,
                            color: AppColors.background,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(context.t('profile.assalam'),
                        style: AppTypography.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      context.t('profile.journey'),
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: ArabicPatternOverlay(opacity: 0.05, scale: 0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Stats row
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  label: context.t('profile.dayStreakLabel'),
                  value: '${quran.currentStreak}',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.emeraldGlow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: context.t('profile.bookmarksStat'),
                  value: '${quran.bookmarks.length}',
                  icon: Icons.bookmark_rounded,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  label: context.t('profile.longestStreak'),
                  value: '${quran.longestStreak} ${context.t('home.daysWord')}',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.goldLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: context.t('profile.savedDuas'),
                  value: '${StorageService.instance.bookmarkedDuas.length}',
                  icon: Icons.favorite_rounded,
                  color: AppColors.emeraldGlow,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          // Settings sections
          Text(context.t('profile.preferences'), style: AppTypography.titleLarge),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.notifications_active_rounded,
            label: context.t('settings.notifications'),
            trailing: Text(
              settings.notificationsEnabled
                  ? '${settings.notificationIntervalHours}h interval'
                  : 'Off',
              style: AppTypography.caption.copyWith(color: AppColors.emeraldGlow),
            ),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          _SettingsTile(
            icon: Icons.format_size_rounded,
            label: 'Arabic Font Size',
            trailing: Text('${settings.arabicFontSize.toInt()}',
                style: AppTypography.caption.copyWith(color: AppColors.emeraldGlow)),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          _SettingsTile(
            icon: Icons.flag_rounded,
            label: 'Daily Reading Goal',
            trailing: Text('${settings.dailyReadingGoal} ayahs',
                style: AppTypography.caption.copyWith(color: AppColors.emeraldGlow)),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
          _SettingsTile(
            icon: Icons.translate_rounded,
            label: context.t('settings.language'),
            trailing: Text(
              settings.language.native,
              style: AppTypography.caption.copyWith(color: AppColors.emeraldGlow),
            ),
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),

          const SizedBox(height: 22),
          Text(context.t('profile.spiritual'), style: AppTypography.titleLarge),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.bookmark_rounded,
            label: context.t('profile.bookmarks'),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.favorite_rounded,
            label: context.t('profile.favoriteDuas'),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.history_rounded,
            label: context.t('profile.history'),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.auto_stories_rounded,
            label: context.t('profile.tafsirSoon'),
            trailing: Text('Soon',
                style: AppTypography.caption.copyWith(color: AppColors.gold)),
            onTap: () => Navigator.pushNamed(
              context,
              '/tafsir',
              arguments: const <String, dynamic>{'surah': 1},
            ),
          ),
          _SettingsTile(
            icon: Icons.spa_rounded,
            label: context.t('profile.dhikrCounter'),
            onTap: () => Navigator.pushNamed(context, '/dhikr'),
          ),

          const SizedBox(height: 22),
          Text(context.t('profile.about'), style: AppTypography.titleLarge),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: context.t('profile.aboutApp'),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.share_rounded,
            label: context.t('profile.shareApp'),
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.star_rounded,
            label: context.t('profile.rateApp'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      glowColor: color,
      glowOpacity: 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  color.withValues(alpha: 0.32),
                  color.withValues(alpha: 0),
                ],
              ),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderRadius: 16,
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.emeraldGlow, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: AppTypography.bodyLarge)),
            if (trailing != null) ...<Widget>[
              trailing!,
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
