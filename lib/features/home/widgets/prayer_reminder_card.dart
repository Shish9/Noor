import 'package:flutter/material.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

/// Local-time approximate prayer schedule. For accurate computation,
/// integrate `adhan_dart` or geolocator + Aladhan API.
class PrayerReminderCard extends StatelessWidget {
  const PrayerReminderCard({super.key});

  static const List<_Prayer> _prayers = <_Prayer>[
    _Prayer('Fajr', '05:12', Icons.brightness_3_rounded),
    _Prayer('Sunrise', '06:38', Icons.wb_twilight_rounded),
    _Prayer('Dhuhr', '12:30', Icons.wb_sunny_rounded),
    _Prayer('Asr', '15:48', Icons.cloud_outlined),
    _Prayer('Maghrib', '18:22', Icons.brightness_6_rounded),
    _Prayer('Isha', '19:55', Icons.nightlight_round),
  ];

  int _currentIndex() {
    final TimeOfDay now = TimeOfDay.now();
    final int nowMinutes = now.hour * 60 + now.minute;
    int idx = 0;
    for (int i = 0; i < _prayers.length; i++) {
      final List<String> parts = _prayers[i].time.split(':');
      final int m = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (nowMinutes >= m) idx = i;
    }
    return idx;
  }

  String _next() {
    final int idx = _currentIndex();
    final _Prayer next = idx == _prayers.length - 1
        ? _prayers[0]
        : _prayers[idx + 1];
    return next.name;
  }

  String _timeRemaining() {
    final int idx = _currentIndex();
    final _Prayer next = idx == _prayers.length - 1
        ? _prayers[0]
        : _prayers[idx + 1];
    final List<String> parts = next.time.split(':');
    final TimeOfDay now = TimeOfDay.now();
    int diffMin = (int.parse(parts[0]) * 60 + int.parse(parts[1])) -
        (now.hour * 60 + now.minute);
    if (diffMin < 0) diffMin += 24 * 60;
    final int h = diffMin ~/ 60;
    final int m = diffMin % 60;
    if (h == 0) return 'in ${m}m';
    return 'in ${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final int currentIdx = _currentIndex();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      glowColor: AppColors.gold,
      glowOpacity: 0.08,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.mosque_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                context.t('section.prayerTimes'),
                style: AppTypography.label.copyWith(
                  color: AppColors.goldLight,
                  letterSpacing: 1.6,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              Text('${context.t('home.next')}: ${_next()} ${_timeRemaining()}',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.gold)),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: List<Widget>.generate(_prayers.length, (int i) {
              final _Prayer p = _prayers[i];
              final bool isCurrent = i == currentIdx;
              return Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isCurrent
                            ? const LinearGradient(
                                colors: <Color>[AppColors.emerald, AppColors.emeraldDeep],
                              )
                            : null,
                        color: isCurrent ? null : AppColors.surfaceMuted,
                        boxShadow: isCurrent
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.emerald.withValues(alpha: 0.5),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        p.icon,
                        size: 18,
                        color: isCurrent ? AppColors.background : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.name,
                      style: AppTypography.caption.copyWith(
                        color: isCurrent ? AppColors.emeraldGlow : AppColors.textTertiary,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    Text(
                      p.time,
                      style: AppTypography.bodySmall.copyWith(
                        color: isCurrent ? AppColors.textPrimary : AppColors.textTertiary,
                        fontSize: 11,
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Prayer {
  const _Prayer(this.name, this.time, this.icon);
  final String name;
  final String time;
  final IconData icon;
}
