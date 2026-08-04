import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/icon_info_row.dart';

import 'package:cordelia/feature/storefront/search/domain/entities/recent_search_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

/// The Search screen's idle state (kit frame `119:795`): the shopper's recent
/// taps as a plain list, each removable.
///
/// With no history yet it falls through to the pack's empty state rather than
/// an empty header — the kit's "Search Product - Empty" frame.
class GrofastRecentSearchSection extends StatelessWidget {
  final List<RecentSearchEntity> items;
  final ValueChanged<RecentSearchEntity> onItemTap;
  final ValueChanged<RecentSearchEntity> onItemRemove;

  const GrofastRecentSearchSection({
    super.key,
    required this.items,
    required this.onItemTap,
    required this.onItemRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const GrofastEmptyState(
        icon: Icons.search_rounded,
        title: GrofastValueConst.searchIdleTitle,
        subtitle: GrofastValueConst.searchIdleSubtitle,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GrofastSectionHeader(title: GrofastValueConst.recentSearchTitle),
        const SizedBox(height: AppSpacing.lg),
        for (final item in items) _recentRow(context, item),
      ],
    );
  }

  /// The pack's dressing over core's row silhouette — leading search glyph,
  /// pack body type, an X that removes without opening the term.
  Widget _recentRow(BuildContext context, RecentSearchEntity item) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return IconInfoRow(
      leading: AppSvgImage.asset(
        GrofastImageConst.search,
        width: AppSpacing.xl,
        height: AppSpacing.xl,
        color: cs.onSurfaceVariant,
      ),
      title: item.name,
      titleMaxLines: 1,
      titleStyle: GrofastTextStyleConst.bodyMedium(
        tt,
      ).copyWith(color: cs.onSurface),
      gap: AppSpacing.lg,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
      onTap: () => onItemTap(item),
      trailing: GestureDetector(
        onTap: () => onItemRemove(item),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Icon(
            Icons.close_rounded,
            size: AppSpacing.xl,
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
