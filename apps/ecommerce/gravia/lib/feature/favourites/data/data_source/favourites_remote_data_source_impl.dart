import 'package:core/core/network/http_service.dart';

import 'package:gravia/constants/api_constants.dart';
import 'package:gravia/services/firebase_auth_service.dart';

import '../../../home/data/models/product_model.dart';
import 'favourites_remote_data_source.dart';

class FavouritesRemoteDataSourceImpl implements FavouritesRemoteDataSource {
  const FavouritesRemoteDataSourceImpl();

  // Same signed-out degrade as the cart/recent-searches data sources: this
  // is per-user data, so without a uid the server has nothing to look up.
  String? get _uid => FirebaseAuthService.instance.currentUser?.uid;

  @override
  Future<List<ProductModel>> getFavourites() async {
    final uid = _uid;
    if (uid == null) return const [];

    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.favouritesPath,
      queryParameters: {'userId': uid},
    );
    final items = response.data!['favourites'] as List<dynamic>;
    return items
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addFavourite(String productId) async {
    final uid = _uid;
    if (uid == null) return;

    await HttpService.instance.post<Map<String, dynamic>>(
      ApiConstants.favouritesPath,
      data: {'userId': uid, 'productId': productId},
    );
  }

  @override
  Future<void> removeFavourite(String productId) async {
    final uid = _uid;
    if (uid == null) return;

    await HttpService.instance.delete<Map<String, dynamic>>(
      ApiConstants.favouritesPath,
      queryParameters: {'userId': uid, 'productId': productId},
    );
  }
}
