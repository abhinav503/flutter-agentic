/// Generic number-formatting helpers shared across every app.
extension PriceFormatX on num {
  /// `12.5 → '$12.50'`, `12 → '$12'`. The one place the currency glyph and
  /// decimal rule live — app `ValueConst` formatters compose this rather than
  /// re-inlining `toStringAsFixed`.
  ///
  /// A whole amount drops its decimals entirely; anything else keeps both, so
  /// a price never shows a lone digit after the point. `$12.00` reads as a
  /// number a machine wrote, and only the round prices in a catalog would
  /// carry it.
  String get asPrice {
    final fixed = toStringAsFixed(2);
    return '\$${fixed.endsWith('.00') ? fixed.substring(0, fixed.length - 3) : fixed}';
  }

  /// Whole-number rendering for percentages (`25.0 → '25'`); the suffix
  /// (`'%'`, `'% OFF'`, …) is copy and stays with the caller.
  String get asPercent => toStringAsFixed(0);

  /// [asPrice] split at the decimal point — for typography that renders the
  /// integer part large and the decimals small (`12.5 → ('$12', '.50')`;
  /// `12 → ('$12', null)`, matching [asPrice]'s whole-amount rule). Splitting
  /// the formatted string here keeps the two renderings from ever disagreeing
  /// with each other.
  ({String integer, String? decimals}) get asPriceParts {
    final price = asPrice;
    final dot = price.indexOf('.');
    return dot == -1
        ? (integer: price, decimals: null)
        : (integer: price.substring(0, dot), decimals: price.substring(dot));
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
