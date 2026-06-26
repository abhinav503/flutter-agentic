import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/setup_item_entity.dart';
import '../repository/setup_repository.dart';

class GetSetupStatusUseCase
    extends UseCase<Either<Failure, List<SetupItemEntity>>, NoParams> {
  final SetupRepository _repository;
  const GetSetupStatusUseCase(this._repository);

  @override
  Future<Either<Failure, List<SetupItemEntity>>> call(NoParams params) =>
      _repository.getSetupStatus();
}
