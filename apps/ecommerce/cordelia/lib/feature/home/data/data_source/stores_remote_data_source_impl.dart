import 'package:dio/dio.dart';

import 'package:core/core/network/http_service.dart';

import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';

import '../models/store_model.dart';
import 'stores_remote_data_source.dart';

class StoresRemoteDataSourceImpl implements StoresRemoteDataSource {
  const StoresRemoteDataSourceImpl();

  /// Discovery is a public feed, so the token is **optional** and only ever
  /// widens the result: with one, the server also returns stores this user
  /// owns that aren't published yet, so a store admin can walk their own
  /// storefront while they finish setting it up.
  ///
  /// Never allowed to fail the request. A signed-out shopper, an expired
  /// session, or a Firebase call that throws all fall through to the
  /// anonymous list — discovery is the first screen after splash and must
  /// render for everyone.
  Future<Options?> _optionalAuth() async {
    try {
      final token = await FirebaseAuthService.instance.idToken();
      if (token == null) return null;
      return Options(headers: {'Authorization': 'Bearer $token'});
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StoreModel>> getStores({String? query}) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.storesPath,
      queryParameters: {if (query != null && query.isNotEmpty) 'q': query},
      options: await _optionalAuth(),
    );
    final stores = response.data!['stores'] as List;
    return stores
        .map((s) => StoreModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<StoreModel> getStore({required String storeId}) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.storePath(storeId),
    );
    // 404s for a store that was deleted or deactivated, which reaches the
    // caller as a server Failure — the one case this is called in (a
    // notification tap) has a fallback for exactly that.
    return StoreModel.fromJson(response.data!['store'] as Map<String, dynamic>);
  }
}
