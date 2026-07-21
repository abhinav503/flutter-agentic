import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/address_entity.dart';
import '../repository/address_repository.dart';

class DeleteAddressUseCase
    extends UseCase<Either<Failure, List<AddressEntity>>, String> {
  final AddressRepository _repository;

  const DeleteAddressUseCase(this._repository);

  @override
  Future<Either<Failure, List<AddressEntity>>> call(String params) =>
      _repository.deleteAddress(params);
}
