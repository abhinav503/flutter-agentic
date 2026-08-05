import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';
import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/blocks/section_rail.dart';

import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import '../../../../domain/entities/category_entity.dart';

/// Port of gravia's `HomeCategorySection` for the `gravia` storefront
/// template — built entirely from `core` blocks. `onCategoryTap` opens
/// Category Details; `onSeeAllCategories` jumps the shell to the
/// Categories tab.
class HomeCategorySection extends StatelessWidget {
  /// A rail item is intrinsically sized, so without a bound a long
  /// admin-authored name ("Tea, Coffee & Health Drinks") widens its tile
  /// instead of wrapping — this fixes the tile width a little past the
  /// 64 circle so the label breaks into (up to) two centred lines.
  static const _tileWidth = 80.0;

  final List<CategoryEntity> categories;
  final VoidCallback? onSeeAllCategories;
  final ValueChanged<CategoryEntity>? onCategoryTap;

  const HomeCategorySection({
    super.key,
    required this.categories,
    this.onSeeAllCategories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SectionRail(
      header: SectionHeader(
        title: GraviaValueConst.categoriesTitle,
        actionLabel: onSeeAllCategories == null
            ? null
            : GraviaValueConst.seeAll,
        onAction: onSeeAllCategories,
        titleStyle: GraviaTextStyleConst.textLgBold(
          tt,
        ).copyWith(color: cs.onSurface),
        actionStyle: GraviaTextStyleConst.textSmRegular(
          tt,
        ).copyWith(color: cs.primary),
      ),
      itemSpacing: AppSpacing.lg,
      itemCount: categories.length,
      itemBuilder: (context, i) => SizedBox(
        width: _tileWidth,
        child: CategoryTile(
          // Tighter than the default AppSpacing.base padding so the
          // PNG fills more of the circle without growing the tile.
          imagePadding: const EdgeInsets.all(AppSpacing.xs),
          image: AppNetworkImage(
            url: categories[i].imageUrl,
            fit: BoxFit.contain,
          ),
          label: categories[i].name,
          // Same call as the Categories screen's grid: long names show as
          // two centred lines instead of truncating.
          labelMaxLines: 2,
          labelStyle: GraviaTextStyleConst.textSmRegular(tt),
          backgroundColor: cs.surfaceContainerLow,
          onTap: onCategoryTap == null
              ? null
              : () => onCategoryTap!(categories[i]),
        ),
      ),
    );
  }
}
