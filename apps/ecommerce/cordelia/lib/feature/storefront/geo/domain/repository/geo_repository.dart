import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/geo_address_entity.dart';
import '../entities/pincode_info_entity.dart';

/// The address form's two lookups.
///
/// Reverse geocoding is a **device** call, not a network one: Android's
/// Geocoder and iOS's CLGeocoder both do it with no API key, no quota and
/// nothing to authenticate, and they work in every market this app sells in.
/// The previous server proxy was Ola Maps, which is India-only and was never
/// configured in production — see `docs/explanation/superapp-ecommerce-plan.md`.
///
/// Pincode → city/state stays remote: it is India Post's data, not the
/// device's.
abstract interface class GeoRepository {
  /// "Use my location" — the permission dance, a fix, and the address
  /// behind it. Fails with `Failure.location` when the device won't say.
  Future<Either<Failure, GeoAddressEntity>> currentLocationAddress();

  /// Best-effort city/state for an Indian pincode. `null` for an unknown
  /// one, which is not an error — the shopper types it themselves.
  Future<Either<Failure, PincodeInfoEntity?>> lookupPincode(String pincode);
}
