import 'package:fpdart/fpdart.dart';

import 'package:core/core/error/failure.dart';
import 'package:gravia/feature/profile/domain/entities/profile_entity.dart';
import 'package:gravia/feature/profile/domain/repository/profile_repository.dart';

class FakeProfileRepository implements ProfileRepository {
  /// Set per test to control what [getProfile] resolves to.
  Either<Failure, ProfileEntity> result = right(
    const ProfileEntity(
      name: 'Test Shopper',
      email: 'shopper@example.com',
      phone: '9876543210',
      avatarUrl: '',
    ),
  );

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async => result;
}
