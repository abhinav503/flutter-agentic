import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpParams {
  final String name;
  final String email;
  final String mobile;
  final String password;

  const SignUpParams({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
  });
}

class SignUpUseCase extends UseCase<Either<Failure, UserEntity>, SignUpParams> {
  final AuthRepository _repository;

  const SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) =>
      _repository.signUp(
        name: params.name,
        email: params.email,
        mobile: params.mobile,
        password: params.password,
      );
}
