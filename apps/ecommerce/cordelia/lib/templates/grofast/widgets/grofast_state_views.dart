import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'grofast_primary_button.dart';

/// The pack's empty state — core's [EmptyState] with the pack's gradient CTA
/// as its action, so every empty screen in the template offers its next step
/// in the same shape. The type comes from the theme, which already carries
/// Raleway and the pack's roles.
class GrofastEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const GrofastEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl6),
    child: EmptyState(
      iconData: icon,
      title: title,
      subtitle: subtitle,
      actions: [
        if (actionLabel != null && onAction != null)
          GrofastPrimaryButton(
            label: actionLabel!,
            onTap: onAction,
            fullWidth: false,
          ),
      ],
    ),
  );
}

/// The pack's error state — core's [ErrorView] with the pack's own vertical
/// rhythm around it, so a failed load sits where an empty one would.
class GrofastErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const GrofastErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl6),
    child: ErrorView(message: message, onRetry: onRetry),
  );
}

/// The pack's content swap — core's [AppSwitcher] at the pack's own tier, so
/// a skeleton → loaded → empty → error transition can't drift per screen
/// (spec sheet §7).
class GrofastSwitcher extends StatelessWidget {
  final Widget child;

  const GrofastSwitcher({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
      AppSwitcher(topAligned: true, child: child);
}
