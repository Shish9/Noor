import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:flutter/foundation.dart';
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
    required this.located,
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
    final DailyPrayerTimes result = _computeFor(
      lat: coords.lat,
      lng: coords.lng,
      label: coords.label.isEmpty ? _defaultLabel : coords.label,
      date: DateTime.now(),
      located: located && !isDefault,
    );
    // Diagnostic (visible in `adb logcat | grep NOOR_PRAYER`).
    debugPrint('NOOR_PRAYER coords=${coords.lat},${coords.lng} '
        'located=${result.located} '
        'fajr=${result.timeFor('Fajr')} dhuhr=${result.timeFor('Dhuhr')} '
        'asr=${result.timeFor('Asr')} maghrib=${result.timeFor('Maghrib')} '
        'isha=${result.timeFor('Isha')} tzOffset=${DateTime.now().timeZoneOffset}');
    return result;
  }

  DailyPrayerTimes _computeFor({
    required double lat,
    required double lng,
    required String label,
    required DateTime date,
    required bool located,
  }) {
    final adhan.Coordinates coords = adhan.Coordinates(lat, lng);
    // Umm al-Qura (Makkah): Fajr 18.5°, Isha 90 min after Maghrib. Shafi Asr.
    final adhan.CalculationParameters params =
        adhan.CalculationMethodParameters.ummAlQura();
    params.madhab = adhan.Madhab.shafi;
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
