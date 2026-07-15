import 'package:flutter/material.dart';

import '../../theme/app_colors_extension.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'common_glass_surface.dart';

/// Frosted-glass pill button for label content (an icon, a label, an
/// optional trailing glyph) — a filter/sort trigger sitting on a coloured
/// header canvas, not a circular icon-only action. Built on
/// [CommonGlassSurface] for the same real "liquid glass" treatment
/// (backdrop blur + inset top-glow/bottom-shadow rim + gradient border) used
/// by [AppTextField] via `SearchFieldBar` — not a flat tinted box with a
/// plain border.
///
/// ```dart
/// AppGlassChip(
///   leading: const Icon(Icons.swap_vert),
///   label: 'Sort',
///   trailing: const Icon(Icons.keyboard_arrow_down),
///   onTap: () => ...,
/// )
/// ```
class AppGlassChip extends StatelessWidget {
  final Widget? leading;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;

  /// Foreground colour for the default label style, any [leading]/
  /// [trailing] icon that doesn't set its own colour, and the glass tint.
  /// Omit to use `AppColorsExtension.onOverlay` — correct for the usual case
  /// of a chip sitting on a solid `cs.primary` canvas.
  final Color? foregroundColor;
  final double blurSigma;

  /// Pins the pill to an exact height instead of letting padding + content
  /// determine it — for matching an exact design spec (e.g. the same row
  /// height as a nearby [AppTextField]/glass search field), same reasoning
  /// as [AppButton]'s `height` override.
  final double? height;

  const AppGlassChip({
    super.key,
    required this.label,
    this.leading,
    this.trailing,
    this.onTap,
    this.labelStyle,
    this.foregroundColor,
    this.blurSigma = 12,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ??
        Theme.of(context).extension<AppColorsExtension>()!.onOverlay;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: CommonGlassSurface(
          borderRadius: AppRadius.full,
          tintColor: fg,
          blurSigma: blurSigma,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.base,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  IconTheme(data: IconThemeData(color: fg, size: 16), child: leading!),
                  const SizedBox(width: AppSpacing.xs3),
                ],
                if (leading == null) ...[
                  const SizedBox(width: AppSpacing.xs3),
                ],
                Text(
                  label,
                  style: (labelStyle ?? Theme.of(context).textTheme.labelMedium)!
                      .copyWith(color: fg),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppSpacing.xs4),
                  IconTheme(data: IconThemeData(color: fg, size: 18), child: trailing!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
