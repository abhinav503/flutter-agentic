import 'product_rating_entity.dart';
import 'review_entity.dart';

/// A product's reviews page: the summary that heads it and the reviews
/// themselves. The two always travel together — a list whose header was
/// computed from a different read would show a count that disagrees with
/// the rows under it.
class ProductReviewsEntity {
  final ProductRatingEntity rating;
  final List<ReviewEntity> reviews;

  const ProductReviewsEntity({required this.rating, required this.reviews});
}

extension ProductReviewsEntityX on ProductReviewsEntity {
  /// The signed-in shopper's own review, or null if they haven't written
  /// one — what turns the write CTA into "Edit your review".
  ReviewEntity? mine(String? uid) {
    if (uid == null || uid.isEmpty) return null;
    for (final review in reviews) {
      if (review.uid == uid) return review;
    }
    return null;
  }
}
