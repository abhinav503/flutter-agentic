/// What tapping a promo banner opens — decides which details page the
/// storefront deep-links to, or that the banner is display-only.
enum BannerTargetType { none, product, category }

extension BannerTargetTypeX on BannerTargetType {
  /// Enum → wire value, for the data layer's model-to-JSON mapping.
  String get wireValue => switch (this) {
    BannerTargetType.none => 'none',
    BannerTargetType.product => 'product',
    BannerTargetType.category => 'category',
  };
}

/// Wire value → enum: an unrecognized target (a kind this build predates)
/// degrades to a non-tappable banner rather than a dead or wrong link.
extension BannerTargetTypeParse on String {
  BannerTargetType toBannerTargetType() => switch (this) {
    'product' => BannerTargetType.product,
    'category' => BannerTargetType.category,
    _ => BannerTargetType.none,
  };
}
