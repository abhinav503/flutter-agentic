import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/menu_tile.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';

/// Gravia's Profile menu row — core's [AppMenuTile] with the pack's spec
/// baked in: Gray/50-light / Gray/950-dark icon circle, Text/md/medium
/// label, and the kit's own chevron SVG.
class ProfileMenuTile extends StatelessWidget {
  /// Same convention as [AppMenuTile.iconBuilder] — most rows pass an
  /// `AppSvgImage.asset`, but a row without a dedicated kit SVG yet (e.g.
  /// "My Cards") can pass a plain `Icon` instead.
  final Widget Function(Color color, double size) iconBuilder;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool danger;

  const ProfileMenuTile({
    super.key,
    required this.iconBuilder,
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
      label: label,
      onTap: onTap,
      trailing: trailing,
      danger: danger,
      iconCircleColor: danger
          ? null // keep AppMenuTile's themed error tint
          : cs.surfaceContainerLow,
      labelStyle: TextStyleConst.textMdMedium(
        tt,
      ).copyWith(color: danger ? cs.error : cs.onSurface),
      chevron: AppSvgImage.asset(
        ImageConst.directionRight,
        color: cs.onSurfaceVariant,
        width: 18,
        height: 18,
      ),
    );
  }
}
