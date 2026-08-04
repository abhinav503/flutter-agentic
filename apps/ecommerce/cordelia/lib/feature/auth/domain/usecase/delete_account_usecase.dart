import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/auth_repository.dart';

/// Closes the signed-in shopper's account. Terminal and irreversible — the
/// screens gate it behind their pack's confirm sheet.
class DeleteAccountUseCase extends UseCase<Either<Failure, void>, NoParams> {
  final AuthRepository _repository;
  const DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) =>
      _repository.deleteAccount();
}
