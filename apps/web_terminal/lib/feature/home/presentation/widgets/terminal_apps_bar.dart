import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/feature/apps/domain/entities/app_entity.dart';
import 'package:web_terminal/feature/apps/presentation/cubit/apps_cubit.dart';

/// Picks which app the right pane previews and Run/Stops its dev server. Hidden
/// until the app list loads.
class TerminalAppsBar extends StatelessWidget {
  const TerminalAppsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return BlocBuilder<AppsCubit, AppsState>(
      builder: (context, state) {
        if (state.apps.isEmpty) return const SizedBox.shrink();
        final selected = state.selected ?? state.apps.first;
        return Container(
          color: cs.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs2,
          ),
          child: Row(
            children: [
              Text(
                ValueConst.appsLabel,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: AppDropdownMenu<AppEntity>(
                  value: selected,
                  tooltip: ValueConst.appsTooltip,
                  onSelected: (app) => context.read<AppsCubit>().select(app),
                  items: [
                    for (final app in state.apps)
                      AppDropdownItem(
                        value: app,
                        label: app.name,
                        icon: Icons.folder_outlined,
                      ),
                  ],
                  trigger: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.apps,
                            size: AppSpacing.lg, color: cs.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            selected.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tt.bodySmall?.copyWith(color: cs.onSurface),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,
                            size: AppSpacing.lg, color: cs.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              _RunStopButton(app: selected),
            ],
          ),
        );
      },
    );
  }
}

class _RunStopButton extends StatelessWidget {
  final AppEntity app;
  const _RunStopButton({required this.app});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppsCubit>();
    return switch (app.status) {
      AppRunStatus.running => AppButton(
          label: ValueConst.appStopLabel,
          size: AppButtonSize.small,
          variant: AppButtonVariant.secondary,
          leadingIcon: const Icon(Icons.stop, size: AppSpacing.lg),
          onTap: () => cubit.stop(app),
        ),
      AppRunStatus.starting => const AppButton(
          label: ValueConst.appStartingLabel,
          size: AppButtonSize.small,
          state: AppButtonState.loading,
        ),
      AppRunStatus.stopped => AppButton(
          label: ValueConst.appRunLabel,
          size: AppButtonSize.small,
          leadingIcon: const Icon(Icons.play_arrow, size: AppSpacing.lg),
          onTap: () => cubit.run(app),
        ),
    };
  }
}
