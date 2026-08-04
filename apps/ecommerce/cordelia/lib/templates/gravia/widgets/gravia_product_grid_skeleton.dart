import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

import '../constants/gravia_dimen_const.dart';

/// Skeleton silhouette of a 2-column [ChunkedGrid] of [GraviaProductCard]s —
/// shared by every gravia screen whose loading state IS a product grid
/// (Favourites, Category Details) so the recipe can't drift between them.
class GraviaProductGridSkeleton extends StatelessWidget {
  static const EdgeInsets defaultPadding = EdgeInsets.all(AppSpacing.lg);

  final EdgeInsets padding;
  final int itemCount;

  const GraviaProductGridSkeleton({
    super.key,
    this.padding = defaultPadding,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(context.appShapes.cardRadius);
    return Padding(
      padding: padding,
      child: ChunkedGrid(
        itemCount: itemCount,
        columns: 2,
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        crossAxisAlignment: CrossAxisAlignment.start,
        itemBuilder: (context, index) => ShimmerBox(
          width: double.infinity,
          height: GraviaDimenConst.gridCardSkeletonHeight,
          borderRadius: cardRadius,
        ),
      ),
    );
  }
}
