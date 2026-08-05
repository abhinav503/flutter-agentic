import 'package:core/core/extensions/date_time_extensions.dart';
import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/formatting/app_format.dart';
import 'package:flutter_test/flutter_test.dart';

/// The four languages queued behind this groundwork (de/fr/es/it) all use a
/// decimal *comma* and put the currency symbol *after* the amount — the two
/// assumptions the pre-locale formatter hardcoded. These pin both, so a later
/// refactor can't quietly reintroduce `'₹${toStringAsFixed(2)}'`.
void main() {
  setUpAll(AppFormat.init);
  tearDown(AppFormat.resetToDefaults);

  group('asPrice', () {
    test('English rupees keep the point and the leading glyph', () {
      AppFormat.apply(locale: 'en', currencyCode: 'INR');
      expect(12.5.asPrice, '₹12.50');
    });

    test('a whole amount drops its decimals', () {
      AppFormat.apply(locale: 'en', currencyCode: 'INR');
      expect(12.asPrice, '₹12');
      expect(12.0.asPrice, '₹12');
    });

    test('an amount that only displays as whole drops them too', () {
      AppFormat.apply(locale: 'en', currencyCode: 'INR');
      expect(12.001.asPrice, '₹12');
    });

    test('German euros use a comma and trail the glyph', () {
      AppFormat.apply(locale: 'de', currencyCode: 'EUR');
      final price = 1234.56.asPrice;
      expect(price, contains('1.234,56'));
      expect(price.trimRight().endsWith('€'), isTrue, reason: price);
    });

    test('Italian and Spanish group with points like German', () {
      for (final locale in ['it', 'es']) {
        AppFormat.apply(locale: locale, currencyCode: 'EUR');
        expect(1234.56.asPrice, contains('1.234,56'), reason: locale);
      }
    });

    test('French groups with a space, not a point', () {
      AppFormat.apply(locale: 'fr', currencyCode: 'EUR');
      final price = 1234.56.asPrice;
      expect(price, contains(','));
      expect(price, isNot(contains('1.234')));
    });

    // Pinned by codepoint, not by eyeballing the string: French groups with a
    // NARROW no-break space (U+202F) and separates the € with a plain no-break
    // space (U+00A0). Both are invisible in a diff, and both are characters a
    // font subset can lack — so if a price ever renders with a visible box or
    // an unexpected line break mid-number, this test names the culprits.
    test('French separators are the exact no-break codepoints', () {
      AppFormat.apply(locale: 'fr', currencyCode: 'EUR');
      expect(1234567.89.asPrice, '1 234 567,89 €');
      expect(AppFormat.decimalSeparator, ',');
    });

    test('German, Italian and Spanish group with a point', () {
      for (final locale in ['de', 'it', 'es']) {
        AppFormat.apply(locale: locale, currencyCode: 'EUR');
        expect(1234567.89.asPrice, '1.234.567,89 €', reason: locale);
      }
    });

    test('Hindi groups in lakhs', () {
      AppFormat.apply(locale: 'hi', currencyCode: 'INR');
      expect(123456.78.asPrice, contains('1,23,456'));
    });

    test('currency is independent of language', () {
      AppFormat.apply(locale: 'de', currencyCode: 'GBP');
      expect(12.5.asPrice, contains('£'));
      // A language switch inside one store keeps what that store charges in.
      AppFormat.apply(locale: 'en');
      expect(12.5.asPrice, contains('£'));
    });
  });

  group('asPriceParts', () {
    test('splits at the English point', () {
      AppFormat.apply(locale: 'en', currencyCode: 'INR');
      expect(12.5.asPriceParts, (integer: '₹12', decimals: '.50'));
    });

    test('splits at the German comma, not the thousands point', () {
      AppFormat.apply(locale: 'de', currencyCode: 'EUR');
      final parts = 1234.56.asPriceParts;
      expect(parts.integer, '1.234');
      expect(parts.decimals, startsWith(','));
    });

    test('a whole amount has no decimal run', () {
      AppFormat.apply(locale: 'de', currencyCode: 'EUR');
      expect(12.asPriceParts.decimals, isNull);
    });
  });

  group('dates', () {
    final placed = DateTime(2026, 3, 9, 10, 15);

    test('English renders a 12-hour clock', () {
      AppFormat.apply(locale: 'en');
      // CLDR joins the time to AM/PM with a narrow no-break space (U+202F),
      // not an ordinary one — asserted explicitly because a plain ' ' here
      // looks identical in a diff and would send someone hunting a
      // non-existent bug.
      expect(placed.asTime, '10:15 AM');
      expect(placed.asWeekdayDate, 'Mon, Mar 9, 2026');
    });

    test('German renders a 24-hour clock and its own month name', () {
      AppFormat.apply(locale: 'de');
      expect(placed.asTime, '10:15');
      expect(placed.monthAbbr, isNot('Mar'));
    });

    test('a 24-hour locale has no meridiem on an afternoon time', () {
      AppFormat.apply(locale: 'fr');
      final afternoon = DateTime(2026, 3, 9, 14, 30);
      expect(afternoon.asTime, contains('14'));
      expect(afternoon.asTime.toUpperCase(), isNot(contains('PM')));
    });
  });
}
