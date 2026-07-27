import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:dio/dio.dart';
import 'package:core/core/network/http_service.dart';
import '../../../home/data/models/product_model.dart';
import 'favourites_remote_data_source.dart';

class FavouritesRemoteDataSourceImpl implements FavouritesRemoteDataSource {
  const FavouritesRemoteDataSourceImpl();

  // Same signed-out degrade as the cart/recent-searches data sources: this
  // is per-user data keyed on the verified token's uid, so without a token
  // the server has nothing to look up and the mutations no-op.
  Future<String?> get _idToken => FirebaseAuthService.instance.idToken();

  @override
  Future<List<ProductModel>> getFavourites(String storeId) async {
    final idToken = await _idToken;
    if (idToken == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.favouritesPath(storeId),
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
    final items = response.data!['favourites'] as List<dynamic>;
    return items
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addFavourite(String storeId, String productId) async {
    final idToken = await _idToken;
    if (idToken == null) return;

    await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.favouritesPath(storeId),
      data: {'productId': productId},
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
  }

  @override
  Future<void> removeFavourite(String storeId, String productId) async {
    final idToken = await _idToken;
    if (idToken == null) return;

    await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.favouritesPath(storeId),
      queryParameters: {'productId': productId},
      options: Options(headers: {'Authorization': 'Bearer $idToken'}),
    );
  }
}
