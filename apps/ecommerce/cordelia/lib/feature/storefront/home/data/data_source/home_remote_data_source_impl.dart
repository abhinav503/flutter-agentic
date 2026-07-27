import 'package:core/core/network/http_service.dart';

import 'package:cordelia/constants/api_constants.dart';

import '../models/category_model.dart';
import '../models/home_model.dart';
import '../models/product_model.dart';
import 'home_remote_data_source.dart';

/// No single API response matches HomeModel's shape (flat categories +
/// popular products), so this combines the two endpoints that already exist
/// for Categories and Popular Products rather than adding a dedicated
/// /home route — flattening the grouped categories response client-side.
/// Ported from gravia's HomeRemoteDataSourceImpl with storeId threaded as a
/// call parameter (this app serves many stores from one binary) and the
/// categories-groups response parsed inline rather than depending on the
/// not-yet-ported Categories feature's own CategoriesModel.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<HomeModel> getHome({required String storeId}) async {
    final results = await Future.wait([
      HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.categoriesPath(storeId),
      ),
      HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.popularProductsPath(storeId),
      ),
    ]);

    final groupsJson = results[0].data!['groups'] as List<dynamic>;
    final categories = groupsJson
        .expand(
          (group) => (group as Map<String, dynamic>)['categories'] as List,
        )
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final popularProductsJson =
        results[1].data!['popular_products'] as List<dynamic>;

    return HomeModel(
      categories: categories,
      popularProducts: popularProductsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }
}
