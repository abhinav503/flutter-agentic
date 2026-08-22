import 'package:flutter/material.dart';

import 'package:core/core/ui/atoms/icon_button.dart';

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
/// convention as [GraviaGlassIconButton].
///
/// The pack has no glass variant (spec sheet §6), which is why this wrapper
/// never reaches for [AppIconButtonVariant.glass].
class DailyMartIconDisc extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;

  /// Overrides the glyph's default ink tint — for a stateful glyph (e.g.
  /// the favourite heart taking `cs.error` while favourited).
  final Color? foregroundColor;

  /// Overrides the default disc fill — the preset maps the *sheet* close
  /// disc one ramp step lighter (`surfaceContainerLow`) than the back
  /// disc's `surfaceContainer`.
  final Color? backgroundColor;
  final bool _outlined;

  const DailyMartIconDisc({
    super.key,
    this.asset,
    this.icon,
    this.onTap,
    this.size = DailyMartDimenConst.controlHeight,
    this.iconSize = 24,
    this.foregroundColor,
    this.backgroundColor,
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
    this.foregroundColor,
    this.backgroundColor,
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
      svgAsset: asset,
      onTap: onTap,
      containerSize: size,
      iconSize: iconSize,
      backgroundColor:
          backgroundColor ??
          (_outlined ? Colors.transparent : cs.surfaceContainer),
      // Both discs sit on a light surface, so the atom's default white
      // `onOverlay` foreground would vanish — the glyph takes the ink role.
      foregroundColor: foregroundColor ?? cs.onSurface,
      borderColor: _outlined ? cs.outline : null,
    );
  }
}
