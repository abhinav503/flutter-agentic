import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/menu_tile.dart';
import 'package:core/core/theme/app_spacing.dart';

/// Gravia's Profile menu row — core's [AppMenuTile] with the pack's spec
/// baked in: Gray/50-light / Gray/950-dark icon circle, Text/md/medium
/// label, and the kit's own chevron SVG.
class ProfileMenuTile extends StatelessWidget {
  /// Same convention as [AppMenuTile] — most rows name a kit SVG through
  /// [svgAsset], and a row without one yet (e.g. "My Cards") passes an
  /// [iconBuilder] with a plain `Icon` instead. Exactly one of the two.
  final Widget Function(Color color, double size)? iconBuilder;
  final String? svgAsset;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  const ProfileMenuTile({
    super.key,
    this.iconBuilder,
    this.svgAsset,
    required this.label,
    this.onTap,
    this.trailing,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppMenuTile(
      iconBuilder: iconBuilder,
      svgAsset: svgAsset,
      label: label,
      onTap: onTap,
      trailing: trailing,
      danger: danger,
      iconCircleColor: danger
          ? null // keep AppMenuTile's themed error tint
          : cs.surfaceContainerLow,
      labelStyle: GraviaTextStyleConst.textMdMedium(
        tt,
      ).copyWith(color: danger ? cs.error : cs.onSurface),
      chevron: AppSvgImage.asset(
        GraviaImageConst.directionRight,
        color: cs.onSurfaceVariant,
        width: AppSpacing.xl,
        height: AppSpacing.xl,
      ),
    );
  }
}
