import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:core/core/formatting/app_format.dart';

/// Date/time renderings in the active locale ([AppFormat]) — whole formats
/// rather than parts, because the pieces don't survive translation: German,
/// French, Spanish and Italian all put the day before the month and read the
/// clock in 24 hours, so a caller concatenating `month day, year` and an
/// `AM`/`PM` produces an English sentence with translated words in it.
///
/// Each getter names a CLDR skeleton, so the *order* of the pieces is the
/// locale's to decide, not the call site's.
extension DateTimePartsX on DateTime {
  /// `'Mon, Mar 9, 2026'` · de: `'Mo., 9. März 2026'`
  String get asWeekdayDate => DateFormat.yMMMEd(AppFormat.locale).format(this);

  /// `'Mar 9, 2026'` · de: `'09.03.2026'`
  String get asCompactDate => DateFormat.yMMMd(AppFormat.locale).format(this);

  /// `'10:15 AM'` · de: `'10:15'` — the locale decides 12- vs 24-hour.
  String get asTime => DateFormat.jm(AppFormat.locale).format(this);

  /// [asWeekdayDate] and [asTime] joined the way the locale joins them.
  /// Prefer this over interpolating the two with a connector: " at " is
  /// English copy, and the locale may also want a different piece order.
  String get asDateTimeLabel =>
      DateFormat.yMMMEd(AppFormat.locale).add_jm().format(this);

  /// `'Mar'` · de: `'März'` — only for a caller that genuinely needs the
  /// month alone (a calendar heading). A caller assembling a full date wants
  /// one of the skeletons above instead.
  String get monthAbbr => DateFormat.MMM(AppFormat.locale).format(this);

  /// `'Mon'` · de: `'Mo.'`
  String get weekdayAbbr => DateFormat.E(AppFormat.locale).format(this);

  /// `'01'` — zero-padded day of month, no locale involved.
  String get dayPadded => day.toString().padLeft(2, '0');
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
