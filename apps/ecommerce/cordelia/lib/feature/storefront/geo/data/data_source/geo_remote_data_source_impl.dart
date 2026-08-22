import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:core/core/network/http_service.dart';
import 'package:dio/dio.dart';

import '../models/pincode_info_model.dart';
import 'geo_remote_data_source.dart';

/// Backed by the admin API's token-authed `/api/geo/pincode` proxy — India
/// Post is keyless but proxied anyway, so the app has one code path and web
/// builds dodge third-party CORS. Same auth shape as
/// `AddressRemoteDataSourceImpl`.
class GeoRemoteDataSourceImpl implements GeoRemoteDataSource {
  const GeoRemoteDataSourceImpl();

  Future<Options> _authOptions() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<PincodeInfoModel?> lookupPincode(String pincode) async {
    // 404 means "no such pincode" — a normal outcome the caller maps to
    // null, not an error to surface. The form is hand-typeable either way.
    try {
      final response = await HttpService.instance.get<Map<String, dynamic>>(
        ApiConstants.geoPincodePath(pincode),
        options: await _authOptions(),
      );
      return PincodeInfoModel.fromJson(
        response.data!['pincode'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}
