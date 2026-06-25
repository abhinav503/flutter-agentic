import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_entity.dart';
import '../repository/apps_repository.dart';

class ListAppsUseCase
    extends UseCase<Either<Failure, List<AppEntity>>, NoParams> {
  final AppsRepository _repository;
  const ListAppsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AppEntity>>> call(NoParams params) =>
      _repository.listApps();
}
