import 'package:flutter/material.dart';

import '../../theme/app_shapes_extension.dart';
import '../../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, text }

enum AppButtonSize { small, medium, large }

enum AppButtonState { idle, loading, disabled }

/// General-purpose button with three style variants, three sizes, and a
/// built-in loading state.
///
/// Colors are derived from [ColorScheme] so the button automatically adapts to
/// light/dark themes. No hard-coded colours.
///
/// ```dart
/// AppButton(
///   label: 'Save',
///   onTap: () => ...,
///   variant: AppButtonVariant.primary,
///   size: AppButtonSize.large,
///   fullWidth: true,
/// )
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppButtonState state;
  final bool fullWidth;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.state = AppButtonState.idle,
    this.fullWidth = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final isDisabled = state == AppButtonState.disabled;
    final isLoading = state == AppButtonState.loading;

    final bg = _backgroundColor(cs, isDisabled);
    final fg = _foregroundColor(cs, isDisabled);
    final border = _borderSide(cs, isDisabled);
    final padding = _padding();
    final textStyle = _textStyle(context, fg);

    Widget content = isLoading
        ? SizedBox.square(
            dimension: _loaderSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(fg),
            ),
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(label, style: textStyle),
                if (trailingIcon != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  trailingIcon!,
                ],
              ],
            ),
          );

    final button = GestureDetector(
      onTap: (isDisabled || isLoading) ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(shapes.buttonRadius),
          border: border != null ? Border.fromBorderSide(border) : null,
        ),
        child: Center(child: content),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }

  Color _backgroundColor(ColorScheme cs, bool disabled) {
    if (disabled) {
      return switch (variant) {
        AppButtonVariant.primary => cs.onSurface.withValues(alpha: 0.12),
        AppButtonVariant.secondary || AppButtonVariant.text => Colors.transparent,
      };
    }
    return switch (variant) {
      AppButtonVariant.primary => cs.primary,
      AppButtonVariant.secondary || AppButtonVariant.text => Colors.transparent,
    };
  }

  Color _foregroundColor(ColorScheme cs, bool disabled) {
    if (disabled) return cs.onSurface.withValues(alpha: 0.38);
    return switch (variant) {
      AppButtonVariant.primary => cs.onPrimary,
      AppButtonVariant.secondary || AppButtonVariant.text => cs.primary,
    };
  }

  BorderSide? _borderSide(ColorScheme cs, bool disabled) {
    if (variant != AppButtonVariant.secondary) return null;
    final color = disabled
        ? cs.onSurface.withValues(alpha: 0.12)
        : cs.outline;
    return BorderSide(color: color);
  }

  EdgeInsets _padding() => switch (size) {
        AppButtonSize.small => const EdgeInsets.symmetric(
            horizontal: AppSpacing.base, vertical: AppSpacing.xs),
        AppButtonSize.medium => const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        AppButtonSize.large => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl2, vertical: AppSpacing.base),
      };

  double _loaderSize() => switch (size) {
        AppButtonSize.small => 14,
        AppButtonSize.medium => 16,
        AppButtonSize.large => 20,
      };

  TextStyle _textStyle(BuildContext context, Color color) {
    final tt = Theme.of(context).textTheme;
    return switch (size) {
      AppButtonSize.small  => tt.labelSmall!.copyWith(color: color),
      AppButtonSize.medium => tt.labelMedium!.copyWith(color: color),
      AppButtonSize.large  => tt.labelLarge!.copyWith(color: color),
    };
  }
}
