import '../../../home/domain/entities/product_entity.dart';

/// Reuses [ProductEntity] rather than a duplicate — the Search screen's
/// "Popular Items" section is the same concept as Home's, just fetched
/// through this feature's own repository/mock.
class SearchEntity {
  final List<String> recentSearches;
  final List<ProductEntity> popularProducts;

  const SearchEntity({
    required this.recentSearches,
    required this.popularProducts,
  });

  SearchEntity copyWith({List<String>? recentSearches}) => SearchEntity(
        recentSearches: recentSearches ?? this.recentSearches,
        popularProducts: popularProducts,
      );
}
