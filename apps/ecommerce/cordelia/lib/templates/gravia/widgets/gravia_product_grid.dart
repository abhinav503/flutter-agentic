import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

import '../constants/gravia_value_const.dart';
import 'gravia_product_card.dart';

/// The pack's 2-column product grid — one recipe (spacing, top alignment,
/// the '% OFF' discount label) for every gridded surface (Favourites,
/// Category Details), so the grid's geometry can't drift per screen the way
/// its skeleton twin (`GraviaProductGridSkeleton`) already guards against.
class GraviaProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<ProductEntity> onProductTap;

  /// Omit both to render cards without a favourite affordance
  /// (Category Details).
  final bool Function(ProductEntity product)? isFavourite;
  final ValueChanged<ProductEntity>? onFavouriteToggle;

  const GraviaProductGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onProductTap,
    this.isFavourite,
    this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) => ChunkedGrid(
    itemCount: products.length,
    columns: 2,
    spacing: AppSpacing.lg,
    runSpacing: AppSpacing.lg,
    // Cards in a row differ in height once one name wraps — top-align so a
    // short card doesn't float centred against a taller sibling.
    crossAxisAlignment: CrossAxisAlignment.start,
    itemBuilder: (context, index) {
      final product = products[index];
      return GraviaProductCard(
        product: product,
        // '% OFF' per the gridded screens' denser spec (rails use plain '%').
        discountLabel: GraviaValueConst.discountPercentOffLabel(
          product.discountPercentage,
        ),
        onAddToCart: () => onAddToCart(product, 1),
        onQuickAdd: () => onQuickAdd(product),
        onTap: () => onProductTap(product),
        isFavourite: isFavourite?.call(product) ?? false,
        onFavouriteToggle: onFavouriteToggle == null
            ? null
            : () => onFavouriteToggle!(product),
      );
    },
  );
}
