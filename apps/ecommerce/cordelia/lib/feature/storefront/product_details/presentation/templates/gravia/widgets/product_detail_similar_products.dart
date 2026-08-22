import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/ui/blocks/section_header.dart';
import 'package:core/core/ui/blocks/section_rail.dart';

import '../../../../../home/domain/entities/product_entity.dart';

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
    final favourites = context.watch<FavouritesCubit>().state.items;

    return SectionRail(
      header: SectionHeader(
        title: GraviaValueConst.similarProductsTitle,
        titleStyle: GraviaTextStyleConst.textLgBold(
          tt,
        ).copyWith(color: cs.onSurface),
      ),
      // Zero — this section already sits inside the page's padded body.
      gutter: 0,
      crossAxisAlignment: CrossAxisAlignment.start,
      itemCount: products.length,
      itemBuilder: (context, i) => GraviaProductCard(
        product: products[i],
        width: GraviaProductCard.railWidth,
        // Kit's Similar Products cards carry only the prep-time
        // meta, not the discount chip.
        showDiscount: false,
        onAddToCart: () => onAddToCart(products[i], 1),
        onQuickAdd: () => onQuickAdd(products[i]),
        onTap: () => onProductTap(products[i]),
        isFavourite: favourites.any((p) => p.id == products[i].id),
        onFavouriteToggle: () => context.toggleFavouriteOrSignIn(products[i]),
      ),
    );
  }
}
