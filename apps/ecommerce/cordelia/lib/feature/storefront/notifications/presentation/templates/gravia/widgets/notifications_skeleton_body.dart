import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

/// Mirrors the loaded Notifications body — two dated sections, each a
/// section-title line over `NotificationRow`-silhouette rows (44px icon disc
/// + bold title + message line) at the loaded body's paddings, so nothing
/// jumps when the feed lands.
class NotificationsSkeletonBody extends StatelessWidget {
  const NotificationsSkeletonBody({super.key});

  /// Matches the loaded screen's typical section split.
  static const _rowsPerSection = [3, 3];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.xl2,
      AppSpacing.lg,
      AppSpacing.xl4,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var s = 0; s < _rowsPerSection.length; s++) ...[
          if (s > 0) const SizedBox(height: AppSpacing.xl4),
          const ShimmerSectionHeader(titleWidth: 120, actionWidth: 0),
          const SizedBox(height: AppSpacing.base),
          ShimmerListRow(
            itemCount: _rowsPerSection[s],
            // Loaded rows are separated by base + hairline divider + base.
            rowGap: AppSpacing.xl4,
            // NotificationRow's icon circle size and text silhouette.
            leadingSize: 44,
            gap: AppSpacing.base,
            crossAxisAlignment: CrossAxisAlignment.start,
            titleWidth: 160,
            titleHeight: 16,
            subtitleHeight: 12,
            lineGap: AppSpacing.xs4,
          ),
        ],
      ],
    ),
  );
}
