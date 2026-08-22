import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/services/location/location_service.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/geo_address_entity.dart';
import '../../domain/entities/pincode_info_entity.dart';
import '../../domain/repository/geo_repository.dart';
import '../data_source/geo_remote_data_source.dart';

class GeoRepositoryImpl with BaseRepository implements GeoRepository {
  final GeoRemoteDataSource _dataSource;
  const GeoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, GeoAddressEntity>> currentLocationAddress() =>
      handleRequest(() async {
        // Entirely on-device: LocationService does the permission dance, the
        // fix and the geocode, and returns a result rather than throwing.
        final location = await LocationService.instance.currentPlace();
        switch (location) {
          case LocationUnavailable(:final reason):
            // The words are the screen's job (see `locationFailureMessage`) —
            // `message` stays technical context, and `reason` is what a
            // localized line is actually chosen from.
            return left(
              Failure.location(
                message: 'Device location: ${reason.name}',
                reason: reason,
              ),
            );
          case LocationSuccess(hasPlace: false):
            // A fix the geocoder had no name for — ordinary with no network
            // or no Play services. Nothing to prefill, so say so rather than
            // handing the form six empty fields. No `reason`: the device did
            // its part.
            return left(
              const Failure.location(message: 'No address at this location'),
            );
          case LocationSuccess(
            :final street,
            :final subLocality,
            :final locality,
            :final administrativeArea,
            :final postalCode,
            :final country,
            :final latitude,
            :final longitude,
          ):
            return right(
              GeoAddressEntity(
                // The street and whatever sits under the city — the two the
                // shopper would write on the first line themselves.
                addressLine: [
                  street,
                  subLocality,
                ].where((part) => part.isNotEmpty).join(', '),
                city: locality,
                state: administrativeArea,
                postalCode: postalCode,
                country: country,
                latitude: latitude,
                longitude: longitude,
              ),
            );
        }
      });

  @override
  Future<Either<Failure, PincodeInfoEntity?>> lookupPincode(String pincode) =>
      handleRequest(() async {
        final model = await _dataSource.lookupPincode(pincode);
        return right(model?.toEntity());
      });
}
