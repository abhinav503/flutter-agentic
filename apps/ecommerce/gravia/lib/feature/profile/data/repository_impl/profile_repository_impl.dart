import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import 'package:gravia/services/user_profile_cache_service.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../data_source/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl with BaseRepository implements ProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  const ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() =>
      handleRequest(() async {
        // Warm cache (written by feature/auth right after signup/login/
        // verification) resolves instantly, no network round-trip and no
        // loader flash on every Profile tab visit. Cold cache falls back to
        // the real fetch and warms it for next time.
        final cached = UserProfileCacheService.instance.read();
        if (cached != null) {
          return right(ProfileModel.fromJson(cached).toEntity());
        }

        final model = await _dataSource.getProfile();
        await UserProfileCacheService.instance.save(model.toJson());
        return right(model.toEntity());
      });
}
