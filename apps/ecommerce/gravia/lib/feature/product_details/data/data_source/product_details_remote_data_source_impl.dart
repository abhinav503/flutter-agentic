import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product_detail_model.dart';
import 'product_details_remote_data_source.dart';

/// Backed by a bundled JSON asset keyed by product id — same pattern as
/// [HomeRemoteDataSourceImpl]/[SearchRemoteDataSourceImpl], with a
/// `"default"` fallback entry for ids the mock doesn't have a dedicated
/// entry for.
class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  const ProductDetailsRemoteDataSourceImpl();

  @override
  Future<ProductDetailModel> getProductDetails(String productId) async {
    final raw = await rootBundle.loadString('assets/data/product_details.json');
    final byId = jsonDecode(raw) as Map<String, dynamic>;
    final json = (byId[productId] ?? byId['default']) as Map<String, dynamic>;
    return ProductDetailModel.fromJson(json);
  }
}
