import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/product_detail_entity.dart';
import '../repository/product_details_repository.dart';

class GetProductDetailsParams {
  final String productId;
  const GetProductDetailsParams({required this.productId});
}

class GetProductDetailsUseCase
    extends
        UseCase<Either<Failure, ProductDetailEntity>, GetProductDetailsParams> {
  final ProductDetailsRepository _repository;
  const GetProductDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, ProductDetailEntity>> call(
    GetProductDetailsParams params,
  ) => _repository.getProductDetails(params.productId);
}
