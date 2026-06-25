part of 'terminal_bloc.dart';

@freezed
sealed class TerminalEvent with _$TerminalEvent {
  // Re-dispatch reconnects; a `restartable()` transformer cancels the prior
  // stream (see terminal_bloc.dart).
  const factory TerminalEvent.connectRequested() = TerminalConnectRequested;
  const factory TerminalEvent.inputSent(String data) = TerminalInputSent;
  const factory TerminalEvent.resized(int cols, int rows) = TerminalResized;
  const factory TerminalEvent.agentSelected(TerminalAgent agent) =
      TerminalAgentSelected;
}
