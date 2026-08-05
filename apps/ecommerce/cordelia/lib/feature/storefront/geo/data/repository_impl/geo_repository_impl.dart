import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/services/location/location_service.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/geo_address_entity.dart';
import '../../domain/entities/pincode_info_entity.dart';
import '../../domain/entities/place_suggestion_entity.dart';
import '../../domain/repository/geo_repository.dart';
import '../data_source/geo_remote_data_source.dart';

class GeoRepositoryImpl with BaseRepository implements GeoRepository {
  final GeoRemoteDataSource _dataSource;
  const GeoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, GeoAddressEntity>> currentLocationAddress() =>
      handleRequest(() async {
        // The GPS read is a device call, not a remote one, so it lives here
        // (composed with the network half) rather than in the remote data
        // source; LocationService returns a result, never throws.
        final location = await LocationService.instance.currentPosition();
        switch (location) {
          case LocationUnavailable(:final reason):
            return left(Failure.location(message: 'Device location: $reason'));
          case LocationSuccess(:final latitude, :final longitude):
            return _resolve(latitude, longitude);
        }
      });

  @override
  Future<Either<Failure, GeoAddressEntity>> reverseGeocode({
    required double latitude,
    required double longitude,
  }) => handleRequest(() => _resolve(latitude, longitude));

  Future<Either<Failure, GeoAddressEntity>> _resolve(
    double latitude,
    double longitude,
  ) async {
    final model = await _dataSource.reverseGeocode(
      latitude: latitude,
      longitude: longitude,
    );
    if (model == null) {
      return left(
        const Failure.location(message: 'No address at this location'),
      );
    }
    return right(model.toEntity());
  }

  @override
  Future<Either<Failure, List<PlaceSuggestionEntity>>> searchPlaces(
    String query,
  ) => handleRequest(() async {
    final models = await _dataSource.autocomplete(query);
    return right(models.map((m) => m.toEntity()).toList());
  });

  @override
  Future<Either<Failure, PincodeInfoEntity?>> lookupPincode(String pincode) =>
      handleRequest(() async {
        final model = await _dataSource.lookupPincode(pincode);
        return right(model?.toEntity());
      });
}
