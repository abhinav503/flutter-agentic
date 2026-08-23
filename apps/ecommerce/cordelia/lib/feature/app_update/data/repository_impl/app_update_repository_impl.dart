import 'dart:io' show Platform;

import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/app_update_requirement_entity.dart';
import '../../domain/repository/app_update_repository.dart';
import '../data_source/app_config_remote_data_source.dart';

class AppUpdateRepositoryImpl
    with BaseRepository
    implements AppUpdateRepository {
  final AppConfigRemoteDataSource _dataSource;
  const AppUpdateRepositoryImpl(this._dataSource);

  // The web preview is never gated — there is no store to send it to.
  static String get _platform =>
      kIsWeb ? 'web' : (Platform.isIOS ? 'ios' : 'android');

  @override
  Future<Either<Failure, AppUpdateRequirementEntity>> getRequirement() =>
      handleRequest(() async {
        final model = await _dataSource.getAppConfig();
        return right(model.toEntity(platform: _platform));
      });
}
