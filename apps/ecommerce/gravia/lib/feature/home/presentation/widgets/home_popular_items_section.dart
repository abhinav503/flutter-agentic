import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/section_header.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_product_card.dart';

import '../../domain/entities/product_entity.dart';

class HomePopularItemsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<String> onFavouriteToggle;
  final ValueChanged<ProductEntity> onProductTap;

  const HomePopularItemsSection({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onFavouriteToggle,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: SectionHeader(
            title: ValueConst.popularItemsTitle,
            titleStyle: TextStyleConst.textLgBold(
              tt,
            ).copyWith(color: cs.onSurface),
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
                GraviaProductCard(
                  product: products[i],
                  width: GraviaProductCard.railWidth,
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
