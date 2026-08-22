import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// DailyMart's settings/profile row — a 52px **bordered** strip at radius 12
/// with a 20px glyph, a 14/500 label, and the kit's chevron.
///
/// Deliberately not core's [AppMenuTile]: that molecule's silhouette is a
/// tinted icon *circle* on a bare surface, and this kit draws no circle and
/// an explicit outline instead — every slot would need an override, the same
/// §12 reasoning that keeps `DailyMartProductCard` off core's `ProductCard`.
///
/// Pass exactly one of [asset] (a kit SVG — the usual case) or [icon] (a
/// Material fallback for a row the kit never draws, e.g. My Orders), same
/// convention as [DailyMartIconDisc], so a fallback is visible at the call
/// site rather than hidden inside the wrapper.
///
/// [subtitle] puts a second line under the label and lets the strip grow
/// past its fixed height — Help & Support's rows print the address or number
/// they will open, which is what a shopper falls back to reading when
/// nothing on the device can open it. Rows without one keep the kit's
/// single-line 52px strip exactly.
///
/// [trailing] replaces the chevron (Dark Mode passes a switch); pass
/// [iconColor] for a row whose glyph carries meaning of its own (Logout's
/// red), and [flipIconHorizontally] for the Logout glyph specifically — see
/// [DailyMartImageConst.menuLogout].
class DailyMartMenuTile extends StatelessWidget {
  final String? asset;
  final IconData? icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool flipIconHorizontally;

  const DailyMartMenuTile({
    super.key,
    this.asset,
    this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.flipIconHorizontally = false,
  }) : assert(
         (asset == null) != (icon == null),
         'DailyMartMenuTile requires exactly one of asset or icon',
       );

  static const _iconSize = 20.0;
  static const _chevronSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final tint = iconColor ?? cs.onSurface;
    Widget leading = asset != null
        ? AppSvgImage.asset(
            asset!,
            color: tint,
            width: _iconSize,
            height: _iconSize,
          )
        : Icon(icon, size: _iconSize, color: tint);
    if (flipIconHorizontally) {
      leading = Transform.flip(flipX: true, child: leading);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.lg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lg,
        child: Container(
          // A subtitled row is sized by its content instead: pinning the
          // kit's height would clip the second line, and the strip is the
          // same shape either way.
          height: subtitle == null ? DailyMartDimenConst.menuRowHeight : null,
          constraints: const BoxConstraints(
            minHeight: DailyMartDimenConst.menuRowHeight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: cs.outline),
            borderRadius: AppRadius.lg,
          ),
          child: IconInfoRow(
            leading: leading,
            title: label,
            titleMaxLines: 1,
            titleStyle: DailyMartTextStyleConst.bodySmMedium(
              tt,
            ).copyWith(color: cs.onSurface),
            subtitle: subtitle,
            subtitleMaxLines: 1,
            subtitleStyle: DailyMartTextStyleConst.bodyXsMedium(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
            // The kit stacks the two lines with no gap between them.
            lineGap: 0,
            gap: AppSpacing.xs,
            trailingGap: AppSpacing.xs,
            trailing:
                trailing ??
                AppSvgImage.asset(
                  DailyMartImageConst.chevronRight,
                  color: cs.onSurfaceVariant,
                  width: _chevronSize,
                  height: _chevronSize,
                ),
          ),
        ),
      ),
    );
  }
}
