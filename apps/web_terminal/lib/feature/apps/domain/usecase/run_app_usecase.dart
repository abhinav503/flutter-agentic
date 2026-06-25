import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_entity.dart';
import '../repository/apps_repository.dart';

class RunAppUseCase extends UseCase<Either<Failure, AppEntity>, String> {
  final AppsRepository _repository;
  const RunAppUseCase(this._repository);

  @override
  Future<Either<Failure, AppEntity>> call(String name) =>
      _repository.runApp(name);
}
