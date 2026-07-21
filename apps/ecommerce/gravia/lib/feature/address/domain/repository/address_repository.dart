import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/address_entity.dart';

abstract interface class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();

  /// Resolves to the saved address — on create the server assigns the id
  /// (and default flag for a first address), so callers must use the
  /// returned entity, not the one they submitted.
  Future<Either<Failure, AddressEntity>> createAddress(AddressEntity address);
  Future<Either<Failure, AddressEntity>> updateAddress(AddressEntity address);

  /// Resolves to the addresses remaining after the delete.
  Future<Either<Failure, List<AddressEntity>>> deleteAddress(String addressId);
}
