import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:core/core/network/http_service.dart';
import 'package:dio/dio.dart';

import '../models/product_detail_model.dart';
import 'product_details_remote_data_source.dart';

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  const ProductDetailsRemoteDataSourceImpl();

  /// Public, so no token is required — but one is sent when there is a
  /// session, because this payload carries the product's first page of
  /// reviews and the server drops the authors this reader has blocked from
  /// it. Without the header the block would hold on the reviews endpoint and
  /// silently not on the copy Product Details seeds from, so a blocked
  /// shopper would reappear every time the page was reopened.
  Future<Options?> _optionalAuthOptions() async {
    if (FirebaseAuthService.instance.currentUser == null) return null;
    final idToken = await FirebaseAuthService.instance.idToken();
    if (idToken == null) return null;
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<ProductDetailModel> getProductDetails(
    String storeId,
    String productId,
  ) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.productDetailsPath(storeId, productId),
      options: await _optionalAuthOptions(),
    );
    return ProductDetailModel.fromJson(response.data!);
  }
}
