import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_entity.dart';
import '../repository/apps_repository.dart';

/// Which app to run and the target to run it on. `platform` picks web-server
/// (embed) vs. native; `kind` tells the bridge whether to run directly or boot
/// an offline emulator first.
class RunAppParams {
  final String name;
  final String deviceId;
  final String platform;
  final String kind;

  const RunAppParams({
    required this.name,
    required this.deviceId,
    required this.platform,
    required this.kind,
  });
}

class RunAppUseCase extends UseCase<Either<Failure, AppEntity>, RunAppParams> {
  final AppsRepository _repository;
  const RunAppUseCase(this._repository);

  @override
  Future<Either<Failure, AppEntity>> call(RunAppParams params) =>
      _repository.runApp(
        params.name,
        deviceId: params.deviceId,
        platform: params.platform,
        kind: params.kind,
      );
}
