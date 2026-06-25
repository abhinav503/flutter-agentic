import 'package:core/core/base/base_screen.dart';
import 'package:flutter/material.dart';

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
              const Expanded(child: TerminalPreview()),
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
