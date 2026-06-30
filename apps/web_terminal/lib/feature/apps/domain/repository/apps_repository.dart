import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/app_entity.dart';

abstract interface class AppsRepository {
  Future<Either<Failure, List<AppEntity>>> listApps();
  Future<Either<Failure, AppEntity>> runApp(
    String name, {
    required String deviceId,
    required String platform,
    required String kind,
  });
  Future<Either<Failure, AppEntity>> stopApp(String name);
}
