import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;

/// A Kurdistan city covered by the official mosque-schedule tables.
class KurdistanCity {
  const KurdistanCity(this.id, this.en, this.ar, this.lat, this.lng);
  final String id;
  final String en;
  final String ar;
  final double lat;
  final double lng;
}

/// Official Kurdistan prayer-time schedules (the same hand-set mosque times
/// used by local apps like بانگ), embedded as an offline asset.
///
/// Data source: `ahmadsoran/kurdistan-prayer-times-js` (MIT licensed),
/// flattened to `assets/data/kurdistan_prayer_times.json` keyed by
/// `cityId -> "month-day" -> [fajr, sunrise, dhuhr, asr, maghrib, isha]`.
class KurdistanPrayerData {
  KurdistanPrayerData._();
  static final KurdistanPrayerData instance = KurdistanPrayerData._();

  /// Covered cities with approximate centre coordinates (north → south).
  static const List<KurdistanCity> cities = <KurdistanCity>[
    KurdistanCity('zakho', 'Zakho', 'زاخۆ', 37.1436, 42.6872),
    KurdistanCity('duhok', 'Duhok', 'دهۆک', 36.8669, 42.9483),
    KurdistanCity('akre', 'Akre', 'ئاکرێ', 36.7424, 43.8917),
    KurdistanCity('shekhan', 'Shekhan', 'شێخان', 36.6939, 43.3503),
    KurdistanCity('erbil', 'Erbil', 'هەولێر', 36.1911, 44.0094),
    KurdistanCity('taqtaq', 'Taqtaq', 'تەقتەق', 35.8869, 44.5928),
    KurdistanCity('sulaymaniyah', 'Sulaymaniyah', 'سلێمانی', 35.5613, 45.4375),
    KurdistanCity('kirkuk', 'Kirkuk', 'کەرکوک', 35.4681, 44.3922),
    KurdistanCity('qara_hanjir', 'Qara Hanjir', 'قەرەهەنجیر', 35.5500, 44.5500),
    KurdistanCity('halabja', 'Halabja', 'هەڵەبجە', 35.1778, 45.9864),
    KurdistanCity('tuz_khurma', 'Tuz Khurmatu', 'تووزخورماتوو', 34.8836, 44.6383),
    KurdistanCity('khanaqin', 'Khanaqin', 'خانەقین', 34.3519, 45.3914),
    KurdistanCity('jalawla', 'Jalawla', 'جەڵەوڵا', 34.2761, 45.1592),
  ];

  Map<String, dynamic>? _data;

  Future<void> _ensureLoaded() async {
    if (_data != null) return;
    final String raw = await rootBundle
        .loadString('assets/data/kurdistan_prayer_times.json');
    _data = jsonDecode(raw) as Map<String, dynamic>;
  }

  static KurdistanCity? cityById(String id) {
    for (final KurdistanCity c in cities) {
      if (c.id == id) return c;
    }
    return null;
  }

  static double _km(double lat1, double lon1, double lat2, double lon2) {
    const double r = 6371.0;
    final double dLat = (lat2 - lat1) * math.pi / 180;
    final double dLon = (lon2 - lon1) * math.pi / 180;
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  /// Nearest covered city within [maxKm], or null when the user is outside
  /// the Kurdistan region (so the caller falls back to astronomical times).
  static KurdistanCity? nearestCity(double lat, double lng,
      {double maxKm = 85}) {
    KurdistanCity? best;
    double bestD = double.infinity;
    for (final KurdistanCity c in cities) {
      final double d = _km(lat, lng, c.lat, c.lng);
      if (d < bestD) {
        bestD = d;
        best = c;
      }
    }
    return bestD <= maxKm ? best : null;
  }

  /// The six prayer [DateTime]s for [cityId] on [date]
  /// (`[fajr, sunrise, dhuhr, asr, maghrib, isha]`) or null if unavailable.
  Future<List<DateTime>?> times(String cityId, DateTime date) async {
    await _ensureLoaded();
    final dynamic city = _data?[cityId];
    if (city is! Map) return null;
    final dynamic arr = city['${date.month}-${date.day}'];
    if (arr is! List || arr.length < 6) return null;
    return <DateTime>[
      for (final dynamic s in arr) _parse(date, s as String),
    ];
  }

  DateTime _parse(DateTime date, String hm) {
    final List<String> p = hm.split(':');
    final int h = int.tryParse(p[0].trim()) ?? 0;
    final int m = p.length > 1 ? (int.tryParse(p[1].trim()) ?? 0) : 0;
    return DateTime(date.year, date.month, date.day, h, m);
  }
}
