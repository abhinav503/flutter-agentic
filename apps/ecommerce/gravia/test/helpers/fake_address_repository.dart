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

  /// Set per test to override what [deleteAddress] resolves to (e.g. a
  /// [Failure]). Left unset, it defaults to [result]'s list minus the
  /// deleted id — mimicking the real API, which returns the addresses
  /// remaining after the delete.
  Either<Failure, List<AddressEntity>>? deleteResult;

  AddressEntity? lastCreated;
  AddressEntity? lastUpdated;
  String? lastDeletedId;

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

  @override
  Future<Either<Failure, List<AddressEntity>>> deleteAddress(
    String addressId,
  ) async {
    lastDeletedId = addressId;
    return deleteResult ??
        result.map(
          (addresses) => addresses.where((a) => a.id != addressId).toList(),
        );
  }
}
