import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/setup_item_entity.dart';

abstract interface class SetupRepository {
  Future<Either<Failure, List<SetupItemEntity>>> getSetupStatus();
}
