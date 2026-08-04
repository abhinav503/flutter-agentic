import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/product_reviews_entity.dart';
import '../repository/reviews_repository.dart';

class GetProductReviewsParams {
  final String storeId;
  final String productId;
  const GetProductReviewsParams({
    required this.storeId,
    required this.productId,
  });
}

class GetProductReviewsUseCase
    extends
        UseCase<
          Either<Failure, ProductReviewsEntity>,
          GetProductReviewsParams
        > {
  final ReviewsRepository _repository;
  const GetProductReviewsUseCase(this._repository);

  @override
  Future<Either<Failure, ProductReviewsEntity>> call(
    GetProductReviewsParams params,
  ) => _repository.getProductReviews(params.storeId, params.productId);
}
