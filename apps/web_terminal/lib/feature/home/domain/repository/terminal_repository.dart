import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/terminal_output_entity.dart';

/// A single local terminal session. Stream errors arrive as `Left` rather than
/// being thrown; [sendInput]/[resize]/[disconnect] act on the session opened by
/// [connect].
abstract interface class TerminalRepository {
  Stream<Either<Failure, TerminalOutputEntity>> connect();
  void sendInput(String data);
  void resize(int cols, int rows);
  Future<void> disconnect();
}
