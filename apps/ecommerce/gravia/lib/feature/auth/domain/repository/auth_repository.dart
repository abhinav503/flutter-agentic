import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String mobile,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> resendVerificationEmail();

  /// Reloads the Firebase user; if now verified, force-refreshes the ID
  /// token and re-syncs `emailVerified` to the admin API, returning the full
  /// profile (`null` if still unverified) — the re-sync response already
  /// carries the name/mobile captured at signup, so the BLoC never has to
  /// stitch a profile back together from scratch after verification.
  Future<Either<Failure, UserEntity?>> checkEmailVerified();

  /// Updates the Firebase Auth display name and the Firestore profile doc
  /// (name + mobile). Email is not editable here — see
  /// `AuthRemoteDataSource.updateProfile`.
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String mobile,
  });
}
