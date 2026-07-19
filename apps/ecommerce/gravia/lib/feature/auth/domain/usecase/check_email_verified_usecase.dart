import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class CheckEmailVerifiedUseCase
    extends UseCase<Either<Failure, UserEntity?>, NoParams> {
  final AuthRepository _repository;

  const CheckEmailVerifiedUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) =>
      _repository.checkEmailVerified();
}
