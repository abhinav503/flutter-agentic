/// Generic number-formatting helpers shared across every app.
extension PriceFormatX on num {
  /// `12.5 → '$12.50'`. The one place the currency glyph and 2-decimal rule
  /// live — app `ValueConst` formatters compose this rather than re-inlining
  /// `toStringAsFixed`.
  String get asPrice => '\$${toStringAsFixed(2)}';

  /// Whole-number rendering for percentages (`25.0 → '25'`); the suffix
  /// (`'%'`, `'% OFF'`, …) is copy and stays with the caller.
  String get asPercent => toStringAsFixed(0);
}

extension PluralX on int {
  /// `1.plural('item') → 'item'`, `0.plural('item') → 'items'`. Zero takes
  /// the plural — `0 > 1 ? 's' : ''` renders "0 item" and has already
  /// shipped as a bug once.
  String plural(String singular, [String? pluralForm]) =>
      this == 1 ? singular : (pluralForm ?? '${singular}s');
}
