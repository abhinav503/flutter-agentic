import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/widgets/gravia_product_rail_skeleton.dart';

/// Mirrors [HomePopularItemsSection]'s rail silhouette — recent searches is
/// typically empty (no favorites/search-history model yet), so the skeleton
/// focuses on the populated popular-items rail.
class SearchSkeletonBody extends StatelessWidget {
  const SearchSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl4),
      child: GraviaProductRailSkeleton(),
    );
  }
}
