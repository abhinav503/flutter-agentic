import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/geo_address_entity.dart';
import '../entities/pincode_info_entity.dart';
import '../entities/place_suggestion_entity.dart';

abstract interface class GeoRepository {
  /// Device GPS → reverse geocode. `Failure.location` when the device can't
  /// produce a position (service off / permission declined / no fix) or the
  /// position resolves to no address.
  Future<Either<Failure, GeoAddressEntity>> currentLocationAddress();

  /// Coordinates → structured address (a picked suggestion's resolve step).
  Future<Either<Failure, GeoAddressEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, List<PlaceSuggestionEntity>>> searchPlaces(
    String query,
  );

  /// Null (not a Failure) for an unknown pincode — the form's autofill is
  /// best-effort and silently skips.
  Future<Either<Failure, PincodeInfoEntity?>> lookupPincode(String pincode);
}
