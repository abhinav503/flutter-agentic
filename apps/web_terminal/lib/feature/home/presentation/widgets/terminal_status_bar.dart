import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/enums/terminal_status.dart';
import '../bloc/terminal_bloc.dart';
import 'terminal_agent_action.dart';

/// Status dot + label, the agent switcher, and a Reconnect action once the
/// session has exited or errored.
class TerminalStatusBar extends StatelessWidget {
  const TerminalStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<TerminalBloc, TerminalState>(
      buildWhen: (a, b) => a.status != b.status || a.message != b.message,
      builder: (context, state) {
        final (color, label) = _describe(context, state);
        final canReconnect = state.status == TerminalStatus.exited ||
            state.status == TerminalStatus.error;
        return Container(
          color: cs.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs2,
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.xs,
                height: AppSpacing.xs,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              const TerminalAgentAction(),
              if (canReconnect)
                AppButton(
                  label: ValueConst.reconnectButton,
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.text,
                  onTap: () => context
                      .read<TerminalBloc>()
                      .add(const TerminalEvent.connectRequested()),
                ),
            ],
          ),
        );
      },
    );
  }

  (Color, String) _describe(BuildContext context, TerminalState state) {
    final cs = Theme.of(context).colorScheme;
    final success =
        Theme.of(context).extension<AppColorsExtension>()!.onSuccessContainer;
    return switch (state.status) {
      TerminalStatus.connecting => (cs.outline, ValueConst.statusConnecting),
      TerminalStatus.connected => (success, ValueConst.statusConnected),
      TerminalStatus.exited => (cs.onSurfaceVariant, ValueConst.statusExited),
      TerminalStatus.error => (
          cs.error,
          state.message ?? ValueConst.statusExited
        ),
    };
  }
}
