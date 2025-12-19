import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the named slots we surface in the UI.
enum PrayerSlot { fajr, sunrise, dhuhr, asr, maghrib, isha }

extension PrayerSlotLabel on PrayerSlot {
  String get label {
    switch (this) {
      case PrayerSlot.fajr:
        return 'Fajr';
      case PrayerSlot.sunrise:
        return 'Sunrise';
      case PrayerSlot.dhuhr:
        return 'Dhuhr';
      case PrayerSlot.asr:
        return 'Asr';
      case PrayerSlot.maghrib:
        return 'Maghrib';
      case PrayerSlot.isha:
        return 'Isha';
    }
  }

  bool get isPrimaryPrayer => this != PrayerSlot.sunrise;
}

const Map<PrayerSlot, String> _apiFieldNames = <PrayerSlot, String>{
  PrayerSlot.fajr: 'Fajr',
  PrayerSlot.sunrise: 'Sunrise',
  PrayerSlot.dhuhr: 'Dhuhr',
  PrayerSlot.asr: 'Asr',
  PrayerSlot.maghrib: 'Maghrib',
  PrayerSlot.isha: 'Isha',
};

DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _parseTime(String raw, DateTime date) {
  final Match? match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
  if (match == null) {
    throw FormatException('Unsupported time format: $raw');
  }
  final int hour = int.parse(match.group(1)!);
  final int minute = int.parse(match.group(2)!);
  return DateTime(date.year, date.month, date.day, hour, minute);
}

class PrayerDay {
  PrayerDay({required this.date, required Map<PrayerSlot, DateTime> times})
    : _times = Map<PrayerSlot, DateTime>.unmodifiable(times);

  final DateTime date;
  final Map<PrayerSlot, DateTime> _times;

  DateTime? timeFor(PrayerSlot slot) => _times[slot];

  List<PrayerSlot> get slots => PrayerSlot.values;

  Map<String, dynamic> toCacheJson() {
    return <String, dynamic>{
      'date': DateTime(date.year, date.month, date.day).toIso8601String(),
      'times': <String, String>{
        for (final MapEntry<PrayerSlot, DateTime> entry in _times.entries)
          entry.key.name: entry.value.toIso8601String(),
      },
    };
  }

  factory PrayerDay.fromCacheJson(Map<String, dynamic> json) {
    final String? rawDate = json['date'] as String?;
    if (rawDate == null) {
      throw FormatException('Cached prayer day missing date');
    }
    final DateTime parsedDate = DateTime.parse(rawDate);
    final Map<String, dynamic>? rawTimes =
        json['times'] as Map<String, dynamic>?;
    if (rawTimes == null) {
      throw FormatException('Cached prayer day missing times');
    }

    final Map<PrayerSlot, DateTime> parsedTimes = <PrayerSlot, DateTime>{};
    rawTimes.forEach((String key, dynamic value) {
      final PrayerSlot slot = PrayerSlot.values.firstWhere(
        (PrayerSlot candidate) => candidate.name == key,
        orElse: () => throw FormatException('Unknown prayer slot $key'),
      );
      final String? timeRaw = value as String?;
      if (timeRaw == null) {
        throw FormatException('Cached prayer time missing value for $key');
      }
      parsedTimes[slot] = DateTime.parse(timeRaw);
    });

    return PrayerDay(
      date: DateTime(parsedDate.year, parsedDate.month, parsedDate.day),
      times: parsedTimes,
    );
  }
}

class PrayerCountdownInfo {
  PrayerCountdownInfo({
    required this.slot,
    required this.time,
    required this.remaining,
  });

  final PrayerSlot slot;
  final DateTime time;
  final Duration remaining;
}

class PrayerTimeService {
  PrayerTimeService({http.Client? client, PrayerTimeCache? cache})
    : _client = client ?? http.Client(),
      _cache = cache ?? PrayerTimeCache();

  final http.Client _client;
  final PrayerTimeCache _cache;

  Future<PrayerDay> fetchDailyTimings(DateTime date) async {
    final DateTime normalized = _normalize(date);
    final String dateFragment = DateFormat('dd-MM-yyyy').format(normalized);
    final Uri uri = Uri.https(
      'api.aladhan.com',
      '/v1/timings/$dateFragment',
      <String, String>{
        'latitude': '21.4225',
        'longitude': '39.8262',
        'method': '2',
      },
    );

    try {
      final http.Response response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load prayer timings (${response.statusCode})',
        );
      }

      final PrayerDay result = _parsePrayerDay(response.body, normalized);
      unawaited(_cache.write(result));
      return result;
    } catch (error) {
      final PrayerDay? cached = await _cache.read(normalized);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }

  Future<PrayerDay?> loadCachedDay(DateTime date) async {
    return _cache.read(_normalize(date));
  }

  PrayerDay _parsePrayerDay(String rawBody, DateTime normalized) {
    final Map<String, dynamic> body =
        jsonDecode(rawBody) as Map<String, dynamic>;
    final Map<String, dynamic>? data = body['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Prayer timings payload missing data section');
    }

    final Map<String, dynamic>? timings =
        data['timings'] as Map<String, dynamic>?;
    if (timings == null) {
      throw Exception('Prayer timings payload missing timings section');
    }

    final Map<PrayerSlot, DateTime> parsed = <PrayerSlot, DateTime>{};
    for (final PrayerSlot slot in PrayerSlot.values) {
      final String fieldName = _apiFieldNames[slot]!;
      final String? raw = timings[fieldName] as String?;
      if (raw == null) {
        throw Exception('Prayer timings payload missing $fieldName');
      }
      final DateTime parsedTime = _parseTime(raw, normalized);
      parsed[slot] = parsedTime;
    }

    return PrayerDay(date: normalized, times: parsed);
  }
}

class PrayerTimesController extends ChangeNotifier {
  PrayerTimesController({PrayerTimeService? service})
    : _service = service ?? PrayerTimeService();

  final PrayerTimeService _service;
  final DateFormat _timeFormatter = DateFormat('hh:mm a');

  PrayerDay? _today;
  PrayerDay? _tomorrow;
  PrayerCountdownInfo? _countdown;
  String? _error;
  bool _isLoading = false;
  bool _isFetching = false;
  bool _initialized = false;
  bool _disposed = false;
  Timer? _ticker;
  DateTime? _lastFetchDate;

  PrayerDay? get today => _today;
  PrayerDay? get tomorrow => _tomorrow;
  PrayerCountdownInfo? get nextPrayer => _countdown;
  String? get errorMessage => _error;
  bool get isLoading => _today == null ? _isLoading : false;
  bool get isRefreshing => _isLoading;

  List<PrayerSlot> get slots => PrayerSlot.values;

  String? formattedTime(PrayerSlot slot) {
    final DateTime? time = displayTimeFor(slot);
    return time != null ? _timeFormatter.format(time) : null;
  }

  void initialize() {
    if (_initialized) {
      return;
    }
    _initialized = true;
    unawaited(_hydrateFromCache());
    refresh();
    _ensureTicker();
  }

  Future<void> refresh() async {
    await _loadFor(DateTime.now(), force: true);
  }

  Future<void> _hydrateFromCache() async {
    final DateTime now = DateTime.now();
    final PrayerDay? cachedToday = await _service.loadCachedDay(now);
    if (_disposed || cachedToday == null) {
      return;
    }
    final PrayerDay? cachedTomorrow = await _service.loadCachedDay(
      now.add(const Duration(days: 1)),
    );
    if (_disposed) {
      return;
    }

    _today = cachedToday;
    _tomorrow = cachedTomorrow;
    _lastFetchDate = _normalize(cachedToday.date);
    _isLoading = false;
    _isFetching = false;
    _error = null;
    _updateCountdown(DateTime.now());
  }

  DateTime? displayTimeFor(PrayerSlot slot) {
    if (_today == null) {
      return null;
    }
    final PrayerCountdownInfo? current = _countdown;
    if (current != null && current.slot == slot) {
      return current.time;
    }
    final DateTime? todayTime = _today!.timeFor(slot);
    if (todayTime != null) {
      return todayTime;
    }
    if (slot == PrayerSlot.fajr) {
      return _tomorrow?.timeFor(slot);
    }
    return null;
  }

  @override
  void dispose() {
    _disposed = true;
    _ticker?.cancel();
    _service.dispose();
    super.dispose();
  }

  void _ensureTicker() {
    _ticker ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) => _handleTick(),
    );
  }

  Future<void> _handleTick() async {
    if (_disposed) {
      return;
    }
    if (_today == null) {
      if (!_isFetching) {
        unawaited(_loadFor(DateTime.now(), force: true));
      }
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime normalizedNow = _normalize(now);
    if (_lastFetchDate == null || normalizedNow.isAfter(_lastFetchDate!)) {
      if (!_isFetching) {
        unawaited(_loadFor(now, force: true));
      }
      return;
    }

    _updateCountdown(now);
  }

  Future<void> _loadFor(DateTime target, {bool force = false}) async {
    if (_isFetching && !force) {
      return;
    }
    _isFetching = true;
    _isLoading = true;
    _error = null;
    if (!_disposed) {
      notifyListeners();
    }

    final DateTime normalized = _normalize(target);
    try {
      final PrayerDay today = await _service.fetchDailyTimings(normalized);
      PrayerDay? tomorrow;
      try {
        tomorrow = await _service.fetchDailyTimings(
          normalized.add(const Duration(days: 1)),
        );
      } catch (_) {
        tomorrow = null;
      }

      if (_disposed) {
        return;
      }

      _today = today;
      _tomorrow = tomorrow;
      _lastFetchDate = normalized;
      _isLoading = false;
      _isFetching = false;
      _updateCountdown(DateTime.now());
    } catch (_) {
      if (_disposed) {
        return;
      }
      _isLoading = false;
      _isFetching = false;
      _error = 'Unable to load prayer times';
      notifyListeners();
    }
  }

  void _updateCountdown(DateTime now) {
    if (_today == null) {
      return;
    }
    final PrayerCountdownInfo next = _computeNextPrayer(now);
    _countdown = next;
    if (!_disposed) {
      notifyListeners();
    }
  }

  PrayerCountdownInfo _computeNextPrayer(DateTime now) {
    final PrayerDay day = _today!;
    const List<PrayerSlot> order = <PrayerSlot>[
      PrayerSlot.fajr,
      PrayerSlot.dhuhr,
      PrayerSlot.asr,
      PrayerSlot.maghrib,
      PrayerSlot.isha,
    ];

    for (final PrayerSlot slot in order) {
      final DateTime? scheduled = day.timeFor(slot);
      if (scheduled == null) {
        continue;
      }
      if (now.isBefore(scheduled)) {
        return PrayerCountdownInfo(
          slot: slot,
          time: scheduled,
          remaining: scheduled.difference(now),
        );
      }
    }

    final PrayerDay? following = _tomorrow;
    DateTime? fallback;
    if (following != null) {
      fallback = following.timeFor(PrayerSlot.fajr);
    }
    fallback ??= day.timeFor(PrayerSlot.fajr)?.add(const Duration(days: 1));
    if (fallback == null) {
      throw StateError('Prayer times are missing mandatory slots.');
    }

    return PrayerCountdownInfo(
      slot: PrayerSlot.fajr,
      time: fallback,
      remaining: fallback.difference(now),
    );
  }
}

class PrayerTimeCache {
  static const String _prefix = 'prayer_day_';

  Future<void> write(PrayerDay day) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = _keyFor(day.date);
    final String payload = jsonEncode(day.toCacheJson());
    await prefs.setString(key, payload);
  }

  Future<PrayerDay?> read(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = _keyFor(date);
    final String? payload = prefs.getString(key);
    if (payload == null) {
      return null;
    }
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(payload) as Map<String, dynamic>;
      return PrayerDay.fromCacheJson(decoded);
    } catch (_) {
      await prefs.remove(key);
      return null;
    }
  }

  String _keyFor(DateTime date) {
    final DateTime normalized = _normalize(date);
    final String month = normalized.month.toString().padLeft(2, '0');
    final String day = normalized.day.toString().padLeft(2, '0');
    return '$_prefix${normalized.year}-$month-$day';
  }
}
