import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

/// Mirrors [HomeCategorySection] + [HomePopularItemsSection]'s silhouette —
/// a circle-tile rail, then a product-card rail — so the loading state
/// doesn't jump in layout once real data replaces it.
class HomeSkeletonBody extends StatelessWidget {
  const HomeSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(
      Theme.of(context).extension<AppShapes>()?.cardRadius ?? AppRadius.xlValue,
    );
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xl4,
        bottom: AppSpacing.xl10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ShimmerBox(width: 120, height: 20),
          ),
          const SizedBox(height: AppSpacing.base),
          SizedBox(
            height: 64 + AppSpacing.xs + 14,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: AppSpacing.lg),
              itemCount: 6,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.lg),
              itemBuilder: (context, index) => const Column(
                children: [
                  ShimmerBox.circle(size: 64),
                  SizedBox(height: AppSpacing.xs),
                  ShimmerBox(width: 48, height: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ShimmerBox(width: 140, height: 20),
          ),
          const SizedBox(height: AppSpacing.base),
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: AppSpacing.lg),
              itemCount: 4,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.base),
              itemBuilder: (context, index) =>
                  ShimmerBox(width: 184, height: 230, borderRadius: cardRadius),
            ),
          ),
        ],
      ),
    );
  }
}
