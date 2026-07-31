import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

import '../constants/dailymart_dimen_const.dart';

/// Skeleton silhouette of a 2-column grid of [DailyMartProductCard]s —
/// shared by every dailymart screen whose loading state includes the
/// product grid (Home, Search, Product Details' related grid), the same
/// split as gravia's `GraviaProductGridSkeleton`. Sizes against the card's
/// own dimen constants so the grid doesn't reflow when real cards land.
class DailyMartProductGridSkeleton extends StatelessWidget {
  final int itemCount;

  const DailyMartProductGridSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final shapes =
        context.appShapes;
    final cardRadius = BorderRadius.circular(shapes.cardRadius);

    return ChunkedGrid(
      itemCount: itemCount,
      columns: 2,
      spacing: AppSpacing.base,
      runSpacing: AppSpacing.lg,
      itemBuilder: (context, index) => ShimmerBox(
        width: double.infinity,
        height:
            DailyMartDimenConst.productImageHeight +
            DailyMartDimenConst.productCardChromeHeight,
        borderRadius: cardRadius,
      ),
    );
  }
}
