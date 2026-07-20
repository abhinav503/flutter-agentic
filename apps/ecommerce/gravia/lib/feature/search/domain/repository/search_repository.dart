import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/enums/recent_search_type.dart';

import '../entities/recent_search_entity.dart';
import '../entities/search_entity.dart';
import '../entities/search_results_entity.dart';

abstract interface class SearchRepository {
  Future<Either<Failure, SearchEntity>> getSearch();
  Future<Either<Failure, SearchResultsEntity>> searchCatalog(String query);

  /// Both mutations resolve to the server's updated recents list.
  Future<Either<Failure, List<RecentSearchEntity>>> addRecentSearch(
    RecentSearchEntity item,
  );
  Future<Either<Failure, List<RecentSearchEntity>>> removeRecentSearch({
    required String id,
    required RecentSearchType type,
  });
}
