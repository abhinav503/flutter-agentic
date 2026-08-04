import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// Profile's list row (spec sheet §13): a filled 60px card at the pack's
/// softer 23 (`tileRadius` — the image-well radius, not the 28 card one)
/// carrying a coloured glyph, a muted label and a chevron.
///
/// The glyph keeps its own accent (`cs.primary` for ordinary rows,
/// `cs.error` for Log Out) while the label stays muted — the kit never
/// colours the text, only the icon.
///
/// Not core's [AppMenuTile]: that molecule's silhouette is a tinted icon
/// *circle* on a bare surface, while this kit's row is a filled card with a
/// bare glyph on it. Every slot would need an override, so the wrapper is
/// cheaper than the parameterisation — the same reasoning `DailyMartMenuTile`
/// records for its own fork.
class GrofastMenuTile extends StatelessWidget {
  final String label;

  /// Pack SVG. Mutually exclusive with [icon].
  final String? asset;
  final IconData? icon;
  final VoidCallback? onTap;

  /// Tints the glyph — omit for the pack's default `cs.primary`.
  final Color? iconColor;

  /// Set false on a terminal row (Log Out), which the kit draws without one.
  final bool showChevron;

  /// Control that replaces the chevron on a row that acts in place instead of
  /// navigating (the Dark Mode switch).
  final Widget? trailing;

  const GrofastMenuTile({
    super.key,
    required this.label,
    this.asset,
    this.icon,
    this.onTap,
    this.iconColor,
    this.showChevron = true,
    this.trailing,
  }) : assert(
         (asset == null) != (icon == null),
         'Pass a pack asset or a Material icon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(GrofastDimenConst.tileRadius);
    final glyphColor = iconColor ?? cs.primary;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: GrofastDimenConst.menuRowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
            child: Row(
              children: [
                asset != null
                    ? AppSvgImage.asset(
                        asset!,
                        width: AppSpacing.xl4,
                        height: AppSpacing.xl4,
                        color: glyphColor,
                      )
                    : Icon(icon, size: AppSpacing.xl4, color: glyphColor),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GrofastTextStyleConst.bodyMedium(
                      tt,
                    ).copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                if (trailing != null)
                  trailing!
                else if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    size: AppSpacing.xl4,
                    color: cs.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One of the three square shortcuts under Profile's identity block — glyph
/// over label on the same filled card.
class GrofastQuickTile extends StatelessWidget {
  final String label;
  final String? asset;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const GrofastQuickTile({
    super.key,
    required this.label,
    this.asset,
    this.icon,
    this.iconColor,
    this.onTap,
  }) : assert(
         (asset == null) != (icon == null),
         'Pass a pack asset or a Material icon, not both.',
       );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(GrofastDimenConst.tileRadius);
    final glyphColor = iconColor ?? cs.primary;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: GrofastDimenConst.quickTileHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              asset != null
                  ? AppSvgImage.asset(
                      asset!,
                      width: AppSpacing.xl4,
                      height: AppSpacing.xl4,
                      color: glyphColor,
                    )
                  : Icon(icon, size: AppSpacing.xl4, color: glyphColor),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GrofastTextStyleConst.bodySmall(
                  tt,
                ).copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
