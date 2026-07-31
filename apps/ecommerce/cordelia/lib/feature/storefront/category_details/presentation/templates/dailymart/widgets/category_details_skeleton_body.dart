import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid_skeleton.dart';

/// Category Details' loading state — the loaded layout with its content
/// shimmered, not a spinner: the result-count row over the product grid, at
/// the same padding, so nothing shifts when the real products land.
class DailyMartCategoryDetailsSkeletonBody extends StatelessWidget {
  const DailyMartCategoryDetailsSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerSectionHeader(),
        SizedBox(height: AppSpacing.lg),
        DailyMartProductGridSkeleton(),
      ],
    ),
  );
}
