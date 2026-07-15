import '../models/product_detail_model.dart';

abstract interface class ProductDetailsRemoteDataSource {
  Future<ProductDetailModel> getProductDetails(String productId);
}
