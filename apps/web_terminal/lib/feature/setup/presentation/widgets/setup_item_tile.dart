import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/ui/atoms/badge.dart';
import 'package:flutter/material.dart';

import 'package:web_terminal/constants/value_const.dart';
import '../../domain/entities/setup_item_entity.dart';
import 'command_block.dart';
import 'setup_tile.dart';

class SetupItemTile extends StatefulWidget {
  final SetupItemEntity item;
  const SetupItemTile({super.key, required this.item});

  @override
  State<SetupItemTile> createState() => _SetupItemTileState();
}

class _SetupItemTileState extends State<SetupItemTile> {
  late bool _expanded = !widget.item.installed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppColorsExtension>()!;
    final item = widget.item;
    return SetupTile(
      icon: item.installed
          ? Icons.check_circle
          : Icons.radio_button_unchecked,
      iconColor: item.installed ? ext.onSuccessContainer : cs.outline,
      title: item.name,
      subtitle: item.installed && item.detail.isNotEmpty
          ? item.detail
          : item.description,
      onTap: () => setState(() => _expanded = !_expanded),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBadge(
            text: item.installed
                ? ValueConst.setupInstalledLabel
                : ValueConst.setupMissingLabel,
            intent:
                item.installed ? AppBadgeIntent.success : AppBadgeIntent.error,
            size: AppBadgeSize.small,
          ),
          Icon(
            _expanded ? Icons.expand_less : Icons.expand_more,
            color: cs.onSurfaceVariant,
          ),
        ],
      ),
      child: _expanded
          ? Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                0,
                AppSpacing.base,
                AppSpacing.base,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final step in item.steps)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: _StepView(step: step),
                    ),
                ],
              ),
            )
          : null,
    );
  }
}

class _StepView extends StatelessWidget {
  final SetupStep step;
  const _StepView({required this.step});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.label,
          style: tt.bodySmall?.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs3),
        if (step.manual)
          _ManualNote(note: step.note ?? '')
        else if (step.command != null)
          CommandBlock(command: step.command!),
      ],
    );
  }
}

class _ManualNote extends StatelessWidget {
  final String note;
  const _ManualNote({required this.note});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBadge(
            text: ValueConst.setupManualLabel,
            intent: AppBadgeIntent.warning,
            size: AppBadgeSize.small,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              note,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

