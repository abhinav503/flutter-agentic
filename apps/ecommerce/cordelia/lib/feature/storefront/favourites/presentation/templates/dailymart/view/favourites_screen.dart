import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid_skeleton.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../cubit/favourites_cubit.dart';

/// `dailymart` template's Wishlist tab — the pack's header row over its
/// standard 2-column product grid.
///
/// The kit ships **no** wishlist frame (its sourced screens stop at Home,
/// Search, Filter, cart, checkout and the order pair), so this is composed
/// from recipes the pack already owns rather than invented chrome: the tab
/// root's back-less [DailyMartHeaderRow], `DailyMartProductGrid`, and the
/// Cart tab's empty-state-with-a-way-out. Every card's heart is filled
/// here by definition, and tapping it removes the product — the grid reads
/// that straight off `FavouritesCubit`, so a removal just drops the card.
///
/// No bloc of its own: it renders `FavouritesCubit` directly, the same
/// relationship `CartScreen` has with `CartCubit`.
class FavouritesScreen extends BaseScreen {
  /// Switches the shell to Home — the empty state's way out. A tab root has
  /// nowhere to pop, so this can't be `context.pop`.
  final VoidCallback onExplore;

  const FavouritesScreen({super.key, required this.onExplore});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends BaseScreenState<FavouritesScreen> {
  void _addToCart(ProductEntity product, int quantity) {
    context.read<CartCubit>().addToCart(product, quantity);
    showSnackBar(
      DailyMartValueConst.addedToCartMessage(product.name, quantity),
    );
  }

  void _showAddToCartSheet(ProductEntity product) =>
      showDailyMartAddToCartSheet(product: product, onAddToCart: _addToCart);

  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    // `!`: this tab only renders inside a mounted storefront, which seeds
    // the cubit before its first build.
    extra: context.read<ActiveStoreCubit>().state!.storeId,
  );

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final state = context.watch<FavouritesCubit>().state;

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      // Bottom edge belongs to the shell's nav bar, same as every other tab
      // root in this pack.
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.base,
                AppSpacing.lg,
                0,
              ),
              child: DailyMartHeaderRow(title: DailyMartValueConst.navWishlist),
            ),
            const SizedBox(height: AppSpacing.xl2),
            Expanded(
              child: DailyMartTopSwitcher(
                // isLoading only reads true before ShellPage's hydrate
                // resolves — there's no warm cache to seed from, so a shopper
                // opening this tab first gets the skeleton rather than a
                // premature "nothing saved yet".
                child: state.isLoading
                    ? const _Page(
                        key: ValueKey('loading'),
                        body: DailyMartProductGridSkeleton(),
                      )
                    : state.items.isEmpty
                    ? _Empty(
                        key: const ValueKey('empty'),
                        onExplore: widget.onExplore,
                      )
                    : _Page(
                        key: const ValueKey('loaded'),
                        body: DailyMartProductGrid(
                          products: state.items,
                          onAdd: _showAddToCartSheet,
                          onProductTap: _openProductDetails,
                          onFavouriteToggle: (product) =>
                              context.read<FavouritesCubit>().toggle(product),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onExplore;

  const _Empty({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) => EmptyState(
    iconData: Icons.favorite_outline,
    title: DailyMartValueConst.wishlistEmptyTitle,
    subtitle: DailyMartValueConst.wishlistEmptySubtitle,
    actions: [
      AppButton(
        label: DailyMartValueConst.wishlistExploreAction,
        variant: AppButtonVariant.secondary,
        onTap: onExplore,
      ),
    ],
  );
}

/// The scroll view the grid and its skeleton share, so the state swap can't
/// shift the cards sideways or change their gutters.
class _Page extends StatelessWidget {
  final Widget body;

  const _Page({super.key, required this.body});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      0,
      AppSpacing.lg,
      AppSpacing.xl10,
    ),
    child: body,
  );
}
