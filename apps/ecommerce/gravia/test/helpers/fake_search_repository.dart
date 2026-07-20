import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/enums/recent_search_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/feature/search/domain/entities/recent_search_entity.dart';
import 'package:gravia/feature/search/domain/entities/search_entity.dart';
import 'package:gravia/feature/search/domain/entities/search_results_entity.dart';
import 'package:gravia/feature/search/domain/repository/search_repository.dart';

class FakeSearchRepository implements SearchRepository {
  /// Set per test to control what [getSearch] resolves to.
  Either<Failure, SearchEntity> result = right(
    const SearchEntity(
      recentSearches: [
        RecentSearchEntity(
          id: '1',
          name: 'Washington Red Apple',
          type: RecentSearchType.product,
        ),
        RecentSearchEntity(
          id: '4',
          name: 'Cabbage',
          type: RecentSearchType.product,
        ),
      ],
      popularProducts: [
        ProductEntity(
          id: '2',
          name: 'Green Grapes',
          imageUrl: 'https://example.com/grapes.png',
          price: 4.00,
          originalPrice: 5.00,
          discountPercentage: 20,
          unitValue: 500,
          unitType: ProductUnitType.grams,
          prepTime: '10 Min',
          isFavourite: false,
        ),
      ],
    ),
  );

  /// Set per test to control what [searchCatalog] resolves to.
  Either<Failure, SearchResultsEntity> searchResult = right(
    const SearchResultsEntity(products: [], categories: []),
  );

  /// Set per test to control what both recents mutations resolve to.
  Either<Failure, List<RecentSearchEntity>> recentsResult = right(const []);

  String? lastQuery;
  RecentSearchEntity? lastAdded;
  ({String id, RecentSearchType type})? lastRemoved;

  @override
  Future<Either<Failure, SearchEntity>> getSearch() async => result;

  @override
  Future<Either<Failure, SearchResultsEntity>> searchCatalog(
    String query,
  ) async {
    lastQuery = query;
    return searchResult;
  }

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> addRecentSearch(
    RecentSearchEntity item,
  ) async {
    lastAdded = item;
    return recentsResult;
  }

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> removeRecentSearch({
    required String id,
    required RecentSearchType type,
  }) async {
    lastRemoved = (id: id, type: type);
    return recentsResult;
  }
}
