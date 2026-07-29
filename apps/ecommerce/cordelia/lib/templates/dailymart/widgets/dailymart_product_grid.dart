import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';

import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

import 'dailymart_product_card.dart';

/// The pack's bare 2-column product grid — one recipe (spacing, top
/// alignment, the favourites watch) for every gridded surface (Home/Search
/// popular products, Product Details' related grid), the loaded-state twin
/// of `DailyMartProductGridSkeleton`. Headers and gutters stay with the
/// caller.
class DailyMartProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onAdd;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<ProductEntity> onFavouriteToggle;

  const DailyMartProductGrid({
    super.key,
    required this.products,
    required this.onAdd,
    required this.onProductTap,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesCubit>().state.items;

    return ChunkedGrid(
      itemCount: products.length,
      columns: 2,
      spacing: AppSpacing.base,
      runSpacing: AppSpacing.lg,
      // Cards in a row differ in height once one name wraps — top-align so
      // a short card doesn't float centred against a taller sibling.
      crossAxisAlignment: CrossAxisAlignment.start,
      itemBuilder: (context, index) {
        final product = products[index];
        return DailyMartProductCard(
          product: product,
          onAdd: () => onAdd(product),
          onTap: () => onProductTap(product),
          isFavourite: favourites.any((p) => p.id == product.id),
          onFavouriteToggle: () => onFavouriteToggle(product),
        );
      },
    );
  }
}
