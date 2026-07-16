import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../data_source/profile_remote_data_source.dart';

class ProfileRepositoryImpl with BaseRepository implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  const ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() =>
      handleRequest(() async {
        final model = await _dataSource.getProfile();
        return right(model.toEntity());
      });
}
