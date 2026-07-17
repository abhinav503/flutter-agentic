import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/dimen_const.dart';

/// Gravia's glass header action — [AppIconButton]'s glass variant with the
/// pack's SVG wiring and header-control sizing (45px disc, 20px icon) baked
/// in, so every hero-header control (back, search, favourite, notification)
/// is one line instead of a re-typed variant/size/iconBuilder recipe that
/// drifts (Home's discs had already drifted to a 25px icon — kept via
/// [iconSize]).
///
/// ```dart
/// GraviaGlassIconButton(asset: ImageConst.arrowLeft, onTap: onBack)
/// GraviaGlassIconButton(icon: Icons.tune_rounded, onTap: onFilterTap)
/// ```
class GraviaGlassIconButton extends StatelessWidget {
  /// Header-control disc diameter — also what [GraviaHeroHeader] uses to
  /// mirror an invisible spacer opposite the back button.
  static const double containerSize = DimenConst.controlHeight;

  /// A kit SVG asset — the usual case; every header control has one. Exactly
  /// one of [asset]/[icon] is required.
  final String? asset;

  /// A Material icon fallback for a control the kit has no SVG for yet
  /// (swap to a real asset the moment one exists — see [ImageConst]'s own
  /// convention of falling back to Material icons for exactly this gap).
  final IconData? icon;

  final VoidCallback? onTap;
  final double iconSize;

  const GraviaGlassIconButton({
    super.key,
    this.asset,
    this.icon,
    this.onTap,
    this.iconSize = 20,
  }) : assert(
         (asset == null) != (icon == null),
         'GraviaGlassIconButton requires exactly one of asset or icon',
       );

  @override
  Widget build(BuildContext context) => AppIconButton(
    variant: AppIconButtonVariant.glass,
    containerSize: containerSize,
    iconSize: iconSize,
    icon: icon,
    iconBuilder: asset == null
        ? null
        : (color, size) => AppSvgImage.asset(
            asset!,
            color: color,
            width: size,
            height: size,
          ),
    onTap: onTap,
  );
}
