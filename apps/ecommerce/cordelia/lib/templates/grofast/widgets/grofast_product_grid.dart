import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';

import 'grofast_product_card.dart';

/// The pack's staggered 2-column product grid — the loaded-state twin of
/// [GrofastProductGridSkeleton]. Headers and gutters stay with the caller.
///
/// **How the stagger works.** The kit does not offset the second column by a
/// margin; it gives the *first* card a shorter height
/// ([GrofastDimenConst.productCardShortHeight]) and every other card the tall
/// one. Because the columns are laid out independently, that single 30px
/// difference pushes the right column down for the rest of the scroll and
/// never resynchronises — which is exactly the kit's rhythm, and why this is
/// two `Column`s rather than a `GridView`/`ChunkedGrid` (both of which lock
/// a row's cells to a shared baseline).
class GrofastProductGrid extends StatelessWidget {
  final List<ProductEntity> products;
  final ValueChanged<ProductEntity> onAdd;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<ProductEntity> onFavouriteToggle;

  /// Set false where the grid is a secondary block on a busy screen and the
  /// kit draws its cards at a single height (Product Details' related rail).
  final bool stagger;

  const GrofastProductGrid({
    super.key,
    required this.products,
    required this.onAdd,
    required this.onProductTap,
    required this.onFavouriteToggle,
    this.stagger = true,
  });

  /// The one card that breaks rank, by index.
  double _heightFor(int index) => stagger && index == 0
      ? GrofastDimenConst.productCardShortHeight
      : GrofastDimenConst.productCardHeight;

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouritesCubit>().state.items;

    return _StaggeredColumns(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GrofastProductCard(
          product: product,
          height: _heightFor(index),
          onAdd: () => onAdd(product),
          onTap: () => onProductTap(product),
          isFavourite: favourites.any((p) => p.id == product.id),
          onFavouriteToggle: () => onFavouriteToggle(product),
        );
      },
    );
  }
}

/// The grid's loading state: the same silhouette at the same two heights, so
/// nothing reflows when real cards land.
class GrofastProductGridSkeleton extends StatelessWidget {
  final int itemCount;

  const GrofastProductGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final radius = context.appShapes.cardRadius;

    return _StaggeredColumns(
      itemCount: itemCount,
      itemBuilder: (context, index) => ShimmerBox(
        height: index == 0
            ? GrofastDimenConst.productCardShortHeight
            : GrofastDimenConst.productCardHeight,
        width: double.infinity,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// A shimmer block at the pack's **card** radius, read from the theme rather
/// than restated — every skeleton that stands in for a card (a category tile,
/// a menu row, a promo banner) uses this instead of a literal, so the corner
/// can never drift from `AppShapes.cardRadius`.
class GrofastCardSkeleton extends StatelessWidget {
  final double? width;
  final double height;

  const GrofastCardSkeleton({super.key, this.width, required this.height});

  @override
  Widget build(BuildContext context) => ShimmerBox(
    width: width ?? double.infinity,
    height: height,
    borderRadius: BorderRadius.circular(context.appShapes.cardRadius),
  );
}

/// Lays [itemCount] children out into two independent columns — evens left,
/// odds right — so the two sides are free to fall out of step.
class _StaggeredColumns extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const _StaggeredColumns({required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    final left = <Widget>[];
    final right = <Widget>[];

    for (var i = 0; i < itemCount; i++) {
      final column = i.isEven ? left : right;
      if (column.isNotEmpty) {
        column.add(const SizedBox(height: GrofastDimenConst.gridRowGap));
      }
      column.add(itemBuilder(context, i));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: left)),
        const SizedBox(width: GrofastDimenConst.gridColumnGap),
        Expanded(child: Column(children: right)),
      ],
    );
  }
}
