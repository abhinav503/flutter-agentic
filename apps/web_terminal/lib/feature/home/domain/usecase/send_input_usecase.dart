import 'package:core/core/usecase/usecase.dart';

import '../repository/terminal_repository.dart';

class SendInputUseCase extends UseCase<void, SendInputParams> {
  final TerminalRepository _repository;
  const SendInputUseCase(this._repository);

  @override
  Future<void> call(SendInputParams params) async =>
      _repository.sendInput(params.data);
}

class SendInputParams {
  final String data;
  const SendInputParams({required this.data});
}
