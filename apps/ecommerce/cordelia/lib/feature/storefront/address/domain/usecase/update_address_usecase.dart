import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/address_entity.dart';
import '../repository/address_repository.dart';

class UpdateAddressUseCase
    extends UseCase<Either<Failure, AddressEntity>, AddressEntity> {
  final AddressRepository _repository;

  const UpdateAddressUseCase(this._repository);

  @override
  Future<Either<Failure, AddressEntity>> call(AddressEntity params) =>
      _repository.updateAddress(params);
}
