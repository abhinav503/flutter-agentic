import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';
import 'package:core/core/ui/blocks/section_header.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: ValueConst.popularItemsTitle,
          actionLabel: ValueConst.seeAll,
          onAction: onComingSoon,
        ),
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
                  child: Stack(
                    children: [
                      ProductCard(
                        image: AppNetworkImage(
                          url: products[i].imageUrl,
                          fit: BoxFit.cover,
                        ),
                        title: products[i].name,
                        badgeLabel: products[i].weight,
                        meta: [
                          ProductCardMeta(
                              icon: Icons.bolt, label: products[i].prepTime),
                          ProductCardMeta(
                            icon: Icons.local_offer_outlined,
                            label:
                                '${products[i].discountPercentage.toStringAsFixed(0)}%',
                          ),
                        ],
                        price: '\$${products[i].price.toStringAsFixed(2)}',
                        originalPrice:
                            '\$${products[i].originalPrice.toStringAsFixed(2)}',
                        actionLabel: ValueConst.addToCart,
                        onAction: () => onAddToCart(products[i]),
                        onTap: onComingSoon,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onFavouriteToggle(products[i].id),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.xs2),
                            decoration: BoxDecoration(
                              color: cs.surface.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              products[i].isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: products[i].isFavourite
                                  ? cs.error
                                  : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
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
