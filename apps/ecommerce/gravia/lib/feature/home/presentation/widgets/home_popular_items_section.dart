import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';
import 'package:core/core/ui/blocks/section_header.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

import '../../domain/entities/product_entity.dart';

class HomePopularItemsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onAddToCart;
  final ValueChanged<String> onFavouriteToggle;
  final VoidCallback onComingSoon;

  const HomePopularItemsSection({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onFavouriteToggle,
    required this.onComingSoon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Light mode uses the pre-baked pastel swatch (Primary/50); dark mode's
    // Figma spec calls this "Primary 20%" — the actual brand colour at 20%
    // opacity over the dark surface, not a separate baked swatch.
    final badgeBg = isDark ? cs.primary.withValues(alpha: 0.2) : ColorConst.primary50;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(
            title: ValueConst.popularItemsTitle,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < products.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.base),
                SizedBox(
                  width: 184,
                  child: ProductCard(
                    image: AppNetworkImage(
                      url: products[i].imageUrl,
                      fit: BoxFit.cover,
                    ),
                    title: products[i].name,
                    titleStyle: TextStyleConst.textMdBold(tt),
                    badgeLabel: products[i].weight,
                    badgeLabelStyle: TextStyleConst.badgeLabel(
                      tt,
                    ).copyWith(color: cs.primary),
                    badgeBackgroundColor: badgeBg,
                    meta: [
                      ProductCardMeta(
                        icon: AppSvgImage.asset(
                          ImageConst.flash,
                          width: 14,
                          height: 14,
                          color: ColorConst.gray500,
                        ),
                        label: products[i].prepTime,
                      ),
                      ProductCardMeta(
                        icon: AppSvgImage.asset(
                          ImageConst.badgePercent,
                          width: 14,
                          height: 14,
                          color: ColorConst.gray500,
                        ),
                        label:
                            '${products[i].discountPercentage.toStringAsFixed(0)}%',
                      ),
                    ],
                    metaLabelStyle: TextStyleConst.textXsRegular(
                      tt,
                    ).copyWith(color: cs.onSurface),
                    price: '\$${products[i].price.toStringAsFixed(2)}',
                    originalPrice:
                        '\$${products[i].originalPrice.toStringAsFixed(2)}',
                    actionLabel: ValueConst.addToCart,
                    actionLabelStyle: TextStyleConst.textSmMedium(
                      tt,
                    ).copyWith(color: onOverlay),
                    onAction: () => onAddToCart(products[i]),
                    
                    trailingAction: AppIconButton(
                      variant: AppIconButtonVariant.glass,
                      containerSize: AppSpacing.xl6,
                      iconSize: AppSpacing.lg,
                      glassHighlightThickness: AppSpacing.xs3,
                      glassBlurSigma: AppSpacing.xs4,
                      iconBuilder: (color, size) => AppSvgImage.asset(
                        ImageConst.bagAdd,
                        color: color,
                        width: size,
                        height: size,
                      ),
                      onTap: () => onAddToCart(products[i]),
                    ),
                    onTap: onComingSoon,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
