import '../../../home/domain/entities/product_entity.dart';
import 'recent_search_entity.dart';

/// Popular items reuse [ProductEntity] rather than a duplicate — the Search
/// screen's "Popular Items" section is the same product concept as Home's.
/// Recent searches are [RecentSearchEntity] (product OR category), since the
/// shopper can tap either kind of search result.
class SearchEntity {
  final List<RecentSearchEntity> recentSearches;
  final List<ProductEntity> popularProducts;

  const SearchEntity({
    required this.recentSearches,
    required this.popularProducts,
  });

  SearchEntity copyWith({List<RecentSearchEntity>? recentSearches}) =>
      SearchEntity(
        recentSearches: recentSearches ?? this.recentSearches,
        popularProducts: popularProducts,
      );
}
