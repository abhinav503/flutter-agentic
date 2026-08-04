import '../models/product_reviews_model.dart';
import '../models/review_model.dart';

abstract interface class ReviewsRemoteDataSource {
  Future<ProductReviewsModel> getProductReviews(
    String storeId,
    String productId,
  );

  Future<ReviewModel> submitReview({
    required String storeId,
    required String productId,
    required int rating,
    required String text,
  });

  Future<void> deleteMyReview(String storeId, String productId);
}
