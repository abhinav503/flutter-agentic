import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/review_entity.dart';
import '../repository/reviews_repository.dart';

class SubmitProductReviewParams {
  final String storeId;
  final String productId;
  final int rating;
  final String text;

  const SubmitProductReviewParams({
    required this.storeId,
    required this.productId,
    required this.rating,
    required this.text,
  });
}

/// Posting again replaces the shopper's existing review, so this covers both
/// writing and editing — there is no separate update use case.
class SubmitProductReviewUseCase
    extends UseCase<Either<Failure, ReviewEntity>, SubmitProductReviewParams> {
  final ReviewsRepository _repository;
  const SubmitProductReviewUseCase(this._repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(
    SubmitProductReviewParams params,
  ) => _repository.submitReview(
    storeId: params.storeId,
    productId: params.productId,
    rating: params.rating,
    text: params.text,
  );
}
