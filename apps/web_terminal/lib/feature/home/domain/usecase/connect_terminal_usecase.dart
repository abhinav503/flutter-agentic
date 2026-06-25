import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/terminal_output_entity.dart';
import '../repository/terminal_repository.dart';

/// Streams shell output over the session lifetime — a [StreamUseCase], not a
/// one-shot [UseCase].
class ConnectTerminalUseCase
    extends StreamUseCase<Either<Failure, TerminalOutputEntity>, NoParams> {
  final TerminalRepository _repository;
  const ConnectTerminalUseCase(this._repository);

  @override
  Stream<Either<Failure, TerminalOutputEntity>> call(NoParams params) =>
      _repository.connect();
}
