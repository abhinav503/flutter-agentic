import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// Mirrors the browse state's silhouette — recent-search rows, then the
/// 2-column product grid — so nothing jumps when real data lands. The
/// search field row is rendered by the screen itself in both states and is
/// not shimmered (spec sheet §14).
class DailyMartSearchSkeletonBody extends StatelessWidget {
  const DailyMartSearchSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final cardRadius = BorderRadius.circular(shapes.cardRadius);

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
          ChunkedGrid(
            itemCount: 4,
            columns: 2,
            spacing: AppSpacing.base,
            runSpacing: AppSpacing.lg,
            itemBuilder: (context, index) => ShimmerBox(
              width: double.infinity,
              height:
                  DailyMartDimenConst.productImageHeight +
                  DailyMartDimenConst.productCardChromeHeight,
              borderRadius: cardRadius,
            ),
          ),
        ],
      ),
    );
  }
}
