import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// The All Categories grid cell: a square pastel tile at radius 28 with the
/// artwork floating in the upper half and the name at the bottom-left
/// (spec sheet §10).
///
/// The tint comes from `cs.categoryTint(index)` — the kit hand-assigns a
/// different pastel per category and the backend has no tint field, so the
/// pack cycles a fixed ramp by position instead (spec sheet §1).
///
/// Deliberately **not** core's `blocks/ecommerce/category_tile.dart`, which
/// is a circular image on a disc with the label underneath; this is a filled
/// square with the label inside it, and the two share no geometry
/// (spec sheet §12).
class GrofastCategoryTile extends StatelessWidget {
  final CategoryEntity category;

  /// Position in the grid — picks the tint.
  final int index;
  final VoidCallback? onTap;

  const GrofastCategoryTile({
    super.key,
    required this.category,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return Material(
      color: cs.categoryTint(index),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.45),
                child: SizedBox.square(
                  dimension:
                      constraints.maxWidth *
                      GrofastDimenConst.categoryArtworkFraction,
                  child: AppNetworkImage(
                    url: category.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.xl,
                right: AppSpacing.base,
                bottom: AppSpacing.xl,
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GrofastTextStyleConst.rowTitleBold(tt),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Home's category rail entry — the same tinted square at a smaller size,
/// with the label **below** the tile rather than inside it.
class GrofastCategoryRailTile extends StatelessWidget {
  final CategoryEntity category;
  final int index;
  final VoidCallback? onTap;

  /// Draws the tile with the pack's primary outline — Category Details uses
  /// the same rail to show which category is open.
  final bool isSelected;

  const GrofastCategoryRailTile({
    super.key,
    required this.category,
    required this.index,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: GrofastDimenConst.categoryRailTileSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: GrofastDimenConst.categoryRailTileSize,
              height: GrofastDimenConst.categoryRailTileSize,
              decoration: BoxDecoration(
                color: cs.categoryTint(index),
                borderRadius: radius,
                border: isSelected
                    ? Border.all(color: cs.primary, width: 1.5)
                    : null,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppNetworkImage(
                url: category.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GrofastTextStyleConst.bodySmall(
                tt,
              ).copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
