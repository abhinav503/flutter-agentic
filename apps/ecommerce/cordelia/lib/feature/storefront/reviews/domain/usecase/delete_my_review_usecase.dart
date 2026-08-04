import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/reviews_repository.dart';

class DeleteMyReviewParams {
  final String storeId;
  final String productId;
  const DeleteMyReviewParams({required this.storeId, required this.productId});
}

class DeleteMyReviewUseCase
    extends UseCase<Either<Failure, void>, DeleteMyReviewParams> {
  final ReviewsRepository _repository;
  const DeleteMyReviewUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteMyReviewParams params) =>
      _repository.deleteMyReview(params.storeId, params.productId);
}
