import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
}

class CalendarService {
  CalendarService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

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

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load calendar data (${response.statusCode})');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['data'] as List<dynamic>?;
    if (data == null || data.isEmpty) {
      throw Exception('Calendar response was empty');
    }

    final days = data
        .map((entry) => CalendarDay.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);

    return CalendarMonthData(month: focus, days: days);
  }

  void dispose() {
    _client.close();
  }
}
