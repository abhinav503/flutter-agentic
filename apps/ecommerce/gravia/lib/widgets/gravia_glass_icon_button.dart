import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

/// Gravia's glass header action — [AppIconButton]'s glass variant with the
/// pack's SVG wiring and header-control sizing (45px disc, 20px icon) baked
/// in, so every hero-header control (back, search, favourite, notification)
/// is one line instead of a re-typed variant/size/iconBuilder recipe that
/// drifts (Home's discs had already drifted to a 25px icon — kept via
/// [iconSize]).
///
/// ```dart
/// GraviaGlassIconButton(asset: ImageConst.arrowLeft, onTap: onBack)
/// ```
class GraviaGlassIconButton extends StatelessWidget {
  /// Header-control disc diameter — also what [GraviaHeroHeader] uses to
  /// mirror an invisible spacer opposite the back button.
  static const double containerSize = 45;

  final String asset;
  final VoidCallback? onTap;
  final double iconSize;

  const GraviaGlassIconButton({
    super.key,
    required this.asset,
    this.onTap,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) => AppIconButton(
    variant: AppIconButtonVariant.glass,
    containerSize: containerSize,
    iconSize: iconSize,
    iconBuilder: (color, size) =>
        AppSvgImage.asset(asset, color: color, width: size, height: size),
    onTap: onTap,
  );
}
