import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// DailyMart's circular icon control — [AppIconButton] with the pack's two
/// disc recipes baked in, so no screen re-types the size/colour override
/// quartet (this is exactly how gravia's Home discs drifted to their own
/// icon size).
///
/// - [DailyMartIconDisc] — the default: a neutral `surfaceContainer` fill,
///   48px, dark glyph. Back buttons and sheet-close buttons.
/// - [DailyMartIconDisc.outlined] — transparent with a 1px `outline` ring,
///   52px. Home's notification bell.
///
/// Pass exactly one of [asset] (a kit SVG — the usual case) or [icon] (a
/// Material fallback for a glyph the kit hasn't exported yet), same
/// convention as [CordeliaGlassIconButton].
///
/// The pack has no glass variant (spec sheet §6), which is why this wrapper
/// never reaches for [AppIconButtonVariant.glass].
class DailyMartIconDisc extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final bool _outlined;

  const DailyMartIconDisc({
    super.key,
    this.asset,
    this.icon,
    this.onTap,
    this.size = DailyMartDimenConst.controlHeight,
    this.iconSize = 24,
  }) : _outlined = false,
       assert(
         (asset == null) != (icon == null),
         'DailyMartIconDisc requires exactly one of asset or icon',
       );

  const DailyMartIconDisc.outlined({
    super.key,
    this.asset,
    this.icon,
    this.onTap,
    this.size = DailyMartDimenConst.headerControlHeight,
    this.iconSize = 24,
  }) : _outlined = true,
       assert(
         (asset == null) != (icon == null),
         'DailyMartIconDisc requires exactly one of asset or icon',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppIconButton(
      icon: icon,
      iconBuilder: asset == null
          ? null
          : (color, iconSize) => AppSvgImage.asset(
              asset!,
              color: color,
              width: iconSize,
              height: iconSize,
            ),
      onTap: onTap,
      containerSize: size,
      iconSize: iconSize,
      backgroundColor: _outlined ? Colors.transparent : cs.surfaceContainer,
      // Both discs sit on a light surface, so the atom's default white
      // `onOverlay` foreground would vanish — the glyph takes the ink role.
      foregroundColor: cs.onSurface,
      borderColor: _outlined ? cs.outline : null,
    );
  }
}
