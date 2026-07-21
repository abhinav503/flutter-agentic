import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_product_card.dart';
import 'package:gravia/widgets/gravia_product_grid_skeleton.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../cubit/favourites_cubit.dart';

/// The Favourite tab's content — same coloured-hero-header-over-
/// `CollapsingHeaderSheet` composition as the other tab roots (Categories,
/// Orders, Profile), so `ShellPage`'s app bar stays suppressed for it too
/// (see `ShellPage.buildAppBar`). No own bloc: it renders `FavouritesCubit`'s
/// state directly, same relationship `CartScreen` has with `CartCubit`.
class FavouritesScreen extends BaseScreen {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends BaseScreenState<FavouritesScreen> {
  void _addToCart(ProductEntity product, int quantity) =>
      context.read<CartCubit>().addToCart(product, quantity);

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  Widget _header() =>
      GraviaHeroHeader.page(title: ValueConst.favouritePageTitle);

  @override
  Widget body(BuildContext context) {
    final state = context.watch<FavouritesCubit>().state;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        // isLoading only ever reads true before ShellPage.initState's
        // hydrate resolves — there's no warm cache to seed from (unlike
        // HomeBloc/AddressBloc), so a shopper who opens this tab first sees
        // the skeleton instead of a premature "no favourites yet".
        child: state.isLoading
            ? CollapsingHeaderSheet(
                key: const ValueKey('loading'),
                initialHeaderHeight: 130,
                header: _header(),
                body: const GraviaProductGridSkeleton(),
              )
            : CollapsingHeaderSheet(
                key: const ValueKey('loaded'),
                initialHeaderHeight: 130,
                header: _header(),
                body: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: state.items.isEmpty
                      ? const EmptyState(
                          iconData: Icons.favorite_outline,
                          title: ValueConst.favouriteEmptyTitle,
                          subtitle: ValueConst.favouriteEmptySubtitle,
                        )
                      : ChunkedGrid(
                          itemCount: state.items.length,
                          columns: 2,
                          spacing: AppSpacing.lg,
                          runSpacing: AppSpacing.lg,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          itemBuilder: (context, index) =>
                              _productCard(state.items[index]),
                        ),
                ),
              ),
      ),
    );
  }

  Widget _productCard(ProductEntity product) => GraviaProductCard(
    product: product,
    discountLabel: ValueConst.discountPercentOffLabel(
      product.discountPercentage,
    ),
    onAddToCart: () => _addToCart(product, 1),
    onQuickAdd: () => _showAddToCartSheet(product),
    onTap: () => _openProductDetails(product),
    // Every card here is a favourite by definition — toggling always removes.
    isFavourite: true,
    onFavouriteToggle: () => context.read<FavouritesCubit>().toggle(product),
  );
}
