import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:geolocator/geolocator.dart';

import 'storage_service.dart';

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

    // Request fresh location in the background (don't block prayer times
    // calculation on permission grant).
    _refreshCoords();

    if (cachedLat != null && cachedLng != null) {
      return (lat: cachedLat, lng: cachedLng, label: cachedLabel ?? '');
    }
    return (lat: _defaultLat, lng: _defaultLng, label: _defaultLabel);
  }

  Future<void> _refreshCoords() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }
      final bool enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      final Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      await StorageService.instance.setPref('coord_lat', pos.latitude);
      await StorageService.instance.setPref('coord_lng', pos.longitude);
      // We don't reverse-geocode here (would add a heavy dep). Show a simple
      // "Latitude, Longitude" fallback label instead.
      final String lat = pos.latitude.toStringAsFixed(2);
      final String lng = pos.longitude.toStringAsFixed(2);
      await StorageService.instance.setPref('coord_label', '$lat°, $lng°');
    } catch (_) {
      // Silent — fall back to cached or default coords.
    }
  }

  Future<DailyPrayerTimes> getToday() async {
    final ({double lat, double lng, String label}) coords = await _getCoords();
    return _computeFor(
      lat: coords.lat,
      lng: coords.lng,
      label: coords.label.isEmpty ? _defaultLabel : coords.label,
      date: DateTime.now(),
    );
  }

  DailyPrayerTimes _computeFor({
    required double lat,
    required double lng,
    required String label,
    required DateTime date,
  }) {
    final adhan.Coordinates coords = adhan.Coordinates(lat, lng);
    // Muslim World League is a sensible global default.
    final adhan.CalculationParameters params =
        adhan.CalculationMethod.muslimWorldLeague();
    params.madhab = adhan.Madhab.shafi;
    final adhan.PrayerTimes times = adhan.PrayerTimes(
      coordinates: coords,
      date: date,
      calculationParameters: params,
      utcOffset: date.timeZoneOffset,
    );

    DateTime _local(DateTime? t) =>
        (t ?? date).toLocal();

    return DailyPrayerTimes(
      date: date,
      fajr: _local(times.fajr),
      sunrise: _local(times.sunrise),
      dhuhr: _local(times.dhuhr),
      asr: _local(times.asr),
      maghrib: _local(times.maghrib),
      isha: _local(times.isha),
      latitude: lat,
      longitude: lng,
      locationLabel: label,
    );
  }
}
