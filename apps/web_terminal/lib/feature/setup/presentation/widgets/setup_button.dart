import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:web_terminal/constants/value_const.dart';
import '../cubit/setup_cubit.dart';

/// Top-bar action that opens the setup checklist and badges how many
/// prerequisites are still missing.
class SetupButton extends StatelessWidget {
  const SetupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocBuilder<SetupCubit, SetupState>(
      builder: (context, state) {
        final missing = state.missingCount;
        final showBadge = state.loaded && missing > 0;
        return IconButton(
          tooltip: ValueConst.setupTooltip,
          color: state.isOpen ? cs.primary : null,
          onPressed: () => context.read<SetupCubit>().toggle(),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.checklist_rounded),
              if (showBadge)
                Positioned(
                  right: -AppSpacing.xs,
                  top: -AppSpacing.xs,
                  child: AppBadge(
                    text: '$missing',
                    intent: AppBadgeIntent.error,
                    size: AppBadgeSize.small,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
