import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// Mirrors the loaded My Orders list — three cards in the real
/// [DailyMartOrderCard] silhouette (tinted radius-16 block, 88px thumbnail,
/// name/count/price stack), so nothing reflows when the orders land.
class DailyMartOrdersSkeletonBody extends StatelessWidget {
  const DailyMartOrdersSkeletonBody({super.key});

  static const _cardCount = 3;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (var i = 0; i < _cardCount; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: cs.surfaceContainer.withValues(alpha: 0.8),
              borderRadius: AppRadius.xl,
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: DailyMartDimenConst.orderThumbSize,
                  height: DailyMartDimenConst.orderThumbSize,
                  borderRadius: AppRadius.lg,
                ),
                SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 120, height: 18),
                      SizedBox(height: AppSpacing.xs),
                      ShimmerBox(width: 64, height: 14),
                      SizedBox(height: AppSpacing.base),
                      Row(
                        children: [
                          ShimmerBox(width: 80, height: 18),
                          Spacer(),
                          ShimmerBox(
                            width: 98,
                            height: DailyMartDimenConst.orderTrackButtonHeight,
                            borderRadius: AppRadius.md,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
