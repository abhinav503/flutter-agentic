import 'package:core/core/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/feature/setup/presentation/cubit/setup_cubit.dart';
import 'package:web_terminal/feature/setup/presentation/widgets/setup_panel.dart';
import '../widgets/terminal_apps_bar.dart';
import '../widgets/terminal_console.dart';
import '../widgets/terminal_preview.dart';
import '../widgets/terminal_status_bar.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  // Below this width, drop the preview and show the terminal full-width.
  static const _splitBreakpoint = 720.0;

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final terminal = _buildTerminal();
          if (constraints.maxWidth < _splitBreakpoint) return terminal;
          return Row(
            children: [
              Expanded(child: terminal),
              const VerticalDivider(),
              const Expanded(child: _RightPane()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTerminal() {
    return const Column(
      children: [
        TerminalStatusBar(),
        TerminalAppsBar(),
        Expanded(child: TerminalConsole()),
      ],
    );
  }
}

class _RightPane extends StatelessWidget {
  const _RightPane();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupCubit, SetupState>(
      buildWhen: (a, b) => a.isOpen != b.isOpen,
      builder: (context, state) =>
          state.isOpen ? const SetupPanel() : const TerminalPreview(),
    );
  }
}
