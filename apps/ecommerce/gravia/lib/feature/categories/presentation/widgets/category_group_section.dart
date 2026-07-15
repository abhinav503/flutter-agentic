import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/blocks/ecommerce/category_tile.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';

import '../../../home/domain/entities/category_entity.dart';
import '../../domain/entities/category_group_entity.dart';

const _kColumns = 4;

/// One heading + 4-column grid on the Categories screen — as opposed to
/// [HomeCategorySection]'s single horizontal rail, this is the full
/// "categories under a category" browse view, so every tile in the group is
/// laid out at once rather than scrolled.
///
/// Rows are chunked and laid out manually with `Row`/`Expanded` rather than
/// `GridView` — a `shrinkWrap` `GridView` nested in this screen's scrollable
/// body reserves more vertical space than its content needs (the same issue
/// hit and fixed the same way on `ProductDetailSimilarProducts`).
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

    final rows = <List<CategoryEntity>>[
      for (var i = 0; i < group.categories.length; i += _kColumns)
        group.categories.sublist(
          i,
          i + _kColumns > group.categories.length
              ? group.categories.length
              : i + _kColumns,
        ),
    ];

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
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                for (var c = 0; c < _kColumns; c++) ...[
                  if (c > 0) const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: c < rows[r].length
                        ? CategoryTile(
                            imagePadding: const EdgeInsets.all(AppSpacing.xs),
                            image: AppNetworkImage(
                              url: rows[r][c].imageUrl,
                              fit: BoxFit.contain,
                            ),
                            label: rows[r][c].name,
                            labelStyle: TextStyleConst.textSmRegular(tt),
                            backgroundColor: tileBackgroundColor,
                            onTap: () => onCategoryTap(rows[r][c]),
                          )
                        // Last row may be short of a full 4 — an empty
                        // Expanded keeps the real tiles left-aligned instead
                        // of stretching wider to fill the row.
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
