import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';

import '../recent_stores_prefs.dart';

/// Mirrors discovery's loaded body — the recents rail over the store list —
/// so nothing shifts when the stores land.
///
/// The rail half is drawn only when this device actually has recents. The
/// ids are a synchronous prefs read, the same source the bloc resolves
/// against, so the skeleton can't promise a rail that never arrives — which
/// is exactly what a first-time shopper would have seen.
///
/// Non-scrolling: it renders inside `CollapsingHeaderSheet`'s body, which is
/// already a sliver in a scroll view.
class StoreListSkeleton extends StatelessWidget {
  const StoreListSkeleton({super.key});

  static const int _cardCount = 5;

  @override
  Widget build(BuildContext context) {
    // StoreCard clips its logo to half the theme card radius.
    final logoRadius = BorderRadius.circular(context.appShapes.cardRadius / 2);
    final recentCount = readRecentStoreIds().length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recentCount > 0) ...[
          const ShimmerSectionHeader(titleWidth: 110, actionWidth: 0),
          const SizedBox(height: AppSpacing.base),
          Row(
            children: List.generate(
              recentCount,
              (_) => const Padding(
                padding: EdgeInsets.only(right: AppSpacing.base),
                child: ShimmerCircleTile(
                  size: CordeliaDimenConst.recentStoreLogo,
                  labelWidth: CordeliaDimenConst.recentStoreLogo,
                  labelGap: AppSpacing.xs2,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl4),
          const ShimmerSectionHeader(titleWidth: 90, actionWidth: 0),
          const SizedBox(height: AppSpacing.base),
        ],
        for (var i = 0; i < _cardCount; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.base),
          Padding(
            // StoreCard's own content inset.
            padding: const EdgeInsets.all(AppSpacing.base),
            child: ShimmerListRow(
              leadingSize: CordeliaDimenConst.storeCardLogo,
              leadingRadius: logoRadius,
              gap: AppSpacing.base,
              titleWidth: 160,
              titleHeight: 16,
              subtitleHeight: 14,
              lineGap: AppSpacing.xs3,
            ),
          ),
        ],
      ],
    );
  }
}
