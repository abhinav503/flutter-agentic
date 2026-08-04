import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';

class GrofastSearchSkeletonBody extends StatelessWidget {
  const GrofastSearchSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ShimmerBox(width: 160, height: AppSpacing.xl5),
      SizedBox(height: AppSpacing.xl2),
      GrofastProductGridSkeleton(),
    ],
  );
}
