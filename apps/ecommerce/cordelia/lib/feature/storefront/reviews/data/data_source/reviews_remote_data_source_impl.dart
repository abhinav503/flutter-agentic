import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:core/core/network/http_service.dart';

import '../models/product_reviews_model.dart';
import '../models/review_model.dart';
import 'reviews_remote_data_source.dart';

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  const ReviewsRemoteDataSourceImpl();

  // Writes only. Reading a product's reviews is public — a signed-out
  // shopper still sees them, same as they see the product.
  Future<Options> _authOptions() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<ProductReviewsModel> getProductReviews(
    String storeId,
    String productId,
  ) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.productReviewsPath(storeId, productId),
    );
    return ProductReviewsModel.fromJson(response.data!);
  }

  @override
  Future<ReviewModel> submitReview({
    required String storeId,
    required String productId,
    required int rating,
    required String text,
  }) async {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.productReviewsPath(storeId, productId),
      data: {'rating': rating, 'text': text},
      options: await _authOptions(),
    );
    // The response also carries the product's recomputed `rating`; the bloc
    // reloads the list instead of trusting a locally patched copy, since a
    // new review changes the list's order as well as its summary.
    return ReviewModel.fromJson(
      response.data!['review'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> deleteMyReview(String storeId, String productId) async {
    await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.productReviewsPath(storeId, productId),
      options: await _authOptions(),
    );
  }
}
