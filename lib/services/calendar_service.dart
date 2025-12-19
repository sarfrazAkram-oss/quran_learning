import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarDay {
  CalendarDay({
    required this.gregorianDate,
    required this.gregorianWeekday,
    required this.gregorianMonthName,
    required this.hijriDay,
    required this.hijriMonthName,
    required this.hijriYear,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    final gregorian = json['date']['gregorian'] as Map<String, dynamic>;
    final hijri = json['date']['hijri'] as Map<String, dynamic>;

    final gregDateRaw = gregorian['date'] as String; // dd-MM-yyyy
    final date = DateFormat('dd-MM-yyyy').parse(gregDateRaw);

    return CalendarDay(
      gregorianDate: DateTime(date.year, date.month, date.day),
      gregorianWeekday:
          (gregorian['weekday'] as Map<String, dynamic>)['en'] as String,
      gregorianMonthName:
          (gregorian['month'] as Map<String, dynamic>)['en'] as String,
      hijriDay: hijri['day'] as String,
      hijriMonthName: (hijri['month'] as Map<String, dynamic>)['en'] as String,
      hijriYear: hijri['year'] as String,
    );
  }

  final DateTime gregorianDate;
  final String gregorianWeekday;
  final String gregorianMonthName;
  final String hijriDay;
  final String hijriMonthName;
  final String hijriYear;

  String get gregorianLabel =>
      '$gregorianWeekday, ${gregorianDate.day} $gregorianMonthName ${gregorianDate.year}';

  String get hijriLabel => '$hijriMonthName $hijriDay, $hijriYear';

  DateTime get key =>
      DateTime(gregorianDate.year, gregorianDate.month, gregorianDate.day);

  bool get isToday => DateUtils.isSameDay(gregorianDate, DateTime.now());

  Map<String, dynamic> toCacheJson() => <String, dynamic>{
    'gregorianDate': gregorianDate.toIso8601String(),
    'gregorianWeekday': gregorianWeekday,
    'gregorianMonthName': gregorianMonthName,
    'hijriDay': hijriDay,
    'hijriMonthName': hijriMonthName,
    'hijriYear': hijriYear,
  };

  factory CalendarDay.fromCacheJson(Map<String, dynamic> json) {
    final String? rawDate = json['gregorianDate'] as String?;
    if (rawDate == null) {
      throw FormatException('Cached calendar day missing gregorianDate');
    }
    final String? weekday = json['gregorianWeekday'] as String?;
    final String? monthName = json['gregorianMonthName'] as String?;
    final String? hijriDayValue = json['hijriDay'] as String?;
    final String? hijriMonthValue = json['hijriMonthName'] as String?;
    final String? hijriYearValue = json['hijriYear'] as String?;
    if (weekday == null ||
        monthName == null ||
        hijriDayValue == null ||
        hijriMonthValue == null ||
        hijriYearValue == null) {
      throw FormatException('Cached calendar day missing fields');
    }

    final DateTime parsed = DateTime.parse(rawDate);
    return CalendarDay(
      gregorianDate: DateTime(parsed.year, parsed.month, parsed.day),
      gregorianWeekday: weekday,
      gregorianMonthName: monthName,
      hijriDay: hijriDayValue,
      hijriMonthName: hijriMonthValue,
      hijriYear: hijriYearValue,
    );
  }
}

class CalendarMonthData {
  CalendarMonthData({required this.month, required List<CalendarDay> days})
    : _daysByDate = {for (final day in days) day.key: day};

  final DateTime month;
  final Map<DateTime, CalendarDay> _daysByDate;

  Iterable<CalendarDay> get days => _daysByDate.values;

  CalendarDay? dayFor(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _daysByDate[key];
  }

  CalendarDay? get today => dayFor(DateTime.now());

  String get gregorianMonthLabel => DateFormat('MMMM yyyy').format(month);

  String? get hijriMonthLabel {
    final first = days.isNotEmpty ? days.first : null;
    return first != null ? '${first.hijriMonthName} ${first.hijriYear}' : null;
  }

  Map<String, dynamic> toCacheJson() => <String, dynamic>{
    'month': DateTime(month.year, month.month).toIso8601String(),
    'days': days
        .map((CalendarDay day) => day.toCacheJson())
        .toList(growable: false),
  };

  factory CalendarMonthData.fromCacheJson(Map<String, dynamic> json) {
    final String? rawMonth = json['month'] as String?;
    if (rawMonth == null) {
      throw FormatException('Cached calendar month missing month field');
    }
    final List<dynamic>? rawDays = json['days'] as List<dynamic>?;
    if (rawDays == null) {
      throw FormatException('Cached calendar month missing days');
    }
    final DateTime parsedMonth = DateTime.parse(rawMonth);
    final List<CalendarDay> parsedDays = rawDays
        .map(
          (dynamic entry) =>
              CalendarDay.fromCacheJson(entry as Map<String, dynamic>),
        )
        .toList(growable: false);

    return CalendarMonthData(
      month: DateTime(parsedMonth.year, parsedMonth.month),
      days: parsedDays,
    );
  }
}

class CalendarService {
  CalendarService({http.Client? client, CalendarCache? cache})
    : _client = client ?? http.Client(),
      _cache = cache ?? CalendarCache();

  final http.Client _client;
  final CalendarCache _cache;

  Future<CalendarMonthData> fetchMonth(DateTime date) async {
    final focus = DateTime(date.year, date.month);
    final uri = Uri.https('api.aladhan.com', '/v1/calendar', <String, String>{
      'latitude':
          '21.4225', // Default to Makkah coordinates for accurate Hijri dates
      'longitude': '39.8262',
      'method': '2',
      'month': focus.month.toString(),
      'year': focus.year.toString(),
    });

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load calendar data (${response.statusCode})',
        );
      }

      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final data = payload['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) {
        throw Exception('Calendar response was empty');
      }

      final days = data
          .map((entry) => CalendarDay.fromJson(entry as Map<String, dynamic>))
          .toList(growable: false);

      final CalendarMonthData result = CalendarMonthData(
        month: focus,
        days: days,
      );
      await _cache.write(result);
      return result;
    } catch (error) {
      final CalendarMonthData? cached = await _cache.read(focus);
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}

class CalendarCache {
  static const String _prefix = 'calendar_month_';

  Future<void> write(CalendarMonthData data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = _keyFor(data.month);
    final String payload = jsonEncode(data.toCacheJson());
    await prefs.setString(key, payload);
  }

  Future<CalendarMonthData?> read(DateTime date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = _keyFor(date);
    final String? payload = prefs.getString(key);
    if (payload == null) {
      return null;
    }
    try {
      final Map<String, dynamic> decoded =
          jsonDecode(payload) as Map<String, dynamic>;
      return CalendarMonthData.fromCacheJson(decoded);
    } catch (_) {
      await prefs.remove(key);
      return null;
    }
  }

  String _keyFor(DateTime date) {
    final DateTime normalized = DateTime(date.year, date.month);
    final String month = normalized.month.toString().padLeft(2, '0');
    return '$_prefix${normalized.year}-$month';
  }
}
