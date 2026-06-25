part of 'terminal_bloc.dart';

/// Single-state design. Output flows straight into [terminal] (the long-lived
/// xterm controller) without rebuilds; the BLoC only flips [status]/[message].
@freezed
abstract class TerminalState with _$TerminalState {
  const factory TerminalState({
    required Terminal terminal,
    @Default(TerminalStatus.connecting) TerminalStatus status,
    @Default(TerminalAgent.claude) TerminalAgent agent,
    String? message,
  }) = _TerminalState;
}
