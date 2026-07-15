import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/address_entity.dart';

abstract interface class AddressRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
}
