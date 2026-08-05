import 'package:cordelia/constants/api_constants.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:core/core/network/http_service.dart';
import 'package:dio/dio.dart';

import '../models/geo_address_model.dart';
import '../models/pincode_info_model.dart';
import '../models/place_suggestion_model.dart';
import 'geo_remote_data_source.dart';

/// Backed by the admin API's token-authed `/api/geo/*` proxy — the Ola Maps
/// key lives server-side, and web builds dodge third-party CORS. Same auth
/// shape as `AddressRemoteDataSourceImpl`.
class GeoRemoteDataSourceImpl implements GeoRemoteDataSource {
  const GeoRemoteDataSourceImpl();

  Future<Options> _authOptions() async {
    final idToken = await FirebaseAuthService.instance.idToken();
    return Options(headers: {'Authorization': 'Bearer $idToken'});
  }

  @override
  Future<GeoAddressModel?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _getOrNullOn404(
      '${ApiConstants.geoReversePath}?latlng=$latitude,$longitude',
    );
    if (response == null) return null;
    return GeoAddressModel.fromJson(
      response['address'] as Map<String, dynamic>,
    );
  }

  @override
  Future<List<PlaceSuggestionModel>> autocomplete(String query) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(
      ApiConstants.geoAutocompletePath,
      queryParameters: {'q': query},
      options: await _authOptions(),
    );
    return (response.data!['suggestions'] as List<dynamic>)
        .map((s) => PlaceSuggestionModel.fromJson(s as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PincodeInfoModel?> lookupPincode(String pincode) async {
    final response = await _getOrNullOn404(
      ApiConstants.geoPincodePath(pincode),
    );
    if (response == null) return null;
    return PincodeInfoModel.fromJson(
      response['pincode'] as Map<String, dynamic>,
    );
  }

  /// 404 means "nothing found there" for both reverse geocode and pincode —
  /// a normal outcome the caller maps to null, not an error to surface.
  Future<Map<String, dynamic>?> _getOrNullOn404(String url) async {
    try {
      final response = await HttpService.instance.get<Map<String, dynamic>>(
        url,
        options: await _authOptions(),
      );
      return response.data!;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}
