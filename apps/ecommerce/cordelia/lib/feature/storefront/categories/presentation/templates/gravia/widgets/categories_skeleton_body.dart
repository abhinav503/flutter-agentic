import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

/// Mirrors [CategoryGroupSection]'s silhouette — a title bar above a
/// 4-column grid of circle tiles — repeated for two groups, matching a
/// typical grouped-categories response.
class CategoriesSkeletonBody extends StatelessWidget {
  const CategoriesSkeletonBody({super.key});

  static const _kColumns = 4;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
    child: Column(
      children: [
        for (var i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.xl4),
          _groupSkeleton(),
        ],
      ],
    ),
  );

  Widget _groupSkeleton() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: 140, height: 18),
        const SizedBox(height: AppSpacing.base),
        for (var row = 0; row < 2; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (var col = 0; col < _kColumns; col++) ...[
                if (col > 0) const SizedBox(width: AppSpacing.xs),
                const Expanded(
                  child: Column(
                    children: [
                      ShimmerBox.circle(size: 64),
                      SizedBox(height: AppSpacing.xs),
                      ShimmerBox(width: 40, height: 12),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    ),
  );
}
