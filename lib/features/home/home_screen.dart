import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/daily_content.dart';
import '../../core/data/dua_data.dart';
import '../../core/data/surah_data.dart';
import '../../core/l10n/format_helpers.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/dua.dart';
import '../../core/models/surah.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/prayer_times_service.dart';
import '../../core/state/app_state.dart';
import '../../core/state/quran_state.dart';
import '../../core/state/settings_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/gold_divider.dart';
import '../../core/widgets/noor_star.dart';

/// Pixel-faithful port of the Noor design's Today/Home screen.
///
/// Layout (top → bottom):
///   1. Greeting block       date · Assalāmu Alaikum · italic gold name
///   2. Next-prayer hero     38px Cormorant + 22px gold Amiri, gold time,
///                           mini 6-prayer rail with active pill, two
///                           NoorStar bleeds in opposite corners
///   3. Ayah of the day      eyebrow · centered Amiri Quran verse · gold
///                           divider · italic Cormorant translation ·
///                           reference + bookmark/share row
///   4. Continue + Streak    14:10 split with thin gold progress rule and
///                           a 7-bar streak graph
///   5. For this moment      section header + see-all + 3-tile dua rail
///                           with NoorStar in the corner
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 140),
        physics: const BouncingScrollPhysics(),
        children: const <Widget>[
          _GreetingHeader(),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: _NextPrayerHero(),
          ),
          SizedBox(height: 22),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: _AyahCard(),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: _ContinueAndStreak(),
          ),
          SizedBox(height: 22),
          _ForThisMomentHeader(),
          SizedBox(height: 12),
          _DuasRail(),
        ],
      ),
    );
  }
}

// ─── 1. Greeting header ──────────────────────────────────────────────────
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  String _greetingKey() {
    final int h = DateTime.now().hour;
    if (h < 5) return 'greeting.night';
    if (h < 12) return 'greeting.morning';
    if (h < 17) return 'greeting.afternoon';
    if (h < 21) return 'greeting.evening';
    return 'greeting.night';
  }

  @override
  Widget build(BuildContext context) {
    final SettingsState settings = context.watch<SettingsState>();
    final String name = settings.userName;
    final String today = Fmt.headerDate(context, DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            today,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.t(_greetingKey()),
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 32,
              height: 1.1,
            ),
          ),
          Text(
            name.isNotEmpty ? name : context.t('greeting.subtitle'),
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.gold,
              fontStyle: FontStyle.italic,
              fontSize: name.isNotEmpty ? 32 : 22,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 2. Next-prayer hero ─────────────────────────────────────────────────
class _NextPrayerHero extends StatefulWidget {
  const _NextPrayerHero();

  @override
  State<_NextPrayerHero> createState() => _NextPrayerHeroState();
}

class _NextPrayerHeroState extends State<_NextPrayerHero> {
  // Falls back to these until real, location-based times load.
  static const List<_Prayer> _defaultPrayers = <_Prayer>[
    _Prayer('Fajr', 'الفجر', '05:12', 'prayer.fajr'),
    _Prayer('Sunrise', 'الشروق', '06:38', 'prayer.sunrise'),
    _Prayer('Dhuhr', 'الظهر', '12:30', 'prayer.dhuhr'),
    _Prayer('Asr', 'العصر', '15:48', 'prayer.asr'),
    _Prayer('Maghrib', 'المغرب', '18:22', 'prayer.maghrib'),
    _Prayer('Isha', 'العشاء', '19:55', 'prayer.isha'),
  ];

  List<_Prayer> _prayers = _defaultPrayers;
  String? _lastConfigKey;

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  Future<void> _loadTimes() async {
    if (kIsWeb) return;
    try {
      final DailyPrayerTimes t =
          await PrayerTimesService.instance.getToday(forceLocate: true);
      if (!mounted) return;
      setState(() {
        _prayers = <_Prayer>[
          _Prayer('Fajr', 'الفجر', t.timeFor('Fajr'), 'prayer.fajr'),
          _Prayer('Sunrise', 'الشروق', t.timeFor('Sunrise'), 'prayer.sunrise'),
          _Prayer('Dhuhr', 'الظهر', t.timeFor('Dhuhr'), 'prayer.dhuhr'),
          _Prayer('Asr', 'العصر', t.timeFor('Asr'), 'prayer.asr'),
          _Prayer('Maghrib', 'المغرب', t.timeFor('Maghrib'), 'prayer.maghrib'),
          _Prayer('Isha', 'العشاء', t.timeFor('Isha'), 'prayer.isha'),
        ];
      });
      // Schedule prayer + dua notifications now that real coordinates are
      // cached (runs once per launch).
      await NotificationService.instance.ensureScheduled();
    } catch (_) {}
  }

  int _currentIndex() {
    final TimeOfDay now = TimeOfDay.now();
    final int nowMin = now.hour * 60 + now.minute;
    int idx = 0;
    for (int i = 0; i < _prayers.length; i++) {
      final List<String> parts = _prayers[i].time.split(':');
      final int m = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (nowMin >= m) idx = i;
    }
    return idx;
  }

  _Prayer _next() {
    final int idx = _currentIndex();
    return idx == _prayers.length - 1 ? _prayers[0] : _prayers[idx + 1];
  }

  String _countdown() {
    final _Prayer n = _next();
    final List<String> parts = n.time.split(':');
    final TimeOfDay now = TimeOfDay.now();
    int diff = (int.parse(parts[0]) * 60 + int.parse(parts[1])) -
        (now.hour * 60 + now.minute);
    if (diff < 0) diff += 24 * 60;
    final int h = diff ~/ 60;
    final int m = diff % 60;
    return h == 0 ? '${m}m' : '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    // Reload times when any prayer-time setting changes.
    final String cfg = context.watch<SettingsState>().prayerConfigKey;
    if (_lastConfigKey == null) {
      _lastConfigKey = cfg;
    } else if (_lastConfigKey != cfg) {
      _lastConfigKey = cfg;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadTimes();
      });
    }
    final int currentIdx = _currentIndex();
    final _Prayer next = _next();

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.heroGradient,
          border: Border.all(color: AppColors.line, width: 0.7),
          borderRadius: BorderRadius.circular(26),
          boxShadow: AppColors.cardShadow,
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            // Decorative stars — must NOT swallow taps.
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
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
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
                                  context.t(next.nameKey),
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
                                  _countdown(),
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
                          Fmt.n(context, next.time),
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
                  Row(
                    children: List<Widget>.generate(_prayers.length, (int i) {
                      final _Prayer p = _prayers[i];
                      final bool isNext = p.english == next.english;
                      final bool passed = i < currentIdx;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              right: i == _prayers.length - 1 ? 0 : 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            color: isNext
                                ? AppColors.accentBg
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isNext
                                  ? AppColors.line
                                  : Colors.transparent,
                              width: 0.7,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Builder(builder: (BuildContext ctx) {
                                final SettingsState s =
                                    ctx.watch<SettingsState>();
                                final String label = s.isRtl
                                    ? p.arabic
                                    : p.english.substring(0, 3).toUpperCase();
                                return Text(
                                  label,
                                  style: AppTypography.caption.copyWith(
                                    color: passed
                                        ? AppColors.textTertiary
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    fontSize: 10,
                                  ),
                                );
                              }),
                              const SizedBox(height: 2),
                              Text(
                                Fmt.n(context, p.time),
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
          ],
        ),
      ),
    );
  }
}

class _Prayer {
  const _Prayer(this.english, this.arabic, this.time, this.nameKey);
  final String english;
  final String arabic;
  final String time;
  final String nameKey;
}

// ─── 3. Ayah of the day card ─────────────────────────────────────────────
class _AyahCard extends StatelessWidget {
  const _AyahCard();

  @override
  Widget build(BuildContext context) {
    final Ayah ayah = DailyContent.ayahForToday();
    final Surah surah = SurahData.byNumber(ayah.surahNumber);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/quran/reader',
        arguments: <String, dynamic>{
          'surah': ayah.surahNumber,
          'ayah': ayah.number,
        },
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line, width: 0.7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const EyebrowKey('section.dailyAyah'),
            const SizedBox(height: 18),
            Text(
              ayah.arabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(
                fontSize: 28,
                color: AppColors.textPrimary,
                height: 2.0,
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: GoldDivider(width: 160)),
            const SizedBox(height: 14),
            Text(
              '"${ayah.translation}"',
              textAlign: TextAlign.center,
              style: AppTypography.verseEnglish,
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.only(top: 14),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.lineSoft, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${Fmt.surahName(context, surah).toUpperCase()} · ${Fmt.n(context, ayah.surahNumber)}:${Fmt.n(context, ayah.number)}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                      letterSpacing: 0.88,
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Icon(Icons.bookmark_border_rounded,
                          size: 18, color: AppColors.gold),
                      SizedBox(width: 14),
                      Icon(Icons.ios_share_rounded,
                          size: 18, color: AppColors.gold),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 4. Continue + Streak ────────────────────────────────────────────────
class _ContinueAndStreak extends StatelessWidget {
  const _ContinueAndStreak();

  @override
  Widget build(BuildContext context) {
    final QuranState quran = context.watch<QuranState>();
    final Map<String, dynamic>? last = quran.lastRead;

    return SizedBox(
      height: 116,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 14,
            child: _ContinueCard(last: last),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 10,
            child: _StreakCard(streak: quran.currentStreak),
          ),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.last});
  final Map<String, dynamic>? last;

  @override
  Widget build(BuildContext context) {
    final Surah surah;
    final int ayahNum;
    final double progress;
    if (last != null) {
      surah = SurahData.byNumber(last!['surah'] as int);
      ayahNum = last!['ayah'] as int;
      progress = (ayahNum / surah.ayahCount).clamp(0.0, 1.0);
    } else {
      surah = SurahData.byNumber(67); // Al-Mulk — the design's default
      ayahNum = 4;
      progress = 0.13;
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/quran/reader',
        arguments: <String, dynamic>{
          'surah': surah.number,
          'ayah': ayahNum,
        },
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line, width: 0.7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const EyebrowKey('section.continueReading'),
                const SizedBox(height: 4),
                Text(
                  Fmt.surahName(context, surah),
                  style: AppTypography.headlineMedium.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.t('home.ayahCount')} ${Fmt.n(context, ayahNum)} ${context.t('home.ofWord')} ${Fmt.n(context, surah.ayahCount)}',
                  style: AppTypography.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: <Widget>[
                  Container(height: 4, color: AppColors.line),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(height: 4, color: AppColors.gold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final int show = streak == 0 ? 14 : streak; // design defaults to "14 days"
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line, width: 0.7),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.local_fire_department_rounded,
                  color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                context.t('home.streakLabel'),
                style: AppTypography.eyebrow.copyWith(
                  letterSpacing: 1.1,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text(
                    Fmt.n(context, show),
                    style: AppTypography.displayMedium.copyWith(fontSize: 32),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.t('home.daysWord'),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: List<Widget>.generate(7, (int i) {
                  final bool active = i < 6;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 6 ? 0 : 3),
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: active ? AppColors.gold : AppColors.line,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── 5. For this moment ──────────────────────────────────────────────────
class _ForThisMomentHeader extends StatelessWidget {
  const _ForThisMomentHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            context.t('home.forMoment'),
            style: AppTypography.headlineMedium.copyWith(fontSize: 18),
          ),
          GestureDetector(
            onTap: () => context.read<AppState>().setTab(2),
            child: Text(
              context.t('home.seeAll'),
              style: AppTypography.button.copyWith(
                color: AppColors.gold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuasRail extends StatelessWidget {
  const _DuasRail();

  @override
  Widget build(BuildContext context) {
    final List<Dua> selection = DuaData.all.take(3).toList();
    if (selection.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: selection.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (BuildContext _, int i) {
          final Color accent = i == 0
              ? AppColors.gold
              : i == 1
                  ? AppColors.goldLight
                  : AppColors.goldDeep;
          return _DuaTile(dua: selection[i], accent: accent);
        },
      ),
    );
  }
}

class _DuaTile extends StatelessWidget {
  const _DuaTile({required this.dua, required this.accent});
  final Dua dua;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/duas/detail',
        arguments: <String, dynamic>{
          'categoryId': dua.categoryId,
          'duaId': dua.id,
        },
      ),
      child: Container(
        width: 168,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line, width: 0.7),
          boxShadow: AppColors.cardShadow,
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Positioned(
              right: -16,
              top: -16,
              child: IgnorePointer(
                child: NoorStar(
                  size: 72,
                  stroke: 0.4,
                  color: accent.withValues(alpha: 0.55),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.t('home.verse'),
                  style: AppTypography.eyebrow.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 1.4,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  dua.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineMedium.copyWith(
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
