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
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cs.primaryContainer.withValues(alpha: 0.35),
        borderRadius: AppRadius.full,
        border: Border.all(color: cs.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            iconBuilder: decrementIconBuilder,
            onTap: onDecrement,
            iconColor: iconColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs2),
            child: Text(
              '$value',
              style: valueTextStyle ??
                  tt.titleMedium!.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            iconBuilder: incrementIconBuilder,
            onTap: onIncrement,
            iconColor: iconColor,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Widget Function(Color color, double size)? iconBuilder;
  final VoidCallback? onTap;
  final Color? iconColor;

  static const double _iconSize = 18;

  const _StepButton({
    required this.icon,
    this.iconBuilder,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final resolvedColor = onTap == null
        ? cs.onSurface.withValues(alpha: 0.38)
        : (iconColor ?? cs.primary);

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: iconBuilder != null
            ? SizedBox(
                width: _iconSize,
                height: _iconSize,
                child: iconBuilder!(resolvedColor, _iconSize),
              )
            : Icon(icon, size: _iconSize, color: resolvedColor),
      ),
    );
  }
}
