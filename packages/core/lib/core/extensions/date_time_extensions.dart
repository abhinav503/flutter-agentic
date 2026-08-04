import 'package:flutter/material.dart';

/// Locale-free date/time **parts** — the pieces a bounded display format is
/// assembled from, without an `intl` dependency. Each caller (a pack's copy
/// constants, an entity's label getter) composes its own layout from these,
/// so the month table and 12-hour arithmetic live once instead of drifting
/// per copy.
extension DateTimePartsX on DateTime {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  /// `'Mar'`
  String get monthAbbr => _months[month - 1];

  /// `'Mon'`
  String get weekdayAbbr => _weekdays[weekday - 1];

  /// `'01'`
  String get dayPadded => day.toString().padLeft(2, '0');

  /// 12-hour clock hour — `12` for both midnight and noon.
  int get hour12 => hour % 12 == 0 ? 12 : hour % 12;

  /// `'05'`
  String get minutePadded => minute.toString().padLeft(2, '0');

  /// `'AM'` / `'PM'`
  String get meridiem => hour < 12 ? 'AM' : 'PM';
}

/// The standard past-window date-range picker recipe — anchor as the upper
/// bound (a record can't be dated in the future), 1 January of [yearsBack]
/// years before it as the lower.
extension DateRangePickerX on BuildContext {
  Future<DateTimeRange?> pickPastDateRange({
    required DateTime anchor,
    DateTimeRange? initial,
    int yearsBack = 1,
  }) => showDateRangePicker(
    context: this,
    firstDate: DateTime(anchor.year - yearsBack),
    lastDate: anchor,
    initialDateRange: initial,
  );
}
