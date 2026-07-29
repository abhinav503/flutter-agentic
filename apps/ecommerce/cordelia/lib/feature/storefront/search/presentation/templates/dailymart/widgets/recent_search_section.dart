import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyMartSectionHeader(title: DailyMartValueConst.recentSearchTitle),
        const SizedBox(height: AppSpacing.xs),
        for (final item in items)
          _RecentSearchRow(
            item: item,
            onTap: () => onItemTap(item),
            onRemove: () => onRemove(item),
          ),
      ],
    );
  }
}

class _RecentSearchRow extends StatelessWidget {
  final RecentSearchEntity item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentSearchRow({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            AppSvgImage.asset(
              DailyMartImageConst.searchSmall,
              color: cs.onSurface,
              width: AppSpacing.xl2,
              height: AppSpacing.xl2,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                item.name,
                style: DailyMartTextStyleConst.bodySmRegular(
                  tt,
                ).copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs3),
                child: Icon(
                  Icons.close_rounded,
                  size: AppSpacing.lg,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
