import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:core/core/network/http_service.dart';

import '../../domain/entities/review_report_reason.dart';
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

  // The *optional* token, for the public read. Sent when there is one so the
  // server can drop reviews by shoppers this reader has blocked — a list
  // that still showed them would make the block look broken. A signed-out
  // reader has blocked nobody, so no header and no cost.
  Future<Options?> _optionalAuthOptions() async {
    if (FirebaseAuthService.instance.currentUser == null) return null;
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return null;
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<ProductReviewsModel> getProductReviews(
    String storeId,
    String productId,
  ) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.productReviewsPath(storeId, productId),
      options: await _optionalAuthOptions(),
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

  @override
  Future<void> reportReview({
    required String storeId,
    required String productId,
    required String reviewUid,
    required ReviewReportReason reason,
    required bool block,
  }) async {
    await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.reportReviewPath(storeId, productId, reviewUid),
      data: {'reason': reason.wireValue, 'block': block},
      options: await _authOptions(),
    );
  }
}
