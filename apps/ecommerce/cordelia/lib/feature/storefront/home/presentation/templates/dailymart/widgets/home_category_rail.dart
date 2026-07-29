import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/section_rail.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_category_tile.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';

/// "Shop by category" — header plus a horizontal rail of photo tiles.
class DailyMartHomeCategoryRail extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final VoidCallback onSeeAll;

  const DailyMartHomeCategoryRail({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return SectionRail(
      header: DailyMartSectionHeader(
        title: DailyMartValueConst.categoriesTitle,
        onSeeAll: onSeeAll,
      ),
      headerGap: AppSpacing.lg,
      itemSpacing: AppSpacing.xs,
      // Bottom padding gives each tile's shadow room instead of clipping it.
      railBottomPadding: AppSpacing.xs3,
      trailingGap: AppSpacing.lg,
      itemCount: categories.length,
      itemBuilder: (context, i) => DailyMartCategoryTile(
        label: categories[i].name,
        imageUrl: categories[i].imageUrl,
        onTap: () => onCategoryTap(categories[i]),
      ),
    );
  }
}
