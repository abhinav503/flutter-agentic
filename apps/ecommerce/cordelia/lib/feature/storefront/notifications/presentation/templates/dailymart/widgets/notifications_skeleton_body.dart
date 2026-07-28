import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

/// Mirrors the loaded list's silhouette — two dated sections of circle +
/// two-line block — so nothing shifts when the real notifications land. The
/// header row is rendered by the screen in both states and is not shimmered
/// (spec sheet §14).
class DailyMartNotificationsSkeletonBody extends StatelessWidget {
  const DailyMartNotificationsSkeletonBody({super.key});

  /// Row counts per shimmered section — matched to the mock data's shape so
  /// the swap is a fade, not a reflow.
  static const _sectionRowCounts = [2, 4];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var s = 0; s < _sectionRowCounts.length; s++) ...[
          if (s > 0) const SizedBox(height: AppSpacing.lg),
          const ShimmerBox(width: 96, height: AppSpacing.xl2),
          const SizedBox(height: AppSpacing.lg),
          ShimmerListRow(itemCount: _sectionRowCounts[s]),
        ],
      ],
    );
  }
}
