import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/feature/apps/domain/entities/app_entity.dart';
import 'package:web_terminal/feature/apps/presentation/cubit/apps_cubit.dart';
import 'package:web_terminal/feature/devices/domain/entities/device_entity.dart';

/// Right pane for a native run target: there's no iframe to embed (the real
/// device window is tiled to the right), so this reports the launch state for
/// the selected app on [device].
class TerminalDeviceStatus extends StatelessWidget {
  final DeviceEntity device;
  const TerminalDeviceStatus({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppsCubit, AppsState>(
      builder: (context, state) {
        final app = state.selected;
        final status = app?.status ?? AppRunStatus.stopped;
        return Center(child: _statusView(status, app?.message));
      },
    );
  }

  Widget _statusView(AppRunStatus status, String? message) => switch (status) {
        AppRunStatus.running => EmptyState(
            iconData: Icons.check_circle_outline,
            title: ValueConst.deviceRunningTitle(device.name),
            subtitle: ValueConst.deviceRunningSubtitle,
          ),
        AppRunStatus.starting => EmptyState(
            iconData: Icons.sync,
            title: ValueConst.deviceStartingTitle(device.name),
            subtitle: ValueConst.deviceRunningSubtitle,
          ),
        AppRunStatus.failed => EmptyState(
            iconData: Icons.error_outline,
            title: ValueConst.deviceFailedTitle(device.name),
            subtitle: message ?? ValueConst.deviceFailedFallback,
          ),
        AppRunStatus.stopped => EmptyState(
            iconData: Icons.phone_iphone,
            title: ValueConst.deviceIdleTitle(device.name),
            subtitle: ValueConst.deviceIdleSubtitle,
          ),
      };
}
