import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/section_rail.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';

import '../recent_stores_prefs.dart';

/// Mirrors discovery's loaded body — the recents rail over the store list —
/// so nothing shifts when the stores land.
///
/// The rail half is drawn only when this device actually has recents. The ids
/// are a synchronous prefs read, the same source the bloc resolves against, so
/// the skeleton can't promise a rail that never arrives — which is exactly
/// what a first-time shopper would have seen.
///
/// Built on the same [SectionRail] the loaded rail uses rather than a
/// hand-rolled `Row`. That's not just tidiness: the row has to *scroll*. Six
/// remembered stores at the rail's 84px pitch is 504px, wider than any phone's
/// content width, and a bare `Row` overflowed instead of scrolling — visible
/// as a RenderFlex overflow the moment a shopper had a full rail. Sharing the
/// block also keeps the gutter and item pitch from drifting from the real one.
///
/// Non-scrolling vertically: it renders inside `CollapsingHeaderSheet`'s body,
/// which is already a sliver in a scroll view. It also owns its own
/// horizontal insets, section by section, exactly as the loaded body does.
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
          SectionRail(
            header: const ShimmerSectionHeader(
              // Roughly the width of the real header's title.
              titleWidth: 110,
              actionWidth: 0,
            ),
            itemCount: recentCount,
            // Sized to RecentStoreTile's own width so the pitch matches the
            // loaded rail item-for-item.
            itemBuilder: (context, index) => const SizedBox(
              width: CordeliaDimenConst.recentStoreTile,
              child: ShimmerCircleTile(
                size: CordeliaDimenConst.recentStoreLogo,
                labelWidth: CordeliaDimenConst.recentStoreLogo,
                labelGap: AppSpacing.xs2,
              ),
            ),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          const SizedBox(height: AppSpacing.xl4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: ShimmerSectionHeader(titleWidth: 90, actionWidth: 0),
          ),
          const SizedBox(height: AppSpacing.base),
        ],
        for (var i = 0; i < _cardCount; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.base),
          Padding(
            // The loaded card's outer gutter plus StoreCard's own inset.
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg + AppSpacing.base,
            ),
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
