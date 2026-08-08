import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/formatting/app_format.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/template/store_currency.dart';

/// Price-range bucket for Category Details' "Price" filter sheet. Used purely
/// in-memory, same reasoning as [ProductSortOption] — so the cases are named
/// for their *position* between the band edges, not for the edges themselves.
/// The numbers are per-currency (see [StoreCurrencyPriceBandsX]); an enum case
/// called `under100` would have been a lie at a euro store.
enum ProductPriceFilter { all, underLow, lowToMid, midToHigh, overHigh }

/// The three edges that split a catalog into [ProductPriceFilter]'s four
/// bands.
///
/// **Not converted between currencies — these are filter-usability numbers,
/// not an exchange rate.** ₹100 and €1 are roughly the same money, but a €1
/// edge would leave almost every European grocery item in one band, which is a
/// filter that filters nothing. Each set is picked to cut that market's
/// catalog into four groups a shopper would actually choose between.
///
/// Lives beside the filter rather than beside [StoreCurrency] because the
/// numbers mean nothing outside it — the same reasoning that puts
/// `StoreLanguageLocaleX` in the l10n layer instead of next to its enum.
extension StoreCurrencyPriceBandsX on StoreCurrency {
  ({num low, num mid, num high}) get priceBands => switch (this) {
    // Tuned to the seeded Indian grocery catalog, where a typical item is
    // ₹20–₹500.
    StoreCurrency.inr => (low: 100, mid: 250, high: 500),
    // A European/UK/US grocery item clusters around 1–10: milk ~2, cheese ~5,
    // oil ~8. The same three edges serve all three, since none of these
    // markets prices everyday groceries an order of magnitude apart.
    StoreCurrency.eur => (low: 2, mid: 5, high: 10),
    StoreCurrency.gbp => (low: 2, mid: 5, high: 10),
    StoreCurrency.usd => (low: 2, mid: 5, high: 10),
  };
}

extension ProductPriceFilterX on ProductPriceFilter {
  /// The active store's band edges.
  ///
  /// Read ambiently from [AppFormat] — the same source `asPrice` formats
  /// against — rather than threaded in as a parameter. That is deliberate:
  /// [label] renders the edges and [matches] tests against them, so two
  /// sources would let a band advertise "Under €2" while filtering at ₹100.
  /// One accessor makes that divergence unrepresentable.
  static ({num low, num mid, num high}) get _bands =>
      AppFormat.currencyCode.toStoreCurrency().priceBands;

  /// App-wide wording (not per-pack) — see [ProductSortOptionX.label]. The
  /// edges arrive already formatted, so the glyph and separators follow the
  /// store's currency and the shopper's locale.
  String get label {
    final bands = _bands;
    return switch (this) {
      ProductPriceFilter.all => ValueConst.priceFilterAllLabel,
      ProductPriceFilter.underLow => ValueConst.priceFilterUnderLabel(
        bands.low.asPrice,
      ),
      ProductPriceFilter.lowToMid => ValueConst.priceFilterRangeLabel(
        bands.low.asPrice,
        bands.mid.asPrice,
      ),
      ProductPriceFilter.midToHigh => ValueConst.priceFilterRangeLabel(
        bands.mid.asPrice,
        bands.high.asPrice,
      ),
      ProductPriceFilter.overHigh => ValueConst.priceFilterOverLabel(
        bands.high.asPrice,
      ),
    };
  }

  /// The bands tile the number line with no gap and no overlap — every price
  /// falls in exactly one, which is what lets the sheet present them as a
  /// single-select list. Note the asymmetric edges: the lower band is open
  /// below and the rest close on their upper edge, so a price sitting exactly
  /// on an edge belongs to the band beneath it.
  bool matches(double price) {
    final bands = _bands;
    return switch (this) {
      ProductPriceFilter.all => true,
      ProductPriceFilter.underLow => price < bands.low,
      ProductPriceFilter.lowToMid => price >= bands.low && price <= bands.mid,
      ProductPriceFilter.midToHigh => price > bands.mid && price <= bands.high,
      ProductPriceFilter.overHigh => price > bands.high,
    };
  }
}
