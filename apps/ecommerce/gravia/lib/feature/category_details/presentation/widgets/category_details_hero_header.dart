import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/glass_chip.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_price_filter.dart';
import 'package:gravia/enums/product_sort_option.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';

/// [GraviaHeroHeader] (back + centered category name + glass search) plus a
/// second row of "liquid glass" filter chips (Sort / Price) on the same
/// canvas — this screen's own addition to the pattern, for a
/// product-listing screen's filter bar.
class CategoryDetailsHeroHeader extends StatelessWidget {
  final String categoryName;
  final ProductSortOption sort;
  final ProductPriceFilter priceFilter;
  final VoidCallback onBack;
  final VoidCallback onSearchTap;
  final VoidCallback onSortTap;
  final VoidCallback onPriceTap;

  const CategoryDetailsHeroHeader({
    super.key,
    required this.categoryName,
    required this.sort,
    required this.priceFilter,
    required this.onBack,
    required this.onSearchTap,
    required this.onSortTap,
    required this.onPriceTap,
  });

  @override
  Widget build(BuildContext context) {
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    return GraviaHeroHeader(
      title: categoryName,
      onBack: onBack,
      trailing: GraviaGlassIconButton(
        asset: ImageConst.search,
        onTap: onSearchTap,
      ),
      // Tighter than the default header bottom — the chips row sits close
      // to the sheet per the kit's listing-screen spec.
      canvasBottomPadding: AppSpacing.base,
      bottom: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AppGlassChip(
              leading: AppSvgImage.asset(
                ImageConst.arrowSort,
                color: onOverlay,
                width: 16,
                height: 16,
              ),
              label: ValueConst.sortLabel,
              trailing: AppSvgImage.asset(
                ImageConst.directionRight,
                color: onOverlay,
                width: 18,
                height: 18,
              ),
              onTap: onSortTap,
              height: GraviaGlassIconButton.containerSize,
            ),
            const SizedBox(width: AppSpacing.xs2),
            AppGlassChip(
              label: priceFilter == ProductPriceFilter.all
                  ? ValueConst.priceLabel
                  : priceFilter.label,
              trailing: AppSvgImage.asset(
                ImageConst.directionRight,
                color: onOverlay,
                width: 18,
                height: 18,
              ),
              onTap: onPriceTap,
              height: GraviaGlassIconButton.containerSize,
            ),
          ],
        ),
      ),
    );
  }
}
