import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';

/// Mirrors the loaded Profile layout — the identity row, then two labelled
/// groups of bordered menu rows at their real 52px height and radius 12, so
/// nothing reflows when the profile lands.
class DailyMartProfileSkeletonBody extends StatelessWidget {
  const DailyMartProfileSkeletonBody({super.key});

  /// Matches the loaded screen's General / Preferences split.
  static const _rowsPerSection = [4, 4];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        children: [
          ShimmerBox.circle(size: DailyMartDimenConst.profileAvatarSize),
          SizedBox(width: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 140, height: 20),
              SizedBox(height: AppSpacing.xs),
              ShimmerBox(width: 180, height: 14),
            ],
          ),
        ],
      ),
      for (final rows in _rowsPerSection) ...[
        const SizedBox(height: AppSpacing.xl5),
        const ShimmerBox(width: 96, height: 20),
        for (var i = 0; i < rows; i++) ...[
          const SizedBox(height: AppSpacing.lg),
          const ShimmerBox(
            width: double.infinity,
            height: DailyMartDimenConst.menuRowHeight,
            borderRadius: AppRadius.lg,
          ),
        ],
      ],
    ],
  );
}
