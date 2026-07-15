import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
}
