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
import 'package:gravia/enums/product_unit_type.dart';

import '../../../home/domain/entities/product_entity.dart';

class ProductDetailSimilarProducts extends StatelessWidget {
  final List<ProductEntity> products;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<ProductEntity> onProductTap;

  const ProductDetailSimilarProducts({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;
    final badgeBg = cs.tintedPrimaryFill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: ValueConst.similarProductsTitle,
          titleStyle: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
        ),
        // Matches the gap used before Home's horizontal product scroller
        // (HomePopularItemsSection) — the grid's mainAxisExtent previously
        // made this look larger than intended.
        const SizedBox(height: AppSpacing.base),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < products.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.base),
                SizedBox(
                  width: 184,
                  child: ProductCard(
                    image: AppNetworkImage(url: products[i].imageUrl, fit: BoxFit.cover),
                    title: products[i].name,
                    titleStyle: TextStyleConst.textMdBold(tt),
                    badgeLabel: products[i].unitType.format(products[i].unitValue),
                    badgeLabelStyle: TextStyleConst.badgeLabel(tt).copyWith(color: cs.primary),
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
                    ],
                    metaLabelStyle: TextStyleConst.textXsRegular(tt).copyWith(color: cs.onSurface),
                    price: '\$${products[i].price.toStringAsFixed(2)}',
                    originalPrice: '\$${products[i].originalPrice.toStringAsFixed(2)}',
                    actionLabel: ValueConst.addToCart,
                    actionLabelStyle: TextStyleConst.textSmMedium(tt).copyWith(color: onOverlay),
                    onAction: () => onAddToCart(products[i], 1),
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
                      onTap: () => onQuickAdd(products[i]),
                    ),
                    onTap: () => onProductTap(products[i]),
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
