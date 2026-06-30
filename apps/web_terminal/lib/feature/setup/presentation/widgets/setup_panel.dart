import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import '../cubit/setup_cubit.dart';
import 'setup_item_tile.dart';
import 'setup_tile.dart';

/// Right-pane checklist of local dev prerequisites — replaces the preview when
/// the top-bar Setup button is active. Each item expands to its install steps.
class SetupPanel extends StatelessWidget {
  const SetupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        const _SetupHeader(),
        const Divider(height: 1),
        Expanded(
          child: BlocBuilder<SetupCubit, SetupState>(
            builder: (context, state) {
              if (state.loading && state.items.isEmpty) {
                return const _Checking();
              }
              if (state.error != null && state.items.isEmpty) {
                return ErrorView(
                  message: state.error!,
                  onRetry: () => context.read<SetupCubit>().refresh(),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.xs),
                children: [
                  if (state.missingCount == 0 && state.items.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.xs),
                      child: SetupTile(
                        icon: Icons.check_circle,
                        iconColor: cs.onSecondaryContainer,
                        title: ValueConst.setupAllInstalled,
                        background: cs.secondaryContainer,
                        titleColor: cs.onSecondaryContainer,
                      ),
                    ),
                  for (final item in state.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: SetupItemTile(item: item),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SetupHeader extends StatelessWidget {
  const _SetupHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return BlocBuilder<SetupCubit, SetupState>(
      builder: (context, state) {
        final cubit = context.read<SetupCubit>();
        final subtitle = state.loading
            ? ValueConst.setupChecking
            : state.missingCount == 0 && state.items.isNotEmpty
            ? ValueConst.setupAllInstalled
            : ValueConst.setupMissingCount(state.missingCount);
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ValueConst.setupPanelTitle,
                      style: tt.titleSmall?.copyWith(color: cs.onSurface),
                    ),
                    Text(
                      subtitle,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: ValueConst.setupRefreshTooltip,
                onPressed: state.loading ? null : cubit.refresh,
                icon: const Icon(Icons.refresh, size: AppSpacing.xl2),
              ),
              IconButton(
                tooltip: ValueConst.setupCloseTooltip,
                onPressed: cubit.hide,
                icon: const Icon(Icons.close, size: AppSpacing.xl2),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Checking extends StatelessWidget {
  const _Checking();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoadingIndicator(size: AppSpacing.xl4, strokeWidth: 2),
          const SizedBox(height: AppSpacing.base),
          Text(
            ValueConst.setupChecking,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
