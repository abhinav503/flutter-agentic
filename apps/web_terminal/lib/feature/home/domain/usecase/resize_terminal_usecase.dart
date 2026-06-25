import 'package:core/core/usecase/usecase.dart';

import '../repository/terminal_repository.dart';

class ResizeTerminalUseCase extends UseCase<void, ResizeParams> {
  final TerminalRepository _repository;
  const ResizeTerminalUseCase(this._repository);

  @override
  Future<void> call(ResizeParams params) async =>
      _repository.resize(params.cols, params.rows);
}

class ResizeParams {
  final int cols;
  final int rows;
  const ResizeParams({required this.cols, required this.rows});
}
