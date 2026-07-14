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
