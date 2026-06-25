import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xterm/xterm.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/enums/terminal_agent.dart';
import 'package:web_terminal/enums/terminal_status.dart';
import '../../domain/entities/terminal_output_entity.dart';
import '../../domain/usecase/connect_terminal_usecase.dart';
import '../../domain/usecase/disconnect_terminal_usecase.dart';
import '../../domain/usecase/resize_terminal_usecase.dart';
import '../../domain/usecase/send_input_usecase.dart';
import 'wheel_mouse_handler.dart';

part 'terminal_bloc.freezed.dart';
part 'terminal_event.dart';
part 'terminal_state.dart';

/// Drives one terminal session. The xterm [Terminal] lives in state; its
/// `onOutput`/`onResize` callbacks feed events back here, and PTY output is
/// written straight into it.
class TerminalBloc extends Bloc<TerminalEvent, TerminalState> {
  static const _maxLines = 10000;

  final ConnectTerminalUseCase _connect;
  final SendInputUseCase _sendInput;
  final ResizeTerminalUseCase _resize;
  final DisconnectTerminalUseCase _disconnect;

  TerminalBloc({
    required ConnectTerminalUseCase connectTerminalUseCase,
    required SendInputUseCase sendInputUseCase,
    required ResizeTerminalUseCase resizeTerminalUseCase,
    required DisconnectTerminalUseCase disconnectTerminalUseCase,
  })  : _connect = connectTerminalUseCase,
        _sendInput = sendInputUseCase,
        _resize = resizeTerminalUseCase,
        _disconnect = disconnectTerminalUseCase,
        super(TerminalState(terminal: Terminal(maxLines: _maxLines))) {
    final terminal = state.terminal;
    // Fix xterm 4.0.0's wheel button encoding so alt-screen TUIs scroll.
    terminal.mouseHandler = const WheelFixMouseHandler();
    terminal.onOutput = (data) {
      add(TerminalEvent.inputSent(data));
    };
    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      add(TerminalEvent.resized(width, height));
    };

    // restartable: a re-dispatched connect cancels the previous session stream.
    on<TerminalConnectRequested>(_onConnect, transformer: restartable());
    on<TerminalInputSent>(_onInputSent);
    on<TerminalResized>(_onResized);
    on<TerminalAgentSelected>(_onAgentSelected);
  }

  // Reset each (re)connect so the default agent relaunches once per session.
  bool _agentLaunched = false;

  Terminal get terminal => state.terminal;

  Future<void> _onConnect(
    TerminalConnectRequested event,
    Emitter<TerminalState> emit,
  ) async {
    _agentLaunched = false;
    emit(state.copyWith(status: TerminalStatus.connecting, message: null));

    // Returning a state equal to the current one is a no-op for bloc, so the
    // per-chunk "connected" returns don't cause rebuilds — only transitions do.
    await emit.forEach<Either<Failure, TerminalOutputEntity>>(
      _connect(const NoParams()),
      onData: (either) => either.fold(
        (failure) {
          state.terminal.write(ValueConst.errorNotice(failure.message));
          return state.copyWith(
            status: TerminalStatus.error,
            message: failure.message,
          );
        },
        (output) {
          if (output.isExit) {
            state.terminal.write(ValueConst.exitNotice(output.exitCode ?? 0));
            return state.copyWith(status: TerminalStatus.exited);
          }
          state.terminal.write(output.data);
          // First output means the shell is alive — launch the default agent
          // once (fire-and-forget; the PTY buffers the command).
          if (!_agentLaunched) {
            _agentLaunched = true;
            _launch(state.agent);
          }
          return state.copyWith(status: TerminalStatus.connected);
        },
      ),
      onError: (error, _) => state.copyWith(
        status: TerminalStatus.error,
        message: error.toString(),
      ),
    );
  }

  Future<void> _onInputSent(
    TerminalInputSent event,
    Emitter<TerminalState> emit,
  ) =>
      _sendInput(SendInputParams(data: event.data));

  Future<void> _onResized(
    TerminalResized event,
    Emitter<TerminalState> emit,
  ) =>
      _resize(ResizeParams(cols: event.cols, rows: event.rows));

  Future<void> _onAgentSelected(
    TerminalAgentSelected event,
    Emitter<TerminalState> emit,
  ) async {
    emit(state.copyWith(agent: event.agent));
    await _launch(event.agent);
  }

  // [TerminalAgent.terminal] launches nothing — it's the plain shell.
  Future<void> _launch(TerminalAgent agent) async {
    final command = switch (agent) {
      TerminalAgent.terminal => null,
      TerminalAgent.claude => ValueConst.claudeCommand,
      TerminalAgent.codex => ValueConst.codexCommand,
    };
    if (command == null) return;
    await _sendInput(SendInputParams(data: '$command${ValueConst.keyEnter}'));
  }

  @override
  Future<void> close() async {
    await _disconnect(const NoParams());
    return super.close();
  }
}
