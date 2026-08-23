import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_update_requirement_entity.dart';
import '../repository/app_update_repository.dart';

class GetUpdateRequirementUseCase
    extends UseCase<Either<Failure, AppUpdateRequirementEntity>, NoParams> {
  final AppUpdateRepository _repository;
  const GetUpdateRequirementUseCase(this._repository);

  @override
  Future<Either<Failure, AppUpdateRequirementEntity>> call(NoParams params) =>
      _repository.getRequirement();
}
