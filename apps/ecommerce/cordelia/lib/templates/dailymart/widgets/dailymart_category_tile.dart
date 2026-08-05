import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';

/// DailyMart's category entry: a small white photo tile at radius 4 with the
/// label beneath, rails horizontally.
///
/// Not `core`'s `blocks/ecommerce/category_tile.dart` — that block is a
/// circular image on an elevated disc; this pack's is a rounded rectangle
/// with a shadow, and the two share no geometry (spec sheet §12).
class DailyMartCategoryTile extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback? onTap;

  const DailyMartCategoryTile({
    super.key,
    required this.label,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      width: DailyMartDimenConst.categoryTileWidth,
      height: DailyMartDimenConst.categoryTileHeight,
      // Shadow outside the Material — see DailyMartProductCard for why the
      // order matters.
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: AppRadius.sm,
          boxShadow: DailyMartElevation.card,
        ),
        child: Material(
          color: cs.surface,
          borderRadius: AppRadius.sm,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.sm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xs3,
                    AppSpacing.xs3,
                    AppSpacing.xs3,
                    0,
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.sm,
                    child: SizedBox(
                      height: DailyMartDimenConst.categoryImageHeight,
                      width: double.infinity,
                      child: AppNetworkImage(url: imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs3,
                      ),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        // Two lines — store category names run long and the
                        // tile is only 78 wide. categoryTileHeight is sized
                        // to fit both lines; changing one without the other
                        // overflows.
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: DailyMartTextStyleConst.bodyXsMedium(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
