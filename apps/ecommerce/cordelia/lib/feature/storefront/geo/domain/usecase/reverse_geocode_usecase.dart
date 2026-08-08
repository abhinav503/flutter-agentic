import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/geo_address_entity.dart';
import '../repository/geo_repository.dart';

class ReverseGeocodeParams {
  final double latitude;
  final double longitude;
  const ReverseGeocodeParams({required this.latitude, required this.longitude});
}

class ReverseGeocodeUseCase
    extends UseCase<Either<Failure, GeoAddressEntity>, ReverseGeocodeParams> {
  final GeoRepository _repository;
  const ReverseGeocodeUseCase(this._repository);

  @override
  Future<Either<Failure, GeoAddressEntity>> call(ReverseGeocodeParams params) =>
      _repository.reverseGeocode(
        latitude: params.latitude,
        longitude: params.longitude,
      );
}
