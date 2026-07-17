import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';

import '../../../home/domain/entities/category_entity.dart';
import '../../domain/entities/category_group_entity.dart';

const _kColumns = 4;

/// One heading + 4-column grid on the Categories screen — as opposed to
/// [HomeCategorySection]'s single horizontal rail, this is the full
/// "categories under a category" browse view, so every tile in the group is
/// laid out at once rather than scrolled. → [ChunkedGrid].
class CategoryGroupSection extends StatelessWidget {
  final CategoryGroupEntity group;
  final ValueChanged<CategoryEntity> onCategoryTap;

  const CategoryGroupSection({
    super.key,
    required this.group,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileBackgroundColor = isDark ? ColorConst.gray950 : ColorConst.gray50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.base),
          ChunkedGrid(
            itemCount: group.categories.length,
            columns: _kColumns,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.lg,
            itemBuilder: (context, index) {
              final category = group.categories[index];
              return CategoryTile(
                imagePadding: const EdgeInsets.all(AppSpacing.xs),
                image: AppNetworkImage(
                  url: category.imageUrl,
                  fit: BoxFit.contain,
                ),
                label: category.name,
                labelStyle: TextStyleConst.textSmRegular(tt),
                backgroundColor: tileBackgroundColor,
                onTap: () => onCategoryTap(category),
              );
            },
          ),
        ],
      ),
    );
  }
}
