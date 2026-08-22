import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import 'package:cordelia/enums/review_report_reason.dart';
import '../repository/reviews_repository.dart';

class ReportReviewParams {
  final String storeId;
  final String productId;

  /// The review's author — a review's id is its author's uid.
  final String reviewUid;
  final ReviewReportReason reason;

  /// Hide this author's reviews from the reporter as well. Offered on the
  /// same sheet because a shopper who has read enough of someone shouldn't
  /// have to find a second control.
  final bool block;

  const ReportReviewParams({
    required this.storeId,
    required this.productId,
    required this.reviewUid,
    required this.reason,
    required this.block,
  });
}

class ReportReviewUseCase
    extends UseCase<Either<Failure, void>, ReportReviewParams> {
  final ReviewsRepository _repository;

  const ReportReviewUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ReportReviewParams params) =>
      _repository.reportReview(
        storeId: params.storeId,
        productId: params.productId,
        reviewUid: params.reviewUid,
        reason: params.reason,
        block: params.block,
      );
}
