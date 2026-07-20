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

/// Form-field validation predicates — the logic behind core's
/// `TextfieldValidations` mixin (`core/mixins/`), exposed separately for
/// call sites that need the predicate without the message.
extension FieldValidationX on String {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _nonDigit = RegExp(r'[^0-9]');

  bool get isValidEmail => _emailPattern.hasMatch(trim());

  /// Digit count ignoring separators/spaces — for phone-number length checks
  /// (`'+91 98765-43210'.digitCount == 12`).
  int get digitCount => replaceAll(_nonDigit, '').length;
}
