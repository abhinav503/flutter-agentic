import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/auth_repository.dart';

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}

class ForgotPasswordUseCase
    extends UseCase<Either<Failure, void>, ForgotPasswordParams> {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) =>
      _repository.sendPasswordResetEmail(email: params.email);
}
