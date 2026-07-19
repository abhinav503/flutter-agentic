import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';

import 'package:gravia/services/firebase_auth_service.dart';
import 'package:gravia/services/user_profile_cache_service.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl with BaseRepository implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) => handleRequest(() async {
    try {
      final model = await _dataSource.signUp(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      await UserProfileCacheService.instance.save(model.toJson());
      return right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return left(Failure.unexpected(message: e.readableMessage));
    }
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) => handleRequest(() async {
    try {
      final model = await _dataSource.signIn(email: email, password: password);
      await UserProfileCacheService.instance.save(model.toJson());
      return right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return left(Failure.unexpected(message: e.readableMessage));
    }
  });

  @override
  Future<Either<Failure, void>> signOut() => handleRequest(() async {
    await _dataSource.signOut();
    return right(null);
  });

  @override
  Future<Either<Failure, void>> resendVerificationEmail() =>
      handleRequest(() async {
        try {
          await _dataSource.resendVerificationEmail();
          return right(null);
        } on FirebaseAuthException catch (e) {
          return left(Failure.unexpected(message: e.readableMessage));
        }
      });

  @override
  Future<Either<Failure, UserEntity?>> checkEmailVerified() =>
      handleRequest(() async {
        try {
          final model = await _dataSource.checkEmailVerified();
          if (model != null) {
            await UserProfileCacheService.instance.save(model.toJson());
          }
          return right(model?.toEntity());
        } on FirebaseAuthException catch (e) {
          return left(Failure.unexpected(message: e.readableMessage));
        }
      });

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String mobile,
  }) => handleRequest(() async {
    try {
      final model = await _dataSource.updateProfile(name: name, mobile: mobile);
      await UserProfileCacheService.instance.save(model.toJson());
      return right(model.toEntity());
    } on FirebaseAuthException catch (e) {
      return left(Failure.unexpected(message: e.readableMessage));
    }
  });
}
