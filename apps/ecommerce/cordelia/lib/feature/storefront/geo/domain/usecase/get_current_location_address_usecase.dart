import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/geo_address_entity.dart';
import '../repository/geo_repository.dart';

class GetCurrentLocationAddressUseCase
    extends UseCase<Either<Failure, GeoAddressEntity>, NoParams> {
  final GeoRepository _repository;
  const GetCurrentLocationAddressUseCase(this._repository);

  @override
  Future<Either<Failure, GeoAddressEntity>> call(NoParams params) =>
      _repository.currentLocationAddress();
}
