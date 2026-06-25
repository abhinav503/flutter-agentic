/// A chunk from the PTY session: shell [data] to render, or an exit signal
/// ([isExit] true, carrying [exitCode]).
class TerminalOutputEntity {
  final String data;
  final bool isExit;
  final int? exitCode;

  const TerminalOutputEntity({
    required this.data,
    this.isExit = false,
    this.exitCode,
  });

  const TerminalOutputEntity.output(this.data)
      : isExit = false,
        exitCode = null;

  const TerminalOutputEntity.exit(this.exitCode)
      : data = '',
        isExit = true;
}
