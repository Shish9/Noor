import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:geolocator/geolocator.dart';

import 'kurdistan_prayer_data.dart';
import 'storage_service.dart';

/// A user-selectable prayer-time calculation method. [id] is persisted in
/// prefs; [name] is the short label shown in Settings.
class PrayerCalcMethod {
  const PrayerCalcMethod(this.id, this.name);
  final String id;
  final String name;
}

/// Today's prayer times for a given lat/lng.
class DailyPrayerTimes {
  const DailyPrayerTimes({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
    required this.located,
    this.cityId,
  });

  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final double latitude;
  final double longitude;
  final String locationLabel;
  /// True when real device coordinates were used (not the Mecca fallback).
  final bool located;

  /// When non-null, these times came from the embedded Kurdistan mosque
  /// schedule for this city (rather than astronomical calculation).
  final String? cityId;

  /// Returns the prayer that is "current" right now (Now is after its start
  /// time, but before the next prayer). Sunrise is skipped — it splits Fajr
  /// from Dhuhr but isn't a prayer in its own right.
  String? currentPrayerName() {
    final DateTime now = DateTime.now();
    if (now.isBefore(fajr)) return null;
    if (now.isBefore(sunrise)) return 'Fajr';
    if (now.isBefore(dhuhr)) return 'Sunrise';
    if (now.isBefore(asr)) return 'Dhuhr';
    if (now.isBefore(maghrib)) return 'Asr';
    if (now.isBefore(isha)) return 'Maghrib';
    return 'Isha';
  }

  /// Whether a prayer has already passed today.
  bool isPast(String name) {
    final DateTime now = DateTime.now();
    switch (name) {
      case 'Fajr':
        return now.isAfter(fajr);
      case 'Sunrise':
        return now.isAfter(sunrise);
      case 'Dhuhr':
        return now.isAfter(dhuhr);
      case 'Asr':
        return now.isAfter(asr);
      case 'Maghrib':
        return now.isAfter(maghrib);
      case 'Isha':
        return now.isAfter(isha);
    }
    return false;
  }

  String timeFor(String name) {
    final DateTime when;
    switch (name) {
      case 'Fajr':
        when = fajr;
        break;
      case 'Sunrise':
        when = sunrise;
        break;
      case 'Dhuhr':
        when = dhuhr;
        break;
      case 'Asr':
        when = asr;
        break;
      case 'Maghrib':
        when = maghrib;
        break;
      case 'Isha':
        when = isha;
        break;
      default:
        when = fajr;
    }
    final String h = when.hour.toString().padLeft(2, '0');
    final String m = when.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

/// Asks for location permission once, caches lat/lng + an optional reverse-
/// geocoded label, and computes prayer times for today using Adhan.
class PrayerTimesService {
  PrayerTimesService._();
  static final PrayerTimesService instance = PrayerTimesService._();

  /// Default to Mecca so the UI has reasonable times before location is
  /// granted.
  static const double _defaultLat = 21.3891;
  static const double _defaultLng = 39.8579;
  static const String _defaultLabel = 'Mecca, Saudi Arabia';

  Future<({double lat, double lng, String label})> _getCoords() async {
    final StorageService s = StorageService.instance;
    // Try cached coords first
    final double? cachedLat = s.getPref<num>('coord_lat', fallback: null)?.toDouble();
    final double? cachedLng = s.getPref<num>('coord_lng', fallback: null)?.toDouble();
    final String? cachedLabel = s.getPref<String>('coord_label', fallback: null);
    if (cachedLat != null && cachedLng != null) {
      return (lat: cachedLat, lng: cachedLng, label: cachedLabel ?? '');
    }
    return (lat: _defaultLat, lng: _defaultLng, label: _defaultLabel);
  }

  /// Current permission/location status, used by the UI to decide whether to
  /// show "enable location for accurate times".
  Future<bool> hasLocationAccess() async {
    final LocationPermission perm = await Geolocator.checkPermission();
    return perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse;
  }

  /// Requests permission (showing the system dialog if needed) and returns a
  /// fresh position, caching it. Returns null if denied or unavailable.
  Future<Position?> resolvePosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }
      // Last-known is instant and the device already has a fix; use it first,
      // then try a fresh reading to refine.
      Position? pos = await Geolocator.getLastKnownPosition();
      try {
        pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 12),
        );
      } catch (_) {
        // keep last-known
      }
      if (pos != null) {
        await StorageService.instance.setPref('coord_lat', pos.latitude);
        await StorageService.instance.setPref('coord_lng', pos.longitude);
        await StorageService.instance.setPref(
          'coord_label',
          '${pos.latitude.toStringAsFixed(3)}°, ${pos.longitude.toStringAsFixed(3)}°',
        );
      }
      return pos;
    } catch (_) {
      return null;
    }
  }

  /// Computes today's times. If [forceLocate] is true (default), it first
  /// awaits a fresh location (requesting permission), so the very first render
  /// already uses real coordinates instead of the Mecca fallback.
  Future<DailyPrayerTimes> getToday({bool forceLocate = true}) async {
    bool located = false;
    if (forceLocate) {
      final Position? pos = await resolvePosition();
      located = pos != null;
    } else {
      located = await hasLocationAccess();
    }

    final ({double lat, double lng, String label}) coords = await _getCoords();
    // If we have cached/real coords (not the Mecca default), mark as located.
    final bool isDefault =
        coords.lat == _defaultLat && coords.lng == _defaultLng;
    final DateTime now = DateTime.now();
    final StorageService s = StorageService.instance;

    // ── Kurdistan official mosque schedule ──────────────────────────────
    // Default ('auto'): use the embedded city table whenever the user is in
    // (or has manually picked) a covered Kurdistan city — this matches local
    // apps like بانگ. 'calc' forces astronomical calculation everywhere.
    final String source = s.getPref<String>('prayer_source', fallback: 'auto') ?? 'auto';
    final String cityPref = s.getPref<String>('prayer_city', fallback: 'auto') ?? 'auto';
    if (source != 'calc') {
      KurdistanCity? city;
      if (cityPref != 'auto') {
        city = KurdistanPrayerData.cityById(cityPref);
      } else if (!isDefault) {
        city = KurdistanPrayerData.nearestCity(coords.lat, coords.lng);
      }
      if (city != null) {
        final List<DateTime>? t =
            await KurdistanPrayerData.instance.times(city.id, now);
        if (t != null) {
          return _fromTable(
            city,
            t,
            now,
            located: located || cityPref != 'auto',
          );
        }
      }
    }

    return _computeFor(
      lat: coords.lat,
      lng: coords.lng,
      label: coords.label.isEmpty ? _defaultLabel : coords.label,
      date: now,
      located: located && !isDefault,
    );
  }

  /// Builds a [DailyPrayerTimes] from a Kurdistan city table row, applying the
  /// user's per-prayer fine-tune offsets on top.
  DailyPrayerTimes _fromTable(
    KurdistanCity city,
    List<DateTime> t,
    DateTime date, {
    required bool located,
  }) {
    final StorageService s = StorageService.instance;
    int off(String k) => s.getPref<int>('prayer_adj_$k', fallback: 0) ?? 0;
    return DailyPrayerTimes(
      date: date,
      fajr: t[0].add(Duration(minutes: off('fajr'))),
      sunrise: t[1],
      dhuhr: t[2].add(Duration(minutes: off('dhuhr'))),
      asr: t[3].add(Duration(minutes: off('asr'))),
      maghrib: t[4].add(Duration(minutes: off('maghrib'))),
      isha: t[5].add(Duration(minutes: off('isha'))),
      latitude: city.lat,
      longitude: city.lng,
      locationLabel: city.en,
      located: located,
      cityId: city.id,
    );
  }

  /// The five obligatory prayer [DateTime]s for [date]
  /// (`[fajr, dhuhr, asr, maghrib, isha]`), using the same source as
  /// [getToday] but with already-cached coordinates (no GPS fetch). Used by the
  /// notification scheduler to set reminders for upcoming days.
  Future<List<DateTime>?> scheduleTimesFor(DateTime date) async {
    final ({double lat, double lng, String label}) coords = await _getCoords();
    final bool isDefault =
        coords.lat == _defaultLat && coords.lng == _defaultLng;
    final StorageService s = StorageService.instance;
    final String source = s.getPref<String>('prayer_source', fallback: 'auto') ?? 'auto';
    final String cityPref = s.getPref<String>('prayer_city', fallback: 'auto') ?? 'auto';

    if (source != 'calc') {
      KurdistanCity? city;
      if (cityPref != 'auto') {
        city = KurdistanPrayerData.cityById(cityPref);
      } else if (!isDefault) {
        city = KurdistanPrayerData.nearestCity(coords.lat, coords.lng);
      }
      if (city != null) {
        final List<DateTime>? t =
            await KurdistanPrayerData.instance.times(city.id, date);
        if (t != null) {
          int off(String k) => s.getPref<int>('prayer_adj_$k', fallback: 0) ?? 0;
          return <DateTime>[
            t[0].add(Duration(minutes: off('fajr'))),
            t[2].add(Duration(minutes: off('dhuhr'))),
            t[3].add(Duration(minutes: off('asr'))),
            t[4].add(Duration(minutes: off('maghrib'))),
            t[5].add(Duration(minutes: off('isha'))),
          ];
        }
      }
    }

    final DailyPrayerTimes d = _computeFor(
      lat: coords.lat,
      lng: coords.lng,
      label: coords.label,
      date: date,
      located: !isDefault,
    );
    return <DateTime>[d.fajr, d.dhuhr, d.asr, d.maghrib, d.isha];
  }

  /// The calculation methods offered in Settings. Muslim World League is the
  /// default because it matches the published Duhok / Kurdistan mosque
  /// schedules most closely (Umm al-Qura runs Fajr & Isha several minutes
  /// early for this region).
  static const List<PrayerCalcMethod> methods = <PrayerCalcMethod>[
    PrayerCalcMethod('muslimWorldLeague', 'Muslim World League'),
    PrayerCalcMethod('ummAlQura', 'Umm al-Qura (Makkah)'),
    PrayerCalcMethod('egyptian', 'Egyptian Authority'),
    PrayerCalcMethod('karachi', 'Karachi'),
    PrayerCalcMethod('dubai', 'Dubai'),
    PrayerCalcMethod('qatar', 'Qatar'),
    PrayerCalcMethod('kuwait', 'Kuwait'),
    PrayerCalcMethod('turkiye', 'Turkey (Diyanet)'),
    PrayerCalcMethod('northAmerica', 'North America (ISNA)'),
    PrayerCalcMethod('tehran', 'Tehran'),
    PrayerCalcMethod('jafari', 'Jafari (Shia)'),
    PrayerCalcMethod('gulfRegion', 'Gulf Region'),
  ];

  /// The fine-tune offset keys, in display order.
  static const List<String> offsetKeys = <String>[
    'fajr',
    'dhuhr',
    'asr',
    'maghrib',
    'isha',
  ];

  adhan.CalculationParameters _paramsForMethod(String id) {
    switch (id) {
      case 'ummAlQura':
        return adhan.CalculationMethodParameters.ummAlQura();
      case 'egyptian':
        return adhan.CalculationMethodParameters.egyptian();
      case 'karachi':
        return adhan.CalculationMethodParameters.karachi();
      case 'dubai':
        return adhan.CalculationMethodParameters.dubai();
      case 'qatar':
        return adhan.CalculationMethodParameters.qatar();
      case 'kuwait':
        return adhan.CalculationMethodParameters.kuwait();
      case 'turkiye':
        return adhan.CalculationMethodParameters.turkiye();
      case 'northAmerica':
        return adhan.CalculationMethodParameters.northAmerica();
      case 'tehran':
        return adhan.CalculationMethodParameters.tehran();
      case 'jafari':
        return adhan.CalculationMethodParameters.jafari();
      case 'gulfRegion':
        return adhan.CalculationMethodParameters.gulfRegion();
      case 'muslimWorldLeague':
      default:
        return adhan.CalculationMethodParameters.muslimWorldLeague();
    }
  }

  DailyPrayerTimes _computeFor({
    required double lat,
    required double lng,
    required String label,
    required DateTime date,
    required bool located,
  }) {
    final adhan.Coordinates coords = adhan.Coordinates(lat, lng);
    final StorageService s = StorageService.instance;

    // Calculation method (default: Muslim World League — closest to the
    // Kurdistan / Duhok mosque schedules).
    final String methodId =
        s.getPref<String>('prayer_method', fallback: 'muslimWorldLeague') ??
            'muslimWorldLeague';
    final adhan.CalculationParameters params = _paramsForMethod(methodId);

    // Asr madhab (default: Shafi — predominant in Kurdistan).
    final String madhabId =
        s.getPref<String>('prayer_madhab', fallback: 'shafi') ?? 'shafi';
    params.madhab =
        madhabId == 'hanafi' ? adhan.Madhab.hanafi : adhan.Madhab.shafi;

    // Per-prayer fine-tune offsets in minutes (added on top of the method's
    // own adjustments by adhan_dart).
    params.adjustments = <adhan.Prayer, int>{
      adhan.Prayer.fajr: s.getPref<int>('prayer_adj_fajr', fallback: 0) ?? 0,
      adhan.Prayer.sunrise: 0,
      adhan.Prayer.dhuhr: s.getPref<int>('prayer_adj_dhuhr', fallback: 0) ?? 0,
      adhan.Prayer.asr: s.getPref<int>('prayer_adj_asr', fallback: 0) ?? 0,
      adhan.Prayer.maghrib:
          s.getPref<int>('prayer_adj_maghrib', fallback: 0) ?? 0,
      adhan.Prayer.isha: s.getPref<int>('prayer_adj_isha', fallback: 0) ?? 0,
    };

    final adhan.PrayerTimes times = adhan.PrayerTimes(
      coordinates: coords,
      date: date,
      calculationParameters: params,
    );

    // adhan_dart returns UTC DateTimes — convert to the device's local zone.
    DateTime toLocal(DateTime t) => t.toLocal();

    return DailyPrayerTimes(
      date: date,
      fajr: toLocal(times.fajr),
      sunrise: toLocal(times.sunrise),
      dhuhr: toLocal(times.dhuhr),
      asr: toLocal(times.asr),
      maghrib: toLocal(times.maghrib),
      isha: toLocal(times.isha),
      latitude: lat,
      longitude: lng,
      locationLabel: label,
      located: located,
    );
  }
}
