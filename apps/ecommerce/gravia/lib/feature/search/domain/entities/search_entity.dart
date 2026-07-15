import '../../../home/domain/entities/product_entity.dart';

/// Reuses [ProductEntity] rather than a duplicate — both "Recent Search" and
/// the Search screen's "Popular Items" section are the same product concept
/// as Home's, just fetched through this feature's own repository/mock.
class SearchEntity {
  final List<ProductEntity> recentSearches;
  final List<ProductEntity> popularProducts;

  const SearchEntity({
    required this.recentSearches,
    required this.popularProducts,
  });

  SearchEntity copyWith({List<ProductEntity>? recentSearches}) => SearchEntity(
        recentSearches: recentSearches ?? this.recentSearches,
        popularProducts: popularProducts,
      );
}
