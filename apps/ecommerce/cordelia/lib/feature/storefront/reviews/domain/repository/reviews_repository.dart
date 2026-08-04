import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/product_reviews_entity.dart';
import '../entities/review_entity.dart';

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
}
