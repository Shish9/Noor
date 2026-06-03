import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/format_helpers.dart';
import '../../core/l10n/translations.dart';
import '../../core/services/prayer_times_service.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/noor_star.dart';

/// Prayer screen — pixel-faithful port of the design's `prayer.jsx`.
///
/// Two tabs: Times (sun-arc + 6-prayer list) and Qibla (animated rotating
/// compass with Kaaba marker).
class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  bool _qibla = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const EyebrowKey('prayer.eyebrow'),
                const SizedBox(height: 4),
                Text(
                  context.t('prayer.title'),
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          // Tab switcher
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.line, width: 0.7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: <Widget>[
                  _TabPill(
                    label: context.t('prayer.tabTimes'),
                    selected: !_qibla,
                    onTap: () => setState(() => _qibla = false),
                  ),
                  _TabPill(
                    label: context.t('prayer.tabQibla'),
                    selected: _qibla,
                    onTap: () => setState(() => _qibla = true),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 140),
              physics: const BouncingScrollPhysics(),
              child: _qibla ? const _QiblaCompass() : const _PrayerTimes(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.accentBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.button.copyWith(
              color: selected ? AppColors.gold : AppColors.textTertiary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Times tab ───────────────────────────────────────────────────────────
class _PrayerTimes extends StatefulWidget {
  const _PrayerTimes();

  @override
  State<_PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<_PrayerTimes> {
  DailyPrayerTimes? _times;
  bool _loading = true;
  // Static fallback (Mecca local) when adhan_dart is unavailable on web.
  static const List<_Prayer> _fallback = <_Prayer>[
    _Prayer('Fajr', 'الفجر', '05:12', 'prayer.fajr', false, false, false),
    _Prayer('Sunrise', 'الشروق', '06:38', 'prayer.sunrise', false, false, true),
    _Prayer('Dhuhr', 'الظهر', '12:30', 'prayer.dhuhr', false, false, false),
    _Prayer('Asr', 'العصر', '15:48', 'prayer.asr', false, true, false),
    _Prayer('Maghrib', 'المغرب', '18:22', 'prayer.maghrib', false, false, false),
    _Prayer('Isha', 'العشاء', '19:55', 'prayer.isha', false, false, false),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (kIsWeb) {
      setState(() => _loading = false);
      return; // geolocator is mobile-only
    }
    setState(() => _loading = true);
    try {
      final DailyPrayerTimes t =
          await PrayerTimesService.instance.getToday(forceLocate: true);
      if (mounted) setState(() => _times = t);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<_Prayer> _liveList() {
    if (_times == null) return _fallback;
    final DailyPrayerTimes t = _times!;
    final String? current = t.currentPrayerName();
    return <_Prayer>[
      _Prayer('Fajr', 'الفجر', t.timeFor('Fajr'), 'prayer.fajr',
          t.isPast('Fajr') && current != 'Fajr', current == 'Fajr', false),
      _Prayer('Sunrise', 'الشروق', t.timeFor('Sunrise'), 'prayer.sunrise',
          t.isPast('Sunrise'), false, true),
      _Prayer('Dhuhr', 'الظهر', t.timeFor('Dhuhr'), 'prayer.dhuhr',
          t.isPast('Dhuhr') && current != 'Dhuhr', current == 'Dhuhr', false),
      _Prayer('Asr', 'العصر', t.timeFor('Asr'), 'prayer.asr',
          t.isPast('Asr') && current != 'Asr', current == 'Asr', false),
      _Prayer('Maghrib', 'المغرب', t.timeFor('Maghrib'), 'prayer.maghrib',
          t.isPast('Maghrib') && current != 'Maghrib', current == 'Maghrib',
          false),
      _Prayer('Isha', 'العشاء', t.timeFor('Isha'), 'prayer.isha',
          t.isPast('Isha') && current != 'Isha', current == 'Isha', false),
    ];
  }

  String _locationLabel(BuildContext context) =>
      _times?.locationLabel.isNotEmpty == true
          ? _times!.locationLabel
          : context.t('prayer.location');

  @override
  Widget build(BuildContext context) {
    final List<_Prayer> prayers = _liveList();
    final bool notLocated = !kIsWeb && (_times == null || !_times!.located);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Location row
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (_loading)
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.6,
                                color: AppColors.gold,
                              ),
                            )
                          else
                            const Icon(Icons.location_on_rounded,
                                size: 13, color: AppColors.gold),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _loading
                                  ? context.t('prayer.locating')
                                  : _locationLabel(context),
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        context.t('prayer.method'),
                        style: AppTypography.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Text(
                  Fmt.headerDate(context, DateTime.now()),
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          // "Enable location" banner when we fell back to default coords
          if (notLocated && !_loading)
            GestureDetector(
              onTap: _load,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accentBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line, width: 0.7),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.my_location_rounded,
                        size: 18, color: AppColors.gold),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.t('prayer.enableLocation'),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      context.t('prayer.enableCta'),
                      style: AppTypography.button.copyWith(
                        color: AppColors.gold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Sun arc card
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.line, width: 0.7),
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                EyebrowKey('prayer.arc'),
                const SizedBox(height: 4),
                AspectRatio(
                  aspectRatio: 280 / 112,
                  child: CustomPaint(
                    painter: _SunArcPainter(
                      // sun at ~16:21 in the design — recompute live
                      progressFn: () {
                        final DateTime now = DateTime.now();
                        const double fajr = 4 + 42 / 60;
                        const double maghrib = 18 + 57 / 60;
                        final double t = now.hour + now.minute / 60.0;
                        return ((t - fajr) / (maghrib - fajr)).clamp(0.0, 1.0);
                      },
                      labels: <_ArcMark>[
                        _ArcMark(0, context.t('prayer.markFajr'), false),
                        _ArcMark(
                            ((12 + 34 / 60) - 4 - 42 / 60) /
                                ((18 + 57 / 60) - 4 - 42 / 60),
                            context.t('prayer.markDhuhr'),
                            false),
                        _ArcMark(-1, context.t('prayer.markNow'), true),
                        _ArcMark(1, context.t('prayer.markMaghrib'), false),
                      ],
                      isRtl: context.watch<SettingsState>().isRtl,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Prayer list card
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.line, width: 0.7),
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: List<Widget>.generate(prayers.length, (int i) {
                final _Prayer p = prayers[i];
                final bool isLast = i == prayers.length - 1;
                return _PrayerRow(prayer: p, isLast: isLast);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Prayer {
  const _Prayer(
    this.english,
    this.arabic,
    this.time,
    this.nameKey,
    this.passed,
    this.current,
    this.small,
  );
  final String english;
  final String arabic;
  final String time;
  final String nameKey;
  final bool passed;
  final bool current;
  final bool small;
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({required this.prayer, required this.isLast});
  final _Prayer prayer;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: prayer.small ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: prayer.current ? AppColors.accentBg : Colors.transparent,
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: AppColors.lineSoft, width: 0.5),
        ),
      ),
      child: Opacity(
        opacity: prayer.passed && !prayer.current ? 0.5 : 1.0,
        child: Row(
          children: <Widget>[
            // Arabic name (the only one — Amiri Quran)
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    prayer.arabic,
                    style: AppTypography.arabic(
                      fontSize: prayer.small ? 18 : 22,
                      color: prayer.current
                          ? AppColors.gold
                          : (prayer.small
                              ? AppColors.textTertiary
                              : AppColors.textPrimary),
                      height: 1.0,
                    ),
                  ),
                  if (prayer.current) ...<Widget>[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gold, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        context.t('prayer.nowPill'),
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          letterSpacing: 1.4,
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Time + bell
            Text(
              Fmt.n(context, prayer.time),
              style: AppTypography.displaySmall.copyWith(
                color: prayer.current
                    ? AppColors.gold
                    : AppColors.textSecondary,
                fontSize: prayer.small ? 14 : 18,
                fontFeatures: const <FontFeature>[
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Opacity(
              opacity: prayer.small ? 0 : 1,
              child: Icon(
                Icons.notifications_none_rounded,
                size: 16,
                color: !prayer.passed && !prayer.small
                    ? AppColors.gold
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcMark {
  const _ArcMark(this.t, this.label, this.current);
  /// 0..1 along the arc, or -1 for "use the live progress".
  final double t;
  final String label;
  final bool current;
}

class _SunArcPainter extends CustomPainter {
  _SunArcPainter({
    required this.progressFn,
    required this.labels,
    required this.isRtl,
  });

  final double Function() progressFn;
  final List<_ArcMark> labels;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    final double progress = progressFn();
    final double w = size.width;
    final double h = size.height - 24;
    final double cx = w / 2;
    final double cy = h - 8;
    final double r = h - 18;

    // Horizon line
    final Paint horizon = Paint()
      ..color = AppColors.line
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, cy), Offset(w, cy), horizon);

    // Dashed full arc
    final Paint dashed = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final Path arcPath = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          math.pi, math.pi);
    _drawDashedPath(canvas, arcPath, dashed, dash: 3, gap: 3);

    // Solid arc up to current sun position
    final double sunAngle = math.pi * (1 - progress);
    final Paint solid = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final Path solidArc = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          math.pi, math.pi - sunAngle);
    canvas.drawPath(solidArc, solid);

    // Marker dots + labels
    for (final _ArcMark m in labels) {
      final double t = m.current ? progress : m.t.clamp(0.0, 1.0);
      final double a = math.pi * (1 - t);
      final double x = cx + r * math.cos(a);
      final double y = cy - r * math.sin(a);
      final Paint dotPaint = Paint()
        ..color = m.current ? AppColors.gold : AppColors.gold.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), m.current ? 6 : 2.5, dotPaint);
      if (m.current) {
        canvas.drawCircle(
          Offset(x, y),
          11,
          Paint()
            ..color = AppColors.gold.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke,
        );
      }
      // Label
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: isRtl ? m.label : m.label.toUpperCase(),
          style: TextStyle(
            color: m.current ? AppColors.gold : AppColors.textTertiary,
            fontSize: 9,
            fontWeight: m.current ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: isRtl ? 0 : 0.6,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, cy + 8));
    }
  }

  void _drawDashedPath(Canvas canvas, Path source, Paint paint,
      {required double dash, required double gap}) {
    for (final PathMetric pm in source.computeMetrics()) {
      double distance = 0;
      while (distance < pm.length) {
        final double next = math.min(distance + dash, pm.length);
        canvas.drawPath(pm.extractPath(distance, next), paint);
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SunArcPainter old) => true;
}

// ─── Qibla tab ───────────────────────────────────────────────────────────
class _QiblaCompass extends StatefulWidget {
  const _QiblaCompass();

  @override
  State<_QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<_QiblaCompass>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  double _bearing = 45;
  final math.Random _rand = math.Random(7);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _ctrl.addListener(() {
      // Subtle wobble simulating compass drift
      setState(() {
        _bearing += (_rand.nextDouble() - 0.5) * 0.4;
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  static const double _qiblaAngle = 58.3;

  @override
  Widget build(BuildContext context) {
    final bool ar = context.watch<SettingsState>().isRtl;
    final int off = (_qiblaAngle - _bearing < 0
        ? _qiblaAngle - _bearing + 360
        : _qiblaAngle - _bearing).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: <Widget>[
          // Compass card
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.line, width: 0.7),
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppColors.cardShadow,
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              children: <Widget>[
                // Background NoorStar
                const Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: NoorStar(
                        size: 300,
                        stroke: 0.4,
                        color: AppColors.patternFgSoft,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    EyebrowKey('qibla.direction'),
                    const SizedBox(height: 6),
                    Text(
                      '${Fmt.n(context, _qiblaAngle.round())}° ${ar ? "ش.ش" : "NE"}',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.gold,
                        fontSize: 28,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          // Rotating dial
                          Transform.rotate(
                            angle: -_bearing * math.pi / 180,
                            child: SizedBox(
                              width: 260,
                              height: 260,
                              child: CustomPaint(
                                painter: _CompassDialPainter(
                                  qiblaAngle: _qiblaAngle,
                                  isRtl: ar,
                                ),
                              ),
                            ),
                          ),
                          // Stationary needle pointing North
                          SizedBox(
                            width: 260,
                            height: 260,
                            child: CustomPaint(
                              painter: _NeedlePainter(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${context.t('qibla.alignTurn')} ${Fmt.n(context, off)}°',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _MetricCard(
                  labelKey: 'qibla.distance',
                  value: context.t('qibla.distanceValue'),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _MetricCard(
                  labelKey: 'qibla.offset',
                  value: '−12.4°',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.labelKey, required this.value});
  final String labelKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line, width: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          EyebrowKey(labelKey),
          const SizedBox(height: 4),
          Text(
            Fmt.n(context, value),
            style: AppTypography.displaySmall.copyWith(fontSize: 22),
          ),
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  _CompassDialPainter({required this.qiblaAngle, required this.isRtl});
  final double qiblaAngle;
  final bool isRtl;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);

    // Outer + inner rings
    canvas.drawCircle(
      c,
      120,
      Paint()
        ..color = AppColors.line
        ..strokeWidth = 0.6
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      c,
      105,
      Paint()
        ..color = AppColors.lineSoft
        ..strokeWidth = 0.5
        ..style = PaintingStyle.stroke,
    );

    // Tick marks
    for (int i = 0; i < 72; i++) {
      final double angle = i * 360 / 72;
      final bool long = i % 9 == 0;
      final double r1 = long ? 100 : 108;
      final double r2 = 116;
      final double rad = angle * math.pi / 180;
      final double x1 = c.dx + r1 * math.sin(rad);
      final double y1 = c.dy - r1 * math.cos(rad);
      final double x2 = c.dx + r2 * math.sin(rad);
      final double y2 = c.dy - r2 * math.cos(rad);
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = AppColors.gold.withValues(alpha: long ? 0.7 : 0.25)
          ..strokeWidth = long ? 1 : 0.5,
      );
    }

    // Cardinal letters
    final List<_Cardinal> cardinals = <_Cardinal>[
      _Cardinal(isRtl ? 'ش' : 'N', 0, true),
      _Cardinal(isRtl ? 'ق' : 'E', 90, false),
      _Cardinal(isRtl ? 'ج' : 'S', 180, false),
      _Cardinal(isRtl ? 'غ' : 'W', 270, false),
    ];
    for (final _Cardinal p in cardinals) {
      final double rad = p.angle * math.pi / 180;
      final double x = c.dx + 88 * math.sin(rad);
      final double y = c.dy - 88 * math.cos(rad);
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: p.label,
          style: TextStyle(
            color: p.primary ? AppColors.gold : AppColors.textTertiary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }

    // Kaaba marker on the qibla bearing
    final double qRad = qiblaAngle * math.pi / 180;
    final double qx = c.dx + 124 * math.sin(qRad);
    final double qy = c.dy - 124 * math.cos(qRad);
    canvas.drawCircle(
      Offset(qx, qy),
      14,
      Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.fill,
    );
    final TextPainter kaaba = TextPainter(
      text: const TextSpan(
        text: '⌂',
        style: TextStyle(
          color: Color(0xFF1A1208),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    kaaba.paint(canvas, Offset(qx - kaaba.width / 2, qy - kaaba.height / 2));
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter old) => true;
}

class _Cardinal {
  const _Cardinal(this.label, this.angle, this.primary);
  final String label;
  final double angle;
  final bool primary;
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    // Top half (gold)
    final Path top = Path()
      ..moveTo(c.dx, c.dy)
      ..lineTo(c.dx - 6, c.dy - 60)
      ..lineTo(c.dx, c.dy - 80)
      ..lineTo(c.dx + 6, c.dy - 60)
      ..close();
    canvas.drawPath(top, Paint()..color = AppColors.gold);
    // Bottom half (faint)
    final Path bottom = Path()
      ..moveTo(c.dx, c.dy)
      ..lineTo(c.dx - 6, c.dy + 60)
      ..lineTo(c.dx, c.dy + 80)
      ..lineTo(c.dx + 6, c.dy + 60)
      ..close();
    canvas.drawPath(
      bottom,
      Paint()..color = AppColors.textSecondary.withValues(alpha: 0.4),
    );
    // Center hub
    canvas.drawCircle(
      c,
      8,
      Paint()..color = AppColors.surface,
    );
    canvas.drawCircle(
      c,
      8,
      Paint()
        ..color = AppColors.gold
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(
      c,
      2.5,
      Paint()..color = AppColors.gold,
    );
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter old) => false;
}
