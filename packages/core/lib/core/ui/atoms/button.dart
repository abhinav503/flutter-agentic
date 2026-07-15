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
  final TextStyle? labelStyle;

  /// A fully separate tappable widget (e.g. a glass [AppIconButton]) docked
  /// to the pill's trailing edge, with its own tap region — unlike
  /// [trailingIcon], which is a decorative glyph inside the label's own tap
  /// zone. Kept distinct so nesting an interactive widget here never competes
  /// with the button's own [GestureDetector] for the same pointer.
  /// Requires [fullWidth] (the label side needs a bounded width to expand
  /// into) — pass both together.
  final Widget? trailingAction;

  /// Pins the pill to an exact height instead of letting padding + content
  /// determine it — for matching an exact design spec (e.g. docking next to
  /// a fixed-size [trailingAction]). Omit to keep the default content-driven
  /// height.
  final double? height;

  /// Overrides the theme's `AppShapes.buttonRadius` — for a caller whose
  /// design spec always wants a specific radius (e.g. a full pill CTA)
  /// regardless of the active style pack's button shape.
  final BorderRadius? borderRadius;

  /// [AppButtonVariant.secondary] only — overrides the default `cs.outline`
  /// border colour. Some outline pills are spec'd as a brand-coloured
  /// outline (e.g. an "Add" CTA whose border matches its green icon/label)
  /// rather than the neutral outline every other secondary button uses.
  final Color? borderColor;

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
    this.labelStyle,
    this.trailingAction,
    this.height,
    this.borderRadius,
    this.borderColor,
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

    final decoration = BoxDecoration(
      color: bg,
      borderRadius: borderRadius ?? BorderRadius.circular(shapes.buttonRadius),
      border: border != null ? Border.fromBorderSide(border) : null,
    );

    final button = trailingAction == null
        ? GestureDetector(
            onTap: (isDisabled || isLoading) ? null : onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: padding,
              decoration: decoration,
              child: Center(child: content),
            ),
          )
        : AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            // Left padding keeps the label's usual inset. Right padding is
            // halved so trailingAction docks close to the pill's trailing
            // edge instead of sitting inset by a full padding step. Vertical
            // padding is dropped when `height` is fixed — it would otherwise
            // eat into that fixed height, leaving trailingAction less room
            // than its own intrinsic size and squashing it (e.g. a circular
            // icon button rendering as an oval).
            padding: EdgeInsets.only(
              left: padding.left,
              right: padding.right / 2,
              top: height != null ? 0 : padding.top,
              bottom: height != null ? 0 : padding.bottom,
            ),
            decoration: decoration,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (isDisabled || isLoading) ? null : onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Center(child: content),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs2),
                trailingAction!,
              ],
            ),
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: button,
    );
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
        : (borderColor ?? cs.outline);
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
    final base = labelStyle ??
        switch (size) {
          AppButtonSize.small  => tt.labelSmall!,
          AppButtonSize.medium => tt.labelMedium!,
          AppButtonSize.large  => tt.labelLarge!,
        };
    return base.copyWith(color: labelStyle?.color ?? color);
  }
}
