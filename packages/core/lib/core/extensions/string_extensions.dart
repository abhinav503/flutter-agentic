/// Generic `String` helpers shared across every app.
extension ImageUrlX on String {
  /// Whether this URL points at an SVG asset, so a caller can pick between
  /// [AppSvgImage.network] and [AppNetworkImage] for a URL of unknown type
  /// (e.g. a CMS/Storage-driven image field that mixes vector and raster
  /// assets). Checks the URL's path rather than the raw string so a query
  /// string (Firebase Storage's `?alt=media&token=...`) can't false-negative
  /// a real `.svg` file.
  bool get isSvgUrl =>
      Uri.tryParse(this)?.path.toLowerCase().endsWith('.svg') ?? false;
}

/// Colour strings that arrive as data — a theme config's role map, or a
/// colour an admin picked in a dashboard and stored on a record.
extension HexColorX on String {
  /// This `#RRGGBB` / `#AARRGGBB` string as an ARGB value, or null when it
  /// isn't one. Returns the `int` rather than a `Color` so a `domain` entity
  /// can carry it without importing `dart:ui`; the widget wraps it.
  ///
  /// Tolerant by design — a colour that came from user input shouldn't take
  /// a screen down, it should fall back to the default. A call site that
  /// *must* have a colour (a theme config file, where a typo should surface
  /// loudly) checks for null and throws.
  int? get hexColorArgb {
    final cleaned = replaceFirst('#', '').trim();
    if (cleaned.length != 6 && cleaned.length != 8) return null;
    final padded = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return int.tryParse(padded, radix: 16);
  }
}

/// Form-field validation predicates — the logic behind core's
/// `TextfieldValidations` mixin (`core/mixins/`), exposed separately for
/// call sites that need the predicate without the message.
extension FieldValidationX on String {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _nonDigit = RegExp(r'[^0-9]');

  bool get isValidEmail => _emailPattern.hasMatch(trim());

  /// An email address as it should be stored and sent — trimmed, and lower
  /// cased so `Sam@Example.com` and `sam@example.com` are one account
  /// rather than two. Addresses are case-insensitive in practice (the
  /// domain by spec, the mailbox by every provider that matters), and a
  /// keyboard that auto-capitalises the first letter otherwise decides
  /// which one a shopper signed up with.
  String get asEmailAddress => trim().toLowerCase();

  /// Digit count ignoring separators/spaces — for phone-number length checks
  /// (`'+91 98765-43210'.digitCount == 12`).
  int get digitCount => replaceAll(_nonDigit, '').length;
}
