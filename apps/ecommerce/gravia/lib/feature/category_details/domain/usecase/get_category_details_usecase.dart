import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/category_details_entity.dart';
import '../repository/category_details_repository.dart';

class GetCategoryDetailsParams {
  final String categoryId;
  const GetCategoryDetailsParams({required this.categoryId});
}

class GetCategoryDetailsUseCase
    extends UseCase<Either<Failure, CategoryDetailsEntity>, GetCategoryDetailsParams> {
  final CategoryDetailsRepository _repository;
  const GetCategoryDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryDetailsEntity>> call(GetCategoryDetailsParams params) =>
      _repository.getCategoryDetails(params.categoryId);
}
