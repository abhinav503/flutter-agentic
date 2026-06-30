import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/setup_item_entity.dart';
import '../../domain/repository/setup_repository.dart';
import '../data_source/setup_remote_data_source.dart';

class SetupRepositoryImpl with BaseRepository implements SetupRepository {
  final SetupRemoteDataSource _dataSource;
  const SetupRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<SetupItemEntity>>> getSetupStatus() =>
      handleRequest(() async {
        final models = await _dataSource.getSetupStatus();
        return right(models.map((m) => m.toEntity()).toList());
      });
}
