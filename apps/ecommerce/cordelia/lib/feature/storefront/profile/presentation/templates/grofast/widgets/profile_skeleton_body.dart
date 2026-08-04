import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';

class GrofastProfileSkeletonBody extends StatelessWidget {
  const GrofastProfileSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const ShimmerBox.circle(size: GrofastDimenConst.profileAvatarSize),
      const SizedBox(height: AppSpacing.lg),
      const ShimmerBox(width: 160, height: AppSpacing.xl4),
      const SizedBox(height: AppSpacing.xs),
      const ShimmerBox(width: 200, height: AppSpacing.lg),
      const SizedBox(height: AppSpacing.xl6),
      Row(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.base),
            const Expanded(
              child: GrofastCardSkeleton(
                height: GrofastDimenConst.quickTileHeight,
                radius: GrofastDimenConst.tileRadius,
              ),
            ),
          ],
        ],
      ),
      const SizedBox(height: AppSpacing.xl4),
      for (var i = 0; i < 4; i++) ...[
        if (i > 0) const SizedBox(height: AppSpacing.base),
        const GrofastCardSkeleton(
          height: GrofastDimenConst.menuRowHeight,
          radius: GrofastDimenConst.tileRadius,
        ),
      ],
    ],
  );
}
