import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/product_reviews_entity.dart';
import '../entities/review_entity.dart';
import 'package:cordelia/enums/review_report_reason.dart';

abstract interface class ReviewsRepository {
  Future<Either<Failure, ProductReviewsEntity>> getProductReviews(
    String storeId,
    String productId,
  );

  /// Writes the signed-in shopper's review, replacing theirs if they already
  /// had one — the backend keys a review on (product, uid), so posting twice
  /// edits rather than duplicates. Resolves to the stored review; callers
  /// wanting the recomputed list/summary reload it.
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String storeId,
    required String productId,
    required int rating,
    required String text,
  });

  /// Removes the signed-in shopper's own review. Like [submitReview], the
  /// caller reloads to see the recomputed list and summary.
  Future<Either<Failure, void>> deleteMyReview(
    String storeId,
    String productId,
  );

  /// Flags someone else's review for the store owner, and optionally hides
  /// that author's reviews from this shopper from now on. Resolves to
  /// nothing: the caller reloads, which is also what makes a blocked
  /// author's reviews disappear from the list on screen.
  Future<Either<Failure, void>> reportReview({
    required String storeId,
    required String productId,
    required String reviewUid,
    required ReviewReportReason reason,
    required bool block,
  });
}
