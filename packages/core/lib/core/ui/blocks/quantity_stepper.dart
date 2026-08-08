import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Pill − / value / + stepper for cart rows and product detail.
///
/// Passing null for [onDecrement]/[onIncrement] disables that side's tap and
/// dims its icon — the caller decides limits (e.g. min 1, stock max).
///
/// Each side defaults to the Material +/− glyph; pass [decrementIconBuilder]
/// / [incrementIconBuilder] for a custom icon (e.g. an SVG asset) — the
/// builder receives the resolved colour and size, same convention as
/// [AppIconButton.iconBuilder]:
/// ```dart
/// QuantityStepper(
///   value: qty,
///   decrementIconBuilder: (color, size) =>
///       AppSvgImage.asset('assets/icons/minus.svg', color: color, width: size, height: size),
///   incrementIconBuilder: (color, size) =>
///       AppSvgImage.asset('assets/icons/plus.svg', color: color, width: size, height: size),
/// )
/// ```
class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  /// Overrides the +/− icon colour (enabled state) — for a caller whose
  /// spec calls out a fixed neutral shade (e.g. `gravia`'s Gray/700, same
  /// in both light and dark) rather than the theme's `primary` role. Omit
  /// (default) to use the role.
  final Color? iconColor;

  final Widget Function(Color color, double size)? decrementIconBuilder;
  final Widget Function(Color color, double size)? incrementIconBuilder;

  /// Overrides the count's text style — for a caller whose spec calls out
  /// exact typography (e.g. `gravia`'s Text/md/bold) rather than the
  /// theme's `titleMedium` role. Omit (default) to use the role.
  final TextStyle? valueTextStyle;

  /// Pins the pill to an exact height instead of letting icon padding +
  /// content determine it — for docking next to a fixed-height sibling
  /// (e.g. an [AppButton] with its own `height` override). Omit to keep the
  /// default content-driven height.
  final double? height;

  /// Set false for a **bare** stepper: no pill container at all — no fill,
  /// border, or radius — just the − / value / + row. For packs whose kit
  /// draws the controls directly on the host surface (or draws its own
  /// container around them).
  final bool showContainer;

  /// Container fill override (default `primaryContainer` @ 0.35). Ignored
  /// when [showContainer] is false.
  final Color? backgroundColor;

  /// Container border colour override (default `cs.primary`); pass
  /// transparent for a fill-only pill. Ignored when [showContainer] is false.
  final Color? borderColor;

  /// Container radius override (default the full pill). Ignored when
  /// [showContainer] is false.
  final BorderRadius? borderRadius;

  /// Pins each step key to an exact square edge instead of the
  /// padding-driven default — for kits whose keys are fixed-size squares or
  /// discs.
  final double? buttonSize;

  /// Step-key silhouette (default a circle) — e.g. a small rounded square.
  final BorderRadius? buttonRadius;

  /// Step-key fill (default none — the key is a bare glyph on the pill).
  final Color? buttonColor;

  /// Glyph size inside each step key (default 18).
  final double iconSize;

  /// Gap either side of the count (default [AppSpacing.xs2]).
  final double? valueGap;

  const QuantityStepper({
    super.key,
    required this.value,
    this.onIncrement,
    this.onDecrement,
    this.iconColor,
    this.decrementIconBuilder,
    this.incrementIconBuilder,
    this.valueTextStyle,
    this.height,
    this.showContainer = true,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.buttonSize,
    this.buttonRadius,
    this.buttonColor,
    this.iconSize = 18,
    this.valueGap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          iconBuilder: decrementIconBuilder,
          onTap: onDecrement,
          iconColor: iconColor,
          size: buttonSize,
          radius: buttonRadius,
          fillColor: buttonColor,
          iconSize: iconSize,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: valueGap ?? AppSpacing.xs2),
          child: Text(
            '$value',
            style:
                valueTextStyle ??
                tt.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          iconBuilder: incrementIconBuilder,
          onTap: onIncrement,
          iconColor: iconColor,
          size: buttonSize,
          radius: buttonRadius,
          fillColor: buttonColor,
          iconSize: iconSize,
        ),
      ],
    );

    if (!showContainer) {
      return height == null ? row : SizedBox(height: height, child: row);
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: borderRadius ?? AppRadius.full,
        border: Border.all(color: borderColor ?? cs.primary),
      ),
      child: row,
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Widget Function(Color color, double size)? iconBuilder;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double? size;
  final BorderRadius? radius;
  final Color? fillColor;
  final double iconSize;

  const _StepButton({
    required this.icon,
    this.iconBuilder,
    this.onTap,
    this.iconColor,
    this.size,
    this.radius,
    this.fillColor,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final resolvedColor = onTap == null
        ? cs.onSurface.withValues(alpha: 0.38)
        : (iconColor ?? cs.primary);

    final glyph = iconBuilder != null
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: iconBuilder!(resolvedColor, iconSize),
          )
        : Icon(icon, size: iconSize, color: resolvedColor);

    final shape = radius != null
        ? RoundedRectangleBorder(borderRadius: radius!)
        : const CircleBorder() as ShapeBorder;

    // A fixed [size] centres the glyph in an exact square key; the default
    // keeps the padding-driven hit area.
    final content = size != null
        ? SizedBox.square(
            dimension: size,
            child: Center(child: glyph),
          )
        : Padding(padding: const EdgeInsets.all(AppSpacing.sm), child: glyph);

    if (fillColor == null) {
      return InkWell(onTap: onTap, customBorder: shape, child: content);
    }
    return Material(
      color: fillColor,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, customBorder: shape, child: content),
    );
  }
}
