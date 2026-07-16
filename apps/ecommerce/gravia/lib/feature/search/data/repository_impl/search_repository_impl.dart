import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/search_entity.dart';
import '../../domain/repository/search_repository.dart';
import '../data_source/search_remote_data_source.dart';

class SearchRepositoryImpl with BaseRepository implements SearchRepository {
  final SearchRemoteDataSource _dataSource;

  const SearchRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, SearchEntity>> getSearch() => handleRequest(() async {
    final model = await _dataSource.getSearch();
    return right(model.toEntity());
  });
}
