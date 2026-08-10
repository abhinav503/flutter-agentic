import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/active_store_capture.dart';
import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../cubit/favourites_cubit.dart';

/// `grofast` template's Wishlist (kit frames `194:4031` / `129:923`) — the
/// pack's header row and title over its staggered product grid.
///
/// Reached from the Profile tab's Wishlist tile, which is exactly how the kit
/// gets here; this template's four nav slots are Home / Categories / Bag /
/// Account.
///
/// No bloc of its own: it renders `FavouritesCubit` directly, the same
/// relationship `CartScreen` has with `CartCubit`. Every card's heart is
/// filled here by definition, so tapping one drops the card.
class FavouritesScreen extends BaseScreen {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends BaseScreenState<FavouritesScreen>
    with ActiveStoreCapture {
  void _addToBag(ProductEntity product) {
    context.read<CartCubit>().addToCart(product, 1);
    showSnackBar(GrofastValueConst.addedToBagMessage(product.name, 1));
  }

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id), extra: storeId);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final favourites = context.watch<FavouritesCubit>().state.items;

    return SafeArea(
      bottom: false,
      child: GrofastScreenBody(
        title: GrofastValueConst.wishlistTitle,
        onBack: () => context.pop(),
        gap: AppSpacing.xl4,
        body: GrofastSwitcher(
          child: favourites.isEmpty
              ? GrofastEmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: GrofastValueConst.wishlistEmptyTitle,
                  subtitle: GrofastValueConst.wishlistEmptySubtitle,
                  actionLabel: GrofastValueConst.wishlistExploreAction,
                  onAction: () => context.pop(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GrofastValueConst.resultsCountLabel(favourites.length),
                      style: GrofastTextStyleConst.sectionBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    GrofastProductGrid(
                      products: favourites,
                      onAdd: _addToBag,
                      onProductTap: _openProductDetails,
                      onFavouriteToggle: (product) =>
                          context.read<FavouritesCubit>().toggle(product),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
