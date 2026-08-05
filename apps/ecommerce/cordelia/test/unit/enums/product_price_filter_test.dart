import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/formatting/app_format.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cordelia/enums/product_price_filter.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';

void main() {
  setUpAll(AppFormat.init);
  tearDown(AppFormat.resetToDefaults);

  /// The four real bands; `all` is the "no filter" escape hatch and is excluded
  /// from the partition checks because it deliberately overlaps every band.
  final bands = ProductPriceFilter.values
      .where((f) => f != ProductPriceFilter.all)
      .toList();

  group('band edges are per currency', () {
    test('rupees keep the catalog-tuned edges', () {
      expect(StoreCurrency.inr.priceBands, (low: 100, mid: 250, high: 500));
    });

    test('the western currencies use grocery-scale edges, not converted ones', () {
      // ₹100 ≈ €1, but a €1 edge would put nearly every item in one band. The
      // point of this task was that the *numbers* had to change, not just their
      // formatting.
      for (final currency in [
        StoreCurrency.eur,
        StoreCurrency.gbp,
        StoreCurrency.usd,
      ]) {
        expect(currency.priceBands, (low: 2, mid: 5, high: 10),
            reason: currency.name);
      }
    });

    test('every currency has strictly increasing edges', () {
      for (final currency in StoreCurrency.values) {
        final b = currency.priceBands;
        expect(b.low, lessThan(b.mid), reason: currency.name);
        expect(b.mid, lessThan(b.high), reason: currency.name);
      }
    });
  });

  group('the bands tile the number line', () {
    for (final currency in StoreCurrency.values) {
      test('${currency.wireValue}: every price lands in exactly one band', () {
        AppFormat.apply(locale: 'en', currencyCode: currency.wireValue);
        final b = currency.priceBands;

        // Probes straddle each edge, because an off-by-one in the comparison
        // operators is exactly how a gap (a price matching nothing) or an
        // overlap (a price in two bands) gets introduced.
        final probes = <double>[
          0,
          b.low - 0.01,
          b.low.toDouble(),
          (b.low + b.mid) / 2,
          b.mid.toDouble(),
          b.mid + 0.01,
          b.high.toDouble(),
          b.high + 0.01,
          b.high * 2,
        ];

        for (final price in probes) {
          final matching = bands.where((f) => f.matches(price)).toList();
          expect(
            matching,
            hasLength(1),
            reason: '$price matched ${matching.length} bands: '
                '${matching.map((f) => f.name).join(", ")}',
          );
        }
      });

      test('${currency.wireValue}: "all" matches every probe', () {
        AppFormat.apply(locale: 'en', currencyCode: currency.wireValue);
        final b = currency.priceBands;
        for (final price in [0.0, b.low.toDouble(), b.high * 3.0]) {
          expect(ProductPriceFilter.all.matches(price), isTrue);
        }
      });
    }
  });

  group('a label cannot disagree with its own predicate', () {
    // The failure this guards: label reading one currency's edges while
    // matches() reads another's, so a chip says "Under €2" and filters at ₹100.
    // Both go through the same ambient accessor, and this proves it for every
    // currency rather than trusting that they were wired to the same place.
    for (final currency in StoreCurrency.values) {
      test('${currency.wireValue}: labels print the edges used to filter', () {
        AppFormat.apply(locale: 'en', currencyCode: currency.wireValue);
        final b = currency.priceBands;

        expect(
          ProductPriceFilter.underLow.label,
          contains(b.low.asPrice),
          reason: 'the "under" chip must name the edge it filters below',
        );
        expect(ProductPriceFilter.lowToMid.label, contains(b.low.asPrice));
        expect(ProductPriceFilter.lowToMid.label, contains(b.mid.asPrice));
        expect(ProductPriceFilter.midToHigh.label, contains(b.mid.asPrice));
        expect(ProductPriceFilter.midToHigh.label, contains(b.high.asPrice));
        expect(ProductPriceFilter.overHigh.label, contains(b.high.asPrice));
      });
    }

    test('switching the store currency moves both the label and the filter', () {
      AppFormat.apply(locale: 'en', currencyCode: 'INR');
      expect(ProductPriceFilter.underLow.label, contains('₹100'));
      // ₹150 is mid-catalog in rupees…
      expect(ProductPriceFilter.underLow.matches(150), isFalse);

      AppFormat.apply(locale: 'de', currencyCode: 'EUR');
      expect(ProductPriceFilter.underLow.label, contains('2'));
      expect(ProductPriceFilter.underLow.label, contains('€'));
      // …and far above every euro band, so it lands in the top one instead of
      // silently matching a rupee-sized rule.
      expect(ProductPriceFilter.underLow.matches(150), isFalse);
      expect(ProductPriceFilter.overHigh.matches(150), isTrue);
    });

    test('a euro price a rupee catalog would call cheap is now banded', () {
      // The concrete bug: at a euro store every product used to fall in
      // "Under ₹100", making the filter inert.
      AppFormat.apply(locale: 'de', currencyCode: 'EUR');
      expect(ProductPriceFilter.underLow.matches(1.20), isTrue); // milk
      expect(ProductPriceFilter.lowToMid.matches(4.50), isTrue); // cheese
      expect(ProductPriceFilter.midToHigh.matches(8.00), isTrue); // oil
      expect(ProductPriceFilter.overHigh.matches(14.00), isTrue); // wine
    });
  });
}
