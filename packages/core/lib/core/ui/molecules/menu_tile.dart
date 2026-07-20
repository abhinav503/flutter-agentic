import 'package:flutter/material.dart';

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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: iconCircleSize,
              height: iconCircleSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: iconBuilder(foregroundColor, iconSize),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Text(
                label,
                style:
                    labelStyle ??
                    tt.bodyLarge!.copyWith(color: foregroundColor),
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
        ),
      ),
    );
  }
}
