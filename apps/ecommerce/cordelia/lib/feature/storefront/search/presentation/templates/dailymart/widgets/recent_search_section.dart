import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';

import '../../../../domain/entities/recent_search_entity.dart';

/// "Recent Search" — the kit's plain rows (small search glyph + the term),
/// plus a trailing remove affordance the kit doesn't draw but the shared
/// bloc supports; leaving recents undeletable here while gravia deletes
/// them would fork behaviour per template.
///
/// No "See all" — the kit shows the link with nowhere to land, and a dead
/// action is worse than an absent one.
class DailyMartRecentSearchSection extends StatelessWidget {
  final List<RecentSearchEntity> items;
  final ValueChanged<RecentSearchEntity> onItemTap;
  final ValueChanged<RecentSearchEntity> onRemove;

  const DailyMartRecentSearchSection({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyMartSectionHeader(title: DailyMartValueConst.recentSearchTitle),
        const SizedBox(height: AppSpacing.xs),
        for (final item in items)
          IconInfoRow(
            leading: AppSvgImage.asset(
              DailyMartImageConst.searchSmall,
              color: cs.onSurface,
              width: AppSpacing.xl2,
              height: AppSpacing.xl2,
            ),
            title: item.name,
            titleStyle: DailyMartTextStyleConst.bodySmRegular(
              tt,
            ).copyWith(color: cs.onSurface),
            titleMaxLines: 1,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            gap: AppSpacing.xs,
            trailingGap: 0,
            trailing: DailyMartIconDisc(
              icon: Icons.close_rounded,
              onTap: () => onRemove(item),
              // Bare glyph with a 4px tap inset — no disc fill, unlike the
              // header discs.
              size: AppSpacing.xl4,
              iconSize: AppSpacing.lg,
              backgroundColor: Colors.transparent,
              foregroundColor: cs.onSurfaceVariant,
            ),
            onTap: () => onItemTap(item),
          ),
      ],
    );
  }
}
