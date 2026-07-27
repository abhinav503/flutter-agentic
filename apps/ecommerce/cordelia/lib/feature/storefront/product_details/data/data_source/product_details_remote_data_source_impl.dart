import 'package:cordelia/constants/api_constants.dart';
import 'package:core/core/network/http_service.dart';
import '../models/product_detail_model.dart';
import 'product_details_remote_data_source.dart';

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  const ProductDetailsRemoteDataSourceImpl();

  @override
  Future<ProductDetailModel> getProductDetails(
    String storeId,
    String productId,
  ) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.productDetailsPath(storeId, productId),
    );
    return ProductDetailModel.fromJson(response.data!);
  }
}
