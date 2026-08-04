import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid_skeleton.dart';

/// Mirrors the browse state's silhouette — recent-search rows, then the
/// 2-column product grid — so nothing jumps when real data lands. The
/// search field row is rendered by the screen itself in both states and is
/// not shimmered (spec sheet §14).
class DailyMartSearchSkeletonBody extends StatelessWidget {
  const DailyMartSearchSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerSectionHeader(),
          const SizedBox(height: AppSpacing.lg),
          const ShimmerListRow(itemCount: 3, leadingSize: AppSpacing.xl2),
          const SizedBox(height: AppSpacing.xl4),
          const ShimmerSectionHeader(),
          const SizedBox(height: AppSpacing.lg),
          const DailyMartProductGridSkeleton(itemCount: 4),
        ],
      ),
    );
  }
}
