import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_entity.dart';
import '../repository/apps_repository.dart';

class StopAppUseCase extends UseCase<Either<Failure, AppEntity>, String> {
  final AppsRepository _repository;
  const StopAppUseCase(this._repository);

  @override
  Future<Either<Failure, AppEntity>> call(String name) =>
      _repository.stopApp(name);
}
