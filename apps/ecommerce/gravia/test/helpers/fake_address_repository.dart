import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/address/domain/entities/address_entity.dart';
import 'package:gravia/feature/address/domain/repository/address_repository.dart';

class FakeAddressRepository implements AddressRepository {
  /// Set per test to control what [getAddresses] resolves to.
  Either<Failure, List<AddressEntity>> result = right(const []);

  /// Set per test to control what both save mutations resolve to.
  Either<Failure, AddressEntity> saveResult = left(
    const Failure.unexpected(message: 'saveResult not set'),
  );

  AddressEntity? lastCreated;
  AddressEntity? lastUpdated;

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async => result;

  @override
  Future<Either<Failure, AddressEntity>> createAddress(
    AddressEntity address,
  ) async {
    lastCreated = address;
    return saveResult;
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    AddressEntity address,
  ) async {
    lastUpdated = address;
    return saveResult;
  }
}
