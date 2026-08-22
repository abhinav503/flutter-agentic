import 'package:cordelia/enums/review_report_reason.dart';
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

  Future<void> reportReview({
    required String storeId,
    required String productId,
    required String reviewUid,
    required ReviewReportReason reason,
    required bool block,
  });
}
