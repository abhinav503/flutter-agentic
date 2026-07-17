import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/feature/categories/data/models/categories_model.dart';

import '../models/home_model.dart';
import '../models/product_model.dart';
import 'home_remote_data_source.dart';

/// No single API response matches HomeModel's shape (flat categories +
/// popular products), so this combines the two endpoints that already exist
/// for Categories and Popular Products rather than adding a dedicated
/// /home route — flattening the grouped categories response client-side.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<HomeModel> getHome() async {
    final results = await Future.wait([
      HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.categoriesPath,
      ),
      HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.popularProductsPath,
      ),
    ]);

    final categories = CategoriesModel.fromJson(results[0].data!);
    final popularProductsJson =
        results[1].data!['popular_products'] as List<dynamic>;

    return HomeModel(
      categories: categories.groups
          .expand((group) => group.categories)
          .toList(),
      popularProducts: popularProductsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }
}
