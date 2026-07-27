/// What kind of catalog item a recent search points at — decides which
/// details page a tap deep-links to (product details vs category details).
enum RecentSearchType { product, category }

extension RecentSearchTypeX on RecentSearchType {
  /// Enum → wire value, for the data layer's model-to-JSON mapping.
  String get wireValue => switch (this) {
    RecentSearchType.product => 'product',
    RecentSearchType.category => 'category',
  };
}

/// Wire value → enum: tolerates unknown values by defaulting to product —
/// worst case a stale entry opens a product-details error view, not a crash.
extension RecentSearchTypeParse on String {
  RecentSearchType toRecentSearchType() => switch (this) {
    'category' => RecentSearchType.category,
    _ => RecentSearchType.product,
  };
}
