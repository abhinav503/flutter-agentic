import 'package:core/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xterm/xterm.dart';

import '../bloc/terminal_bloc.dart';

/// Renders the live shell. The [Terminal] controller lives in [TerminalBloc];
/// this widget only owns the view-side [TerminalController] (selection).
class TerminalConsole extends StatefulWidget {
  const TerminalConsole({super.key});

  @override
  State<TerminalConsole> createState() => _TerminalConsoleState();
}

class _TerminalConsoleState extends State<TerminalConsole> {
  final _controller = TerminalController();

  // Bundled JetBrains Mono — web's generic 'monospace' has loose, platform-
  // dependent metrics that spread rows out. `height` is the row line-height.
  static const _style = TerminalStyle(
    fontSize: 13,
    height: 1.15,
    fontFamily: 'JetBrainsMono',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final terminal = context.read<TerminalBloc>().terminal;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: TerminalView(
        terminal,
        controller: _controller,
        textStyle: _style,
        autofocus: true,
        // Forward wheel gestures to alt-screen TUIs as mouse events instead of
        // scrolling scrollback.
        simulateScroll: true,
      ),
    );
  }
}
