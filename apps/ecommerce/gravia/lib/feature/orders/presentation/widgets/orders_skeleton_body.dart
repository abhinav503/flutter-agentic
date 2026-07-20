import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/dimen_const.dart';

/// Mirrors [OrderCard]'s silhouette — two line-item rows (thumbnail + text +
/// price), a date/total row, and a paired action row — repeated for two
/// orders, matching a typical orders-list response.
class OrdersSkeletonBody extends StatelessWidget {
  const OrdersSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl2,
      ),
      child: Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.xl2),
            _orderCardSkeleton(cs),
          ],
        ],
      ),
    );
  }

  Widget _orderCardSkeleton(ColorScheme cs) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < 2; i++) ...[
        if (i > 0) const SizedBox(height: AppSpacing.base),
        _lineItemSkeleton(),
      ],
      const SizedBox(height: AppSpacing.base),
      Divider(color: cs.sheetHairline, height: 1),
      const SizedBox(height: AppSpacing.base),
      Row(
        children: [
          const ShimmerBox(width: 100, height: 14),
          const Spacer(),
          const ShimmerBox(width: 60, height: 16),
        ],
      ),
      const SizedBox(height: AppSpacing.base),
      Divider(color: cs.sheetHairline, height: 1),
      const SizedBox(height: AppSpacing.lg),
      Row(
        children: [
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: DimenConst.controlHeight,
              borderRadius: AppRadius.full,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: ShimmerBox(
              width: double.infinity,
              height: DimenConst.controlHeight,
              borderRadius: AppRadius.full,
            ),
          ),
        ],
      ),
    ],
  );

  Widget _lineItemSkeleton() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ShimmerBox(width: 56, height: 56, borderRadius: AppRadius.lg),
      const SizedBox(width: AppSpacing.base),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const ShimmerBox(width: 160, height: 16),
            const SizedBox(height: AppSpacing.xs2),
            const ShimmerBox(width: 100, height: 12),
          ],
        ),
      ),
      const SizedBox(width: AppSpacing.base),
      const ShimmerBox(width: 48, height: 16),
    ],
  );
}
