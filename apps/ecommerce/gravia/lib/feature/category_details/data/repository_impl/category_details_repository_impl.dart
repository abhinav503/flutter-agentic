import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/category_details_entity.dart';
import '../../domain/repository/category_details_repository.dart';
import '../data_source/category_details_remote_data_source.dart';

class CategoryDetailsRepositoryImpl with BaseRepository implements CategoryDetailsRepository {
  final CategoryDetailsRemoteDataSource _dataSource;

  const CategoryDetailsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, CategoryDetailsEntity>> getCategoryDetails(String categoryId) =>
      handleRequest(() async {
        final model = await _dataSource.getCategoryDetails(categoryId);
        return right(model.toEntity());
      });
}
