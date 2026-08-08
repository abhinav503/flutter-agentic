import 'package:flutter/material.dart';

import '../atoms/icon_circle.dart';

import '../../theme/app_spacing.dart';

/// One row of a settings/profile menu: an icon on a circle, a label, and a
/// trailing chevron (navigable) or arbitrary trailing content (e.g. a
/// switch). [danger] tints the whole row with the error colour for a
/// destructive action (Logout, Delete account).
///
/// Style packs override [labelStyle]/[iconCircleColor]/[chevron] (or wrap
/// this in an app preset that bakes their spec in); the defaults read the
/// theme.
///
/// ```dart
/// AppMenuTile(
///   iconBuilder: (color, size) => Icon(Icons.lock_outline, color: color, size: size),
///   label: 'Change Password',
///   onTap: () => ...,
/// )
/// ```
class AppMenuTile extends StatelessWidget {
  /// Receives the resolved foreground colour + icon size — pass an SVG asset
  /// or a plain [Icon].
  final Widget Function(Color color, double size) iconBuilder;
  final String label;
  final VoidCallback? onTap;

  /// Replaces the default chevron; use for non-navigation rows (a switch, a
  /// value readout).
  final Widget? trailing;
  final bool danger;
  final TextStyle? labelStyle;
  final Color? iconCircleColor;
  final double iconCircleSize;
  final double iconSize;

  /// Shown when the row navigates ([onTap] set, no [trailing]).
  final Widget? chevron;

  /// Set false to render the glyph bare (no [AppIconCircle]) — for packs
  /// whose rows are a bordered/filled strip rather than a disc on a plain
  /// surface. The glyph keeps [iconSize] and the row keeps its gap.
  final bool showIconCircle;

  /// Pins the row to an exact height (content centred) — for kits whose
  /// menu rows are fixed-height strips. Omit for the padding-driven default.
  final double? height;

  /// Paints the row as its own surface: fill, outline, and corner radius.
  /// All three default to nothing, keeping today's bare row on the host
  /// surface. [padding] then insets content from the strip's edge.
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  /// Gap between the leading glyph and the label (default [AppSpacing.base]).
  final double gap;

  const AppMenuTile({
    super.key,
    required this.iconBuilder,
    required this.label,
    this.onTap,
    this.trailing,
    this.danger = false,
    this.labelStyle,
    this.iconCircleColor,
    this.iconCircleSize = 44,
    this.iconSize = 20,
    this.chevron,
    this.showIconCircle = true,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.gap = AppSpacing.base,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final circleColor =
        iconCircleColor ??
        (danger
            ? cs.error.withValues(alpha: 0.12)
            : cs.surfaceContainerHighest);
    final foregroundColor = danger ? cs.error : cs.onSurface;

    final row = Row(
      children: [
        if (showIconCircle)
          AppIconCircle(
            size: iconCircleSize,
            color: circleColor,
            child: iconBuilder(foregroundColor, iconSize),
          )
        else
          iconBuilder(foregroundColor, iconSize),
        SizedBox(width: gap),
        Expanded(
          child: Text(
            label,
            style: labelStyle ?? tt.bodyLarge!.copyWith(color: foregroundColor),
          ),
        ),
        trailing ??
            (onTap != null
                ? (chevron ??
                      Icon(
                        Icons.chevron_right,
                        color: cs.onSurfaceVariant,
                        size: 18,
                      ))
                : const SizedBox.shrink()),
      ],
    );

    final decorated =
        backgroundColor != null ||
            borderColor != null ||
            borderRadius != null ||
            height != null
        ? Container(
            height: height,
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: borderColor != null
                  ? Border.all(color: borderColor!)
                  : null,
              borderRadius: borderRadius,
            ),
            child: row,
          )
        : Padding(
            padding:
                padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: row,
          );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: decorated,
    );
  }
}
