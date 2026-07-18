import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

/// Mirrors the loaded [ChunkedGrid] of [GraviaProductCard]s — a 2-column
/// grid of card-shaped placeholders.
class CategoryDetailsSkeletonBody extends StatelessWidget {
  const CategoryDetailsSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(
      Theme.of(context).extension<AppShapes>()?.cardRadius ?? AppRadius.xlValue,
    );
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.xl4,
        bottom: AppSpacing.xl14,
      ),
      child: ChunkedGrid(
        itemCount: 6,
        columns: 2,
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.lg,
        crossAxisAlignment: CrossAxisAlignment.start,
        itemBuilder: (context, index) => ShimmerBox(
          width: double.infinity,
          height: 260,
          borderRadius: cardRadius,
        ),
      ),
    );
  }
}
