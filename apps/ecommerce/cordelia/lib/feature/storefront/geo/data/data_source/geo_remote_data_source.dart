import '../models/pincode_info_model.dart';

/// One call. Reverse geocoding and place search used to live here too,
/// against an Ola Maps proxy; both are now the device's own geocoder (see
/// [GeoRepository]), and India Post's pincode data is the only part of this
/// feature a phone cannot answer for itself.
abstract interface class GeoRemoteDataSource {
  /// Null for an unknown pincode (server 404) — best-effort autofill.
  Future<PincodeInfoModel?> lookupPincode(String pincode);
}
