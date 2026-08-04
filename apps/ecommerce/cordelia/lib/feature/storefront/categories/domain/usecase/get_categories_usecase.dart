import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/categories_entity.dart';
import '../repository/categories_repository.dart';

class GetCategoriesParams {
  final String storeId;

  const GetCategoriesParams({required this.storeId});
}

class GetCategoriesUseCase
    extends UseCase<Either<Failure, CategoriesEntity>, GetCategoriesParams> {
  final CategoriesRepository _repository;

  const GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, CategoriesEntity>> call(GetCategoriesParams params) =>
      _repository.getCategories(params.storeId);
}
