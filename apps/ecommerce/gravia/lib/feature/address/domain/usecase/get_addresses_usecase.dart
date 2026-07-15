import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/address_entity.dart';
import '../repository/address_repository.dart';

class GetAddressesUseCase
    extends UseCase<Either<Failure, List<AddressEntity>>, NoParams> {
  final AddressRepository _repository;

  const GetAddressesUseCase(this._repository);

  @override
  Future<Either<Failure, List<AddressEntity>>> call(NoParams params) =>
      _repository.getAddresses();
}
