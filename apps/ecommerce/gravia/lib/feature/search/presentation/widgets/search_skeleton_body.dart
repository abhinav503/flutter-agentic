import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

/// Mirrors [HomePopularItemsSection]'s rail silhouette — recent searches is
/// typically empty (no favorites/search-history model yet), so the skeleton
/// focuses on the populated popular-items rail.
class SearchSkeletonBody extends StatelessWidget {
  const SearchSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(
      Theme.of(context).extension<AppShapes>()?.cardRadius ?? AppRadius.xlValue,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
