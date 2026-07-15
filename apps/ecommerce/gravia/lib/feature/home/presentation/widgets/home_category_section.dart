import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';
import 'package:core/core/ui/blocks/section_header.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/category_entity.dart';

class HomeCategorySection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final VoidCallback onComingSoon;
  final ValueChanged<CategoryEntity> onCategoryTap;

  const HomeCategorySection({
    super.key,
    required this.categories,
    required this.onComingSoon,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileBackgroundColor = isDark ? ColorConst.gray950 : ColorConst.gray50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(
            title: ValueConst.allCategoriesTitle,
            actionLabel: ValueConst.seeAll,
            onAction: onComingSoon,
            titleStyle: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
            actionStyle: TextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.primary),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // Left inset only, matching the header above — no right inset, so
          // the row can scroll all the way to the true screen edge instead
          // of stopping AppSpacing.lg short of it.
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Row(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.lg),
                CategoryTile(
                  // Tighter than the default AppSpacing.base padding so the
                  // PNG fills more of the circle without growing the tile.
                  imagePadding: const EdgeInsets.all(AppSpacing.xs),
                  image: AppNetworkImage(
                    url: categories[i].imageUrl,
                    fit: BoxFit.contain,
                  ),
                  label: categories[i].name,
                  labelStyle: TextStyleConst.textSmRegular(tt),
                  backgroundColor: tileBackgroundColor,
                  onTap: () => onCategoryTap(categories[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
