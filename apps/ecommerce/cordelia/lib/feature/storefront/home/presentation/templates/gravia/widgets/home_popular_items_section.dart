import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/blocks/section_rail.dart';

class HomePopularItemsSection extends StatelessWidget {
  final List<ProductEntity> products;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<ProductEntity> onFavouriteToggle;
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
    final favourites = context.watch<FavouritesCubit>().state.items;

    return SectionRail(
      header: SectionHeader(
        title: GraviaValueConst.popularItemsTitle,
        titleStyle: GraviaTextStyleConst.textLgBold(
          tt,
        ).copyWith(color: cs.onSurface),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      itemCount: products.length,
      itemBuilder: (context, i) => GraviaProductCard(
        product: products[i],
        width: GraviaProductCard.railWidth,
        onAddToCart: () => onAddToCart(products[i], 1),
        onQuickAdd: () => onQuickAdd(products[i]),
        onTap: () => onProductTap(products[i]),
        isFavourite: favourites.any((p) => p.id == products[i].id),
        onFavouriteToggle: () => onFavouriteToggle(products[i]),
      ),
    );
  }
}
