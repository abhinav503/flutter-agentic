import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignInUseCase extends UseCase<Either<Failure, UserEntity>, SignInParams> {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) =>
      _repository.signIn(email: params.email, password: params.password);
}
