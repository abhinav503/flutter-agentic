import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/ui/atoms/dropdown_menu.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/enums/terminal_agent.dart';
import '../bloc/terminal_bloc.dart';

/// Top-bar switcher for what runs in the shell (terminal / Claude / Codex).
class TerminalAgentAction extends StatelessWidget {
  const TerminalAgentAction({super.key});

  static const _items = <AppDropdownItem<TerminalAgent>>[
    AppDropdownItem(
      value: TerminalAgent.terminal,
      label: ValueConst.agentTerminalLabel,
      subtitle: ValueConst.agentTerminalSubtitle,
      icon: Icons.terminal,
    ),
    AppDropdownItem(
      value: TerminalAgent.claude,
      label: ValueConst.agentClaudeLabel,
      subtitle: ValueConst.agentClaudeSubtitle,
      icon: Icons.auto_awesome,
    ),
    AppDropdownItem(
      value: TerminalAgent.codex,
      label: ValueConst.agentCodexLabel,
      subtitle: ValueConst.agentCodexSubtitle,
      icon: Icons.code,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalBloc, TerminalState>(
      buildWhen: (a, b) => a.agent != b.agent,
      builder: (context, state) => AppDropdownMenu<TerminalAgent>(
        value: state.agent,
        tooltip: ValueConst.agentTooltip,
        onSelected: (agent) => context
            .read<TerminalBloc>()
            .add(TerminalEvent.agentSelected(agent)),
        items: _items,
        trigger: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.smart_toy_outlined),
        ),
      ),
    );
  }
}
