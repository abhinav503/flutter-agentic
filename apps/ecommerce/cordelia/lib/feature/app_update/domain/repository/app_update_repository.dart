import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_update_requirement_entity.dart';

abstract interface class AppUpdateRepository {
  Future<Either<Failure, AppUpdateRequirementEntity>> getRequirement();
}
