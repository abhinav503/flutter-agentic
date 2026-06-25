import 'package:core/core/usecase/usecase.dart';

import '../repository/terminal_repository.dart';

class DisconnectTerminalUseCase extends UseCase<void, NoParams> {
  final TerminalRepository _repository;
  const DisconnectTerminalUseCase(this._repository);

  @override
  Future<void> call(NoParams params) => _repository.disconnect();
}
