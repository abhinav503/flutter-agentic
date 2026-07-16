import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/categories_entity.dart';
import '../../domain/repository/categories_repository.dart';
import '../data_source/categories_remote_data_source.dart';

class CategoriesRepositoryImpl
    with BaseRepository
    implements CategoriesRepository {
  final CategoriesRemoteDataSource _dataSource;

  const CategoriesRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, CategoriesEntity>> getCategories() =>
      handleRequest(() async {
        final model = await _dataSource.getCategories();
        return right(model.toEntity());
      });
}
