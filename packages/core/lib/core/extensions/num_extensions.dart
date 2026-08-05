import 'package:core/core/formatting/app_format.dart';

/// Generic number-formatting helpers shared across every app.
extension PriceFormatX on num {
  /// The active locale + currency ([AppFormat]) applied to this amount —
  /// `12.5 → '₹12.50'` in English rupees, `'12,50 €'` in German euros. The
  /// one place a price is rendered; app `ValueConst` formatters compose this
  /// rather than re-inlining `toStringAsFixed`, which would bake in a decimal
  /// point and a symbol side that four of our five languages disagree with.
  ///
  /// A whole amount drops its decimals entirely; anything else keeps both, so
  /// a price never shows a lone digit after the separator. `₹12.00` reads as
  /// a number a machine wrote, and only the round prices in a catalog would
  /// carry it.
  String get asPrice {
    // Rounded first, so an amount that only *displays* as whole (12.001)
    // takes the decimal-less form too — the pre-locale behaviour, which
    // tested `toStringAsFixed(2).endsWith('.00')`.
    final isWhole = (this * 100).round() % 100 == 0;
    return AppFormat.money(whole: isWhole).format(this);
  }

  /// Whole-number rendering for percentages (`25.0 → '25'`); the suffix
  /// (`'%'`, `'% OFF'`, …) is copy and stays with the caller.
  ///
  /// Deliberately not locale-formatted: a percentage is a bare 0–100 integer,
  /// so it has no decimal separator to get wrong and no grouping to apply.
  String get asPercent => toStringAsFixed(0);

  /// The locale-aware `toStringAsFixed` — `4.6 → '4.6'` in English, `'4,6'` in
  /// German. For a bare number that isn't money: a rating average, a weight.
  /// Reach for this instead of `toStringAsFixed`, which always emits a point.
  String asDecimal([int fractionDigits = 1]) =>
      AppFormat.decimal(fractionDigits).format(this);

  /// [asPrice] split at the active locale's decimal separator — for
  /// typography that renders the integer part large and the decimals small
  /// (`12.5 → ('₹12', '.50')`; `12 → ('₹12', null)`, matching [asPrice]'s
  /// whole-amount rule). Splitting the formatted string, rather than
  /// formatting each part, keeps the two renderings from ever disagreeing.
  ///
  /// In a suffix-symbol locale the glyph rides along with the decimals
  /// (`'1.234'` + `',56 €'`), because that is where the locale puts it — the
  /// small run is cents-and-symbol rather than cents alone.
  ({String integer, String? decimals}) get asPriceParts {
    final price = asPrice;
    // lastIndexOf: in a locale whose group separator is '.', an earlier '.'
    // is thousands, not the decimal mark.
    final split = price.lastIndexOf(AppFormat.decimalSeparator);
    return split == -1
        ? (integer: price, decimals: null)
        : (integer: price.substring(0, split), decimals: price.substring(split));
  }
}

extension HexColorValueX on int {
  /// This ARGB value back as a colour string — the inverse of
  /// `String.hexColorArgb` (`core/extensions/string_extensions.dart`), for a
  /// `*Model` writing a picked colour back to the wire. Opaque colours drop
  /// the alpha pair, since that's the form a colour picker produces.
  String get asHexColor {
    final hex = toRadixString(16).padLeft(8, '0').toUpperCase();
    return hex.startsWith('FF') ? '#${hex.substring(2)}' : '#$hex';
  }
}

extension PluralX on int {
  /// `1.plural('item') → 'item'`, `0.plural('item') → 'items'`. Zero takes
  /// the plural — `0 > 1 ? 's' : ''` renders "0 item" and has already
  /// shipped as a bug once.
  String plural(String singular, [String? pluralForm]) =>
      this == 1 ? singular : (pluralForm ?? '${singular}s');
}
