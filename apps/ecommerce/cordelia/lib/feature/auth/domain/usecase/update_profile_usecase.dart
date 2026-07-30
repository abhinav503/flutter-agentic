import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class UpdateProfileParams {
  final String name;
  final String mobile;

  /// A photo picked this session, or null to keep the existing avatar.
  final Uint8List? avatarBytes;

  const UpdateProfileParams({
    required this.name,
    required this.mobile,
    this.avatarBytes,
  });
}

class UpdateProfileUseCase
    extends UseCase<Either<Failure, UserEntity>, UpdateProfileParams> {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) =>
      _repository.updateProfile(
        name: params.name,
        mobile: params.mobile,
        avatarBytes: params.avatarBytes,
      );
}
