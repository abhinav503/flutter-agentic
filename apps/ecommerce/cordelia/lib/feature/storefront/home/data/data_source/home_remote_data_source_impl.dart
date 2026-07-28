import 'package:core/core/network/http_service.dart';

import 'package:cordelia/constants/api_constants.dart';

import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/home_model.dart';
import '../models/product_model.dart';
import 'home_remote_data_source.dart';

/// No single API response matches HomeModel's shape (flat categories +
/// popular products + banners), so this combines the endpoints that already
/// exist for Categories, Popular Products and Banners rather than adding a
/// dedicated /home route — flattening the grouped categories response
/// client-side.
/// Ported from gravia's HomeRemoteDataSourceImpl with storeId threaded as a
/// call parameter (this app serves many stores from one binary) and the
/// categories-groups response parsed inline rather than depending on the
/// not-yet-ported Categories feature's own CategoriesModel.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<HomeModel> getHome({required String storeId}) async {
    // A record's `.wait` rather than Future.wait: the three calls return
    // different types, so a list of futures would widen to dynamic.
    final (categoriesResponse, popularResponse, banners) = await (
      HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.categoriesPath(storeId),
      ),
      HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.popularProductsPath(storeId),
      ),
      _getBanners(storeId),
    ).wait;

    final groupsJson = categoriesResponse.data!['groups'] as List<dynamic>;
    final categories = groupsJson
        .expand(
          (group) => (group as Map<String, dynamic>)['categories'] as List,
        )
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();

    final popularProductsJson =
        popularResponse.data!['popular_products'] as List<dynamic>;

    return HomeModel(
      categories: categories,
      popularProducts: popularProductsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList(),
      banners: banners,
    );
  }

  /// Swallows its own failure, unlike the two calls beside it: banners are
  /// merchandising, not content. A store whose API predates this endpoint —
  /// or that momentarily 500s it — should still get a working Home, and the
  /// template already renders an empty banner list by falling back to its
  /// top sellers.
  Future<List<BannerModel>> _getBanners(String storeId) async {
    try {
      final response = await HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.bannersPath(storeId),
      );
      return (response.data!['banners'] as List<dynamic>)
          .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
