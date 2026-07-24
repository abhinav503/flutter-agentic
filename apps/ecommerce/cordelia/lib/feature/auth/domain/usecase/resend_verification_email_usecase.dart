import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/auth_repository.dart';

class ResendVerificationEmailUseCase
    extends UseCase<Either<Failure, void>, NoParams> {
  final AuthRepository _repository;

  const ResendVerificationEmailUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      _repository.resendVerificationEmail();
}
