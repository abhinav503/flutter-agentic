import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_card.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';

/// "Popular Products" — a 2-column card grid, the pack's main product
/// surface (unlike gravia, which rails them).
///
/// [ChunkedGrid], not a `shrinkWrap` `GridView`: this sits inside the page's
/// single scroll view, which isn't sliver-composed, so a nested grid would
/// lay every cell out up front anyway and force a guessed row extent that
/// clips the rating row.
class DailyMartHomePopularProductsGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onAddToCart;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<ProductEntity> onFavouriteToggle;
  final VoidCallback onSeeAll;

  const DailyMartHomePopularProductsGrid({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onProductTap,
    required this.onFavouriteToggle,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesCubit>().state.items;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DailyMartSectionHeader(
            title: DailyMartValueConst.popularProductsTitle,
            onSeeAll: onSeeAll,
          ),
          const SizedBox(height: AppSpacing.lg),
          ChunkedGrid(
            itemCount: products.length,
            columns: 2,
            spacing: AppSpacing.base,
            runSpacing: AppSpacing.lg,
            // Cards in a row differ in height once one name wraps — top-align
            // so a short card doesn't float centred against a taller sibling.
            crossAxisAlignment: CrossAxisAlignment.start,
            itemBuilder: (context, index) {
              final product = products[index];
              return DailyMartProductCard(
                product: product,
                onAdd: () => onAddToCart(product),
                onTap: () => onProductTap(product),
                isFavourite: favourites.any((p) => p.id == product.id),
                onFavouriteToggle: () => onFavouriteToggle(product),
              );
            },
          ),
        ],
      ),
    );
  }
}
