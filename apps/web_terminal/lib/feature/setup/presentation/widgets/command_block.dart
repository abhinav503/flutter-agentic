import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/feature/home/presentation/bloc/terminal_bloc.dart';

class CommandBlock extends StatelessWidget {
  final String command;
  const CommandBlock({super.key, required this.command});

  void _run(BuildContext context) => context
      .read<TerminalBloc>()
      .add(TerminalEvent.inputSent('$command${ValueConst.keyEnter}'));

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: command));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(ValueConst.commandCopiedNotice)),
      );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: AppRadius.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            command,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              AppButton(
                label: ValueConst.commandRunLabel,
                size: AppButtonSize.small,
                leadingIcon: const Icon(Icons.play_arrow, size: AppSpacing.lg),
                onTap: () => _run(context),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppButton(
                label: ValueConst.commandCopyLabel,
                size: AppButtonSize.small,
                variant: AppButtonVariant.secondary,
                leadingIcon: const Icon(Icons.copy_outlined, size: AppSpacing.lg),
                onTap: () => _copy(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
