import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// Mirrors the loaded Home's silhouette — promo card, category rail, then the
/// 2-column product grid — so nothing jumps when real data replaces it. The
/// header is rendered by the screen itself in both states and is not
/// shimmered (spec sheet §14).
class DailyMartHomeSkeletonBody extends StatelessWidget {
  const DailyMartHomeSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final cardRadius = BorderRadius.circular(shapes.cardRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeaderSkeleton(),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: LayoutBuilder(
            builder: (context, constraints) => ShimmerBox(
              width:
                  constraints.maxWidth *
                  DailyMartDimenConst.promoViewportFraction,
              height: DailyMartDimenConst.promoCardHeight,
              borderRadius: cardRadius,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl4),
        const _SectionHeaderSkeleton(),
        const SizedBox(height: AppSpacing.lg),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Row(
            children: [
              for (var i = 0; i < 5; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                const ShimmerBox(
                  width: DailyMartDimenConst.categoryTileWidth,
                  height: DailyMartDimenConst.categoryTileHeight,
                  borderRadius: AppRadius.sm,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl4),
        const _SectionHeaderSkeleton(),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ChunkedGrid(
            itemCount: 4,
            columns: 2,
            spacing: AppSpacing.base,
            runSpacing: AppSpacing.lg,
            itemBuilder: (context, index) => ShimmerBox(
              // The card's own height: image well + name/price block +
              // padding. Guessing lower would make the grid shift upward
              // when the real cards land.
              width: double.infinity,
              height: DailyMartDimenConst.productImageHeight + AppSpacing.xl11,
              borderRadius: cardRadius,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShimmerBox(width: 140, height: 20),
        ShimmerBox(width: 64, height: 28, borderRadius: AppRadius.sm),
      ],
    ),
  );
}
