import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: DailyMartSectionHeader(
            title: DailyMartValueConst.categoriesTitle,
            onSeeAll: onSeeAll,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // Left inset only — the rail scrolls to the true screen edge
          // rather than stopping a gutter short of it. Bottom padding gives
          // each tile's shadow room instead of clipping it.
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            bottom: AppSpacing.xs3,
          ),
          child: Row(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xs),
                DailyMartCategoryTile(
                  label: categories[i].name,
                  imageUrl: categories[i].imageUrl,
                  onTap: () => onCategoryTap(categories[i]),
                ),
              ],
              const SizedBox(width: AppSpacing.lg),
            ],
          ),
        ),
      ],
    );
  }
}
