import 'package:cordelia/enums/product_price_filter.dart';
import 'package:cordelia/enums/product_sort_option.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/glass_chip.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

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
    final onOverlay = context.appColors.onOverlay;

    return GraviaHeroHeader(
      title: categoryName,
      onBack: onBack,
      trailing: GraviaGlassIconButton(
        asset: GraviaImageConst.search,
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
                GraviaImageConst.arrowSort,
                color: onOverlay,
                width: AppSpacing.lg,
                height: AppSpacing.lg,
              ),
              label: GraviaValueConst.sortLabel,
              trailing: AppSvgImage.asset(
                GraviaImageConst.directionRight,
                color: onOverlay,
                width: AppSpacing.xl,
                height: AppSpacing.xl,
              ),
              onTap: onSortTap,
              height: GraviaGlassIconButton.containerSize,
            ),
            const SizedBox(width: AppSpacing.xs2),
            AppGlassChip(
              label: priceFilter == ProductPriceFilter.all
                  ? GraviaValueConst.priceLabel
                  : priceFilter.label,
              trailing: AppSvgImage.asset(
                GraviaImageConst.directionRight,
                color: onOverlay,
                width: AppSpacing.xl,
                height: AppSpacing.xl,
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
