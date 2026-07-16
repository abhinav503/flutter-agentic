import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/section_header.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_product_card.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: ValueConst.similarProductsTitle,
          titleStyle: TextStyleConst.textLgBold(
            tt,
          ).copyWith(color: cs.onSurface),
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
                GraviaProductCard(
                  product: products[i],
                  width: GraviaProductCard.railWidth,
                  // Kit's Similar Products cards carry only the prep-time
                  // meta, not the discount chip.
                  showDiscount: false,
                  onAddToCart: () => onAddToCart(products[i], 1),
                  onQuickAdd: () => onQuickAdd(products[i]),
                  onTap: () => onProductTap(products[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
