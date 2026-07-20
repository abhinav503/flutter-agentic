import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'gravia_product_card.dart';

/// Skeleton silhouette of a section-titled product-card rail — a title bar
/// shimmer, then a horizontal rail of [GraviaProductCard.railWidth]-wide
/// card shimmers. Shared by the Home and Search skeleton bodies so the rail
/// recipe can't drift between them.
class GraviaProductRailSkeleton extends StatelessWidget {
  /// Matches [GraviaProductCard]'s rendered rail height so the loading
  /// state doesn't jump in layout once real cards replace it.
  static const double _cardHeight = 230;

  final double titleWidth;

  const GraviaProductRailSkeleton({super.key, this.titleWidth = 140});

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(
      Theme.of(context).extension<AppShapes>()?.cardRadius ?? AppRadius.xlValue,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ShimmerBox(width: titleWidth, height: 20),
        ),
        const SizedBox(height: AppSpacing.base),
        SizedBox(
          height: _cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            itemCount: 4,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.base),
            itemBuilder: (context, index) => ShimmerBox(
              width: GraviaProductCard.railWidth,
              height: _cardHeight,
              borderRadius: cardRadius,
            ),
          ),
        ),
      ],
    );
  }
}
