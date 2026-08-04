import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';

class GrofastNotificationsSkeletonBody extends StatelessWidget {
  const GrofastNotificationsSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const GrofastCardSkeleton(
        width: 200,
        height: GrofastDimenConst.bigChipHeight,
        radius: GrofastDimenConst.tileRadius,
      ),
      const SizedBox(height: AppSpacing.xl4),
      for (var i = 0; i < 4; i++) ...[
        if (i > 0) const SizedBox(height: AppSpacing.base),
        const GrofastCardSkeleton(
          height: GrofastDimenConst.orderCardHeight,
          radius: GrofastDimenConst.tileRadius,
        ),
      ],
    ],
  );
}
