import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_grid.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_grid_skeleton.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_switcher.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../cubit/favourites_cubit.dart';

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

  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    extra: context.read<ActiveStoreCubit>().state!.storeId,
  );

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  Widget _header() =>
      GraviaHeroHeader.page(title: GraviaValueConst.favouritePageTitle);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    final state = context.watch<FavouritesCubit>().state;

    return GraviaSwitcher(
      // isLoading only ever reads true before ShellPage.initState's
      // hydrate resolves — there's no warm cache to seed from (unlike
      // HomeBloc/AddressBloc), so a shopper who opens this tab first sees
      // the skeleton instead of a premature "no favourites yet".
      child: state.isLoading
          ? CollapsingHeaderSheet(
              key: const ValueKey('loading'),
              initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
              header: _header(),
              body: const GraviaProductGridSkeleton(),
            )
          : CollapsingHeaderSheet(
              key: const ValueKey('loaded'),
              initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
              header: _header(),
              body: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: state.items.isEmpty
                    ? EmptyState(
                        iconData: Icons.favorite_outline,
                        title: GraviaValueConst.favouriteEmptyTitle,
                        subtitle: GraviaValueConst.favouriteEmptySubtitle,
                      )
                    : GraviaProductGrid(
                        products: state.items,
                        onAddToCart: _addToCart,
                        onQuickAdd: _showAddToCartSheet,
                        onProductTap: _openProductDetails,
                        // Every card here is a favourite by definition —
                        // toggling always removes.
                        isFavourite: (_) => true,
                        onFavouriteToggle: (product) =>
                            context.read<FavouritesCubit>().toggle(product),
                      ),
              ),
            ),
    );
  }
}
