import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/glass_chip.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_price_filter.dart';
import 'package:gravia/enums/product_sort_option.dart';

/// The coloured header canvas for Category Details: back + centered title +
/// search (the pack's signature "coloured header canvas" composition, same
/// as [ProductDetailHeroHeader]) plus a second row of "liquid glass" filter
/// chips (Sort / Price) sitting on the same canvas — this screen's own
/// addition to the pattern, for a product-listing screen's filter bar.
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

  static const _iconContainerSize = 45.0;
  static const _iconSize = 20.0;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topInset + AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AppIconButton(
                iconBuilder: (color, size) => AppSvgImage.asset(
                  ImageConst.arrowLeft,
                  color: color,
                  width: size,
                  height: size,
                ),
                containerSize: _iconContainerSize,
                iconSize: _iconSize,
                variant: AppIconButtonVariant.glass,
                onTap: onBack,
              ),
              Expanded(
                child: Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyleConst.textLgBold(tt).copyWith(color: onOverlay),
                ),
              ),
              AppIconButton(
                iconBuilder: (color, size) => AppSvgImage.asset(
                  ImageConst.search,
                  color: color,
                  width: size,
                  height: size,
                ),
                containerSize: _iconContainerSize,
                iconSize: _iconSize,
                variant: AppIconButtonVariant.glass,
                onTap: onSearchTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          SingleChildScrollView(
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
                  height: _iconContainerSize,
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
                  height: _iconContainerSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
