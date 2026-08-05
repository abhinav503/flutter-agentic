import '../models/geo_address_model.dart';
import '../models/pincode_info_model.dart';
import '../models/place_suggestion_model.dart';

abstract interface class GeoRemoteDataSource {
  /// Null when the coordinates resolve to no address (server 404).
  Future<GeoAddressModel?> reverseGeocode({
    required double latitude,
    required double longitude,
  });

  Future<List<PlaceSuggestionModel>> autocomplete(String query);

  /// Null for an unknown pincode (server 404) — best-effort autofill.
  Future<PincodeInfoModel?> lookupPincode(String pincode);
}
