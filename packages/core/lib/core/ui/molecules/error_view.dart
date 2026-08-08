import 'package:flutter/material.dart';

import '../../constants/core_const.dart';
import '../../theme/app_spacing.dart';
import '../atoms/button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  /// Retry button label override (default [CoreConst.retryButton]) — for a
  /// pack whose copy differs.
  final String? retryLabel;

  /// Replaces the default retry [AppButton] entirely — for a pack whose
  /// retry control is its own styled CTA. Wins over [onRetry]/[retryLabel].
  final Widget? action;

  /// Style/glyph overrides — for packs whose spec calls out exact typography
  /// or a different error glyph than the `error_outline` default.
  final TextStyle? messageStyle;
  final IconData icon;
  final Color? iconColor;

  /// Outer inset override (default none — the host pads) — pack wrappers
  /// existed solely to add this, so it's a param instead.
  final EdgeInsetsGeometry? padding;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
    this.action,
    this.messageStyle,
    this.icon = Icons.error_outline,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor ?? cs.error),
            const SizedBox(height: AppSpacing.base),
            Text(
              message,
              textAlign: TextAlign.center,
              style:
                  messageStyle ?? tt.bodyMedium!.copyWith(color: cs.onSurface),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.base),
              action!,
            ] else if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.base),
              AppButton(
                label: retryLabel ?? CoreConst.retryButton,
                variant: AppButtonVariant.primary,
                onTap: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
