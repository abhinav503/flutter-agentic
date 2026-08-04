import 'package:flutter/material.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';

/// First-load skeleton — the same square grid at the same aspect ratio, so
/// nothing reflows when the tiles land.
class GrofastCategoriesSkeletonBody extends StatelessWidget {
  const GrofastCategoriesSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: GrofastDimenConst.gridColumnGap,
          mainAxisSpacing: GrofastDimenConst.gridRowGap,
          childAspectRatio: GrofastDimenConst.categoryGridAspectRatio,
        ),
        itemBuilder: (context, index) => const GrofastCardSkeleton(
          height: double.infinity,
          radius: GrofastDimenConst.tileRadius,
        ),
      ),
    ],
  );
}
