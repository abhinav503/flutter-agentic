import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class UpdateProfileParams {
  final String name;
  final String mobile;

  const UpdateProfileParams({required this.name, required this.mobile});
}

class UpdateProfileUseCase
    extends UseCase<Either<Failure, UserEntity>, UpdateProfileParams> {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) =>
      _repository.updateProfile(name: params.name, mobile: params.mobile);
}
