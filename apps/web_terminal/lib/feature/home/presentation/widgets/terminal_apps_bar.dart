import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/enums/device_platform.dart';
import 'package:web_terminal/feature/apps/domain/entities/app_entity.dart';
import 'package:web_terminal/feature/apps/presentation/cubit/apps_cubit.dart';
import 'package:web_terminal/feature/devices/domain/entities/device_entity.dart';
import 'package:web_terminal/feature/devices/presentation/cubit/devices_cubit.dart';

/// Picks which app to run and which device to run it on, then Run/Stops it.
/// Hidden until the app list loads.
class TerminalAppsBar extends StatelessWidget {
  const TerminalAppsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
              Flexible(child: _AppDropdown(state: state, selected: selected)),
              const SizedBox(width: AppSpacing.sm),
              const Flexible(child: _DeviceDropdown()),
              const SizedBox(width: AppSpacing.sm),
              _RunStopButton(app: selected),
            ],
          ),
        );
      },
    );
  }
}

class _AppDropdown extends StatelessWidget {
  final AppsState state;
  final AppEntity selected;
  const _AppDropdown({required this.state, required this.selected});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            trigger: _Trigger(icon: Icons.apps, label: selected.name),
          ),
        ),
      ],
    );
  }
}

class _DeviceDropdown extends StatelessWidget {
  const _DeviceDropdown();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        final selected = state.selected;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ValueConst.deviceLabel,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: AppDropdownMenu<DeviceEntity>(
                value: selected,
                tooltip: ValueConst.deviceTooltip,
                onSelected: (d) => context.read<DevicesCubit>().select(d),
                items: [
                  for (final device in state.devices)
                    AppDropdownItem(
                      value: device,
                      label: device.name,
                      subtitle: device.isOfflineEmulator
                          ? ValueConst.deviceEmulatorHint
                          : null,
                      icon: _deviceIcon(device.platform),
                    ),
                ],
                trigger: _Trigger(
                  icon: _deviceIcon(selected.platform),
                  label: selected.name,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

IconData _deviceIcon(DevicePlatform platform) => switch (platform) {
      DevicePlatform.web => Icons.public,
      DevicePlatform.ios => Icons.phone_iphone,
      DevicePlatform.android => Icons.phone_android,
      DevicePlatform.other => Icons.devices_other,
    };

class _Trigger extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Trigger({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.lg, color: cs.primary),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.bodySmall?.copyWith(color: cs.onSurface),
            ),
          ),
          Icon(Icons.arrow_drop_down,
              size: AppSpacing.lg, color: cs.onSurfaceVariant),
        ],
      ),
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
      AppRunStatus.stopped || AppRunStatus.failed => AppButton(
          label: ValueConst.appRunLabel,
          size: AppButtonSize.small,
          leadingIcon: const Icon(Icons.play_arrow, size: AppSpacing.lg),
          onTap: () => cubit.run(app, context.read<DevicesCubit>().state.selected),
        ),
    };
  }
}
