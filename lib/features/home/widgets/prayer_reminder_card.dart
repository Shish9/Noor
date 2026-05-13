import 'package:flutter/material.dart';

import '../../../core/l10n/translations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/eyebrow.dart';
import '../../../core/widgets/noor_star.dart';

/// Next-prayer hero card — large Cormorant prayer name + Amiri Arabic next
/// to it, gold time and countdown, mini rail with all 6 prayers, and the
/// signature **NoorStar** geometric pattern bleeding off the corners.
class PrayerReminderCard extends StatelessWidget {
  const PrayerReminderCard({super.key});

  static const List<_Prayer> _prayers = <_Prayer>[
    _Prayer('Fajr', 'الفجر', '05:12'),
    _Prayer('Sunrise', 'الشروق', '06:38'),
    _Prayer('Dhuhr', 'الظهر', '12:30'),
    _Prayer('Asr', 'العصر', '15:48'),
    _Prayer('Maghrib', 'المغرب', '18:22'),
    _Prayer('Isha', 'العشاء', '19:55'),
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

  _Prayer _next() {
    final int idx = _currentIndex();
    return idx == _prayers.length - 1 ? _prayers[0] : _prayers[idx + 1];
  }

  String _timeRemaining() {
    final _Prayer next = _next();
    final List<String> parts = next.time.split(':');
    final TimeOfDay now = TimeOfDay.now();
    int diffMin = (int.parse(parts[0]) * 60 + int.parse(parts[1])) -
        (now.hour * 60 + now.minute);
    if (diffMin < 0) diffMin += 24 * 60;
    final int h = diffMin ~/ 60;
    final int m = diffMin % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m}m';
  }

  String _prayerNameKey(String englishName) {
    switch (englishName) {
      case 'Fajr':
        return 'prayer.fajr';
      case 'Sunrise':
        return 'prayer.sunrise';
      case 'Dhuhr':
        return 'prayer.dhuhr';
      case 'Asr':
        return 'prayer.asr';
      case 'Maghrib':
        return 'prayer.maghrib';
      case 'Isha':
        return 'prayer.isha';
    }
    return englishName;
  }

  @override
  Widget build(BuildContext context) {
    final int currentIdx = _currentIndex();
    final _Prayer next = _next();

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.line, width: 0.7),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const EyebrowKey('home.nextPrayer'),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              context.t(_prayerNameKey(next.english)),
                              style: AppTypography.displayMedium
                                  .copyWith(fontSize: 38),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              next.arabic,
                              style: AppTypography.arabic(
                                fontSize: 22,
                                color: AppColors.gold,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Text(
                              '${context.t('home.in')} ',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              _timeRemaining(),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      next.time,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.gold,
                        fontSize: 28,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Mini rail
              Row(
                children: List<Widget>.generate(_prayers.length, (int i) {
                  final _Prayer p = _prayers[i];
                  final bool isNext = p.english == next.english;
                  final bool passed = i < currentIdx;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: i == _prayers.length - 1 ? 0 : 6),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: isNext ? AppColors.accentBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isNext ? AppColors.line : Colors.transparent,
                          width: 0.7,
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            p.english.substring(0, 3).toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              color: passed
                                  ? AppColors.textTertiary
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.time,
                            style: AppTypography.caption.copyWith(
                              color: isNext
                                  ? AppColors.gold
                                  : AppColors.textSecondary,
                              fontSize: 12,
                              fontFeatures: const <FontFeature>[
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        // Decorative NoorStar bleeds — top-right and bottom-left
        const Positioned(
          right: -40,
          top: -40,
          child: IgnorePointer(
            child: NoorStar(
              size: 220,
              stroke: 0.5,
              color: AppColors.patternFg,
            ),
          ),
        ),
        const Positioned(
          left: -30,
          bottom: -30,
          child: IgnorePointer(
            child: NoorStar(
              size: 140,
              stroke: 0.4,
              color: AppColors.patternFgSoft,
            ),
          ),
        ),
      ],
    );
  }
}

class _Prayer {
  const _Prayer(this.english, this.arabic, this.time);
  final String english;
  final String arabic;
  final String time;
}
