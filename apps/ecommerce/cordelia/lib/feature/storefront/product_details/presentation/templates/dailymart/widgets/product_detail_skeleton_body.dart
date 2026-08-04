import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid_skeleton.dart';

/// Mirrors the loaded Product Details silhouette — image well, name/price
/// lines, the tab bar, body copy, then the related grid — so nothing jumps
/// when real data lands. The header row is rendered by the screen itself in
/// both states and is not shimmered (spec sheet §14).
class DailyMartProductDetailSkeletonBody extends StatelessWidget {
  const DailyMartProductDetailSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(
          width: double.infinity,
          height: DailyMartDimenConst.detailImageHeight,
          borderRadius: AppRadius.lg,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            ShimmerBox(width: 140, height: 20, borderRadius: AppRadius.sm),
            ShimmerBox(width: 88, height: 32, borderRadius: AppRadius.full),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            ShimmerBox(width: 110, height: 20, borderRadius: AppRadius.sm),
            ShimmerBox(width: 100, height: 24, borderRadius: AppRadius.sm),
          ],
        ),
        const SizedBox(height: AppSpacing.xl4),
        const ShimmerBox(
          width: double.infinity,
          height: 42,
          borderRadius: AppRadius.sm,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.xs),
          const ShimmerBox(
            width: double.infinity,
            height: 14,
            borderRadius: AppRadius.sm,
          ),
        ],
        const SizedBox(height: AppSpacing.xl4),
        const DailyMartProductGridSkeleton(itemCount: 2),
      ],
    );
  }
}
