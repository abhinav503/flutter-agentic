import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:gravia/widgets/gravia_product_rail_skeleton.dart';

/// Mirrors the loaded browse layout's two sections: a Recent Search block
/// (title + text rows, matching [RecentSearchSection]'s row height) above
/// [HomePopularItemsSection]'s rail silhouette.
class SearchSkeletonBody extends StatelessWidget {
  static const int _recentRowCount = 3;

  /// Matches [RecentSearchSection]'s fixed row height.
  static const double _recentRowHeight = 20;

  const SearchSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ShimmerBox(width: 140, height: _recentRowHeight),
          ),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < _recentRowCount; i++)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: ShimmerBox(
                width: double.infinity,
                height: _recentRowHeight,
              ),
            ),
          const SizedBox(height: AppSpacing.xl4),
          const GraviaProductRailSkeleton(),
        ],
      ),
    );
  }
}
