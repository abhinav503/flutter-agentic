import 'package:cordelia/enums/recent_search_type.dart';
import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/entities/search_results_entity.dart';
import '../../domain/repository/search_repository.dart';
import '../data_source/search_remote_data_source.dart';

class SearchRepositoryImpl with BaseRepository implements SearchRepository {
  final SearchRemoteDataSource _dataSource;

  const SearchRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, SearchEntity>> getSearch(String storeId) =>
      handleRequest(() async {
        final model = await _dataSource.getSearch(storeId);
        return right(model.toEntity());
      });

  @override
  Future<Either<Failure, SearchResultsEntity>> searchCatalog(
    String storeId,
    String query,
  ) => handleRequest(() async {
    final model = await _dataSource.searchCatalog(storeId, query);
    return right(model.toEntity());
  });

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> addRecentSearch(
    String storeId,
    RecentSearchEntity item,
  ) => handleRequest(() async {
    final models = await _dataSource.addRecentSearch(storeId, item);
    return right(models.map((m) => m.toEntity()).toList());
  });

  @override
  Future<Either<Failure, List<RecentSearchEntity>>> removeRecentSearch({
    required String storeId,
    required String id,
    required RecentSearchType type,
  }) => handleRequest(() async {
    final models = await _dataSource.removeRecentSearch(
      storeId: storeId,
      id: id,
      type: type,
    );
    return right(models.map((m) => m.toEntity()).toList());
  });
}
