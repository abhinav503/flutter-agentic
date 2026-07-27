import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

/// Mirrors the loaded body's silhouette top-to-bottom: image carousel,
/// title, meta row, price row, quantity chips, description block.
class ProductDetailsSkeletonBody extends StatelessWidget {
  const ProductDetailsSkeletonBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(
      Theme.of(context).extension<AppShapes>()?.cardRadius ?? AppRadius.xlValue,
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: 300,
            borderRadius: cardRadius,
          ),
          const SizedBox(height: AppSpacing.base),
          const ShimmerBox(width: 200, height: 20),
          const SizedBox(height: AppSpacing.xs2),
          const ShimmerBox(width: 140, height: 14),
          const SizedBox(height: AppSpacing.xs2),
          const ShimmerBox(width: 100, height: 20),
          const SizedBox(height: AppSpacing.xl2),
          const ShimmerBox(width: 120, height: 18),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.base),
                const ShimmerBox(
                  width: 64,
                  height: 36,
                  borderRadius: AppRadius.full,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xl2),
          const ShimmerBox(width: double.infinity, height: 80),
        ],
      ),
    );
  }
}
