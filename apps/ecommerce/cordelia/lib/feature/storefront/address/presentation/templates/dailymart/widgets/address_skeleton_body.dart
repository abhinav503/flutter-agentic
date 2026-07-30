import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

/// Mirrors the loaded Select Address list — three cards in the real
/// [AddressCard] silhouette (tinted radius-16 block, pin, tag line, two
/// address lines, trailing disc), so nothing reflows when the addresses land.
class DailyMartAddressSkeletonBody extends StatelessWidget {
  const DailyMartAddressSkeletonBody({super.key});

  static const _cardCount = 3;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (var i = 0; i < _cardCount; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: AppRadius.xl,
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: AppSpacing.xl4, height: AppSpacing.xl4),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 88, height: 18),
                      SizedBox(height: AppSpacing.xs),
                      ShimmerBox(width: double.infinity, height: 14),
                      SizedBox(height: AppSpacing.xs3),
                      ShimmerBox(width: 120, height: 14),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                ShimmerBox.circle(size: 20),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
