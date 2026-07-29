import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/feature/storefront/address/presentation/selected_address_label.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/home/presentation/templates/gravia/widgets/home_hero_header.dart';
import 'package:cordelia/feature/storefront/presentation/view/storefront_page.dart';
import 'package:cordelia/feature/storefront/shell/presentation/templates/gravia/view/shell_page.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/home_entity.dart';
import '../../../bloc/home_bloc.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_popular_items_section.dart';
import '../widgets/home_skeleton_body.dart';

/// `gravia` template's Home screen — category rail + popular-products rail,
/// storeId-scoped off [ActiveStoreCubit] and themed by the store's template
/// config. Every read here is scoped to the active store, so the same widget
/// tree serves any store that selects the `gravia` template.
class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen>
    with SelectedAddressLabelState {
  void _addToCart(ProductEntity product, int quantity) {
    context.read<CartCubit>().addToCart(product, quantity);
  }

  String get _storeId => context.read<ActiveStoreCubit>().state!.storeId;

  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    extra: _storeId,
  );

  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
    extra: _storeId,
  );

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state case HomeError(:final message)) showSnackBar(message);
        // Warm-start background refresh failed — cached content is still
        // showing, so this is a toast, not an error view.
        if (state case HomeLoaded(refreshFailed: true)) {
          showSnackBar(GraviaValueConst.homeLoadErrorMessage);
        }
      },
      // The header is built ONCE, outside the switcher, and only the body
      // swaps — which is what this screen always intended. Building it per
      // state meant two copies were mounted at once for the length of a
      // crossfade, and its `SearchFieldBar` carries a fixed `Hero` tag:
      // two heroes sharing a tag in one route is a hard framework error,
      // not a cosmetic one. It also keeps the sheet's scroll position
      // across a refresh instead of resetting it.
      builder: (context, state) => CollapsingHeaderSheet(
        header: HomeHeroHeader(
          storeId: _storeId,
          addressLabel:
              selectedAddressLabel ??
              GraviaValueConst.noLocationSelectedLabel,
          onLocationTap: openSelectAddress,
          onNotificationTap: () => context.push(AppRoutes.notifications),
          onSearchTap: () => context.push(AppRoutes.search, extra: _storeId),
        ),
        body: AppSwitcher(
          child: switch (state) {
            HomeLoading() => const HomeSkeletonBody(
              key: ValueKey('loading'),
            ),
            HomeError() => Padding(
              key: const ValueKey('error'),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl10),
              child: ErrorView(
                message: GraviaValueConst.homeLoadErrorMessage,
                onRetry: () => context.read<HomeBloc>().add(
                  HomeEvent.started(storeId: _storeId),
                ),
              ),
            ),
            HomeLoaded(:final home) => _HomeContent(
              key: const ValueKey('loaded'),
              home: home,
              onAddToCart: _addToCart,
              onQuickAdd: _showAddToCartSheet,
              onFavouriteToggle: (product) =>
                  context.read<FavouritesCubit>().toggle(product),
              onProductTap: _openProductDetails,
              onCategoryTap: _openCategoryDetails,
              onSeeAllCategories: () => context.go(
                AppRoutes.storefront,
                extra: StorefrontRouteArgs(
                  store: context.read<ActiveStoreCubit>().state!,
                  initialTab: ShellPage.categoriesTabIndex,
                ),
              ),
            ),
          },
        ),
      ),
    );
  }
}

/// The loaded body only — the header and the sheet around it are owned by
/// [HomeScreen] and outlive every state swap (see its `builder`).
class _HomeContent extends StatelessWidget {
  final HomeEntity home;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<ProductEntity> onFavouriteToggle;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final VoidCallback onSeeAllCategories;

  const _HomeContent({
    super.key,
    required this.home,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onFavouriteToggle,
    required this.onProductTap,
    required this.onCategoryTap,
    required this.onSeeAllCategories,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppSpacing.xl4,
      bottom: AppSpacing.xl10,
    ),
    child: Column(
      children: [
        HomeCategorySection(
          categories: home.categories,
          onSeeAllCategories: onSeeAllCategories,
          onCategoryTap: onCategoryTap,
        ),
        const SizedBox(height: AppSpacing.xl4),
        HomePopularItemsSection(
          products: home.popularProducts,
          onAddToCart: onAddToCart,
          onQuickAdd: onQuickAdd,
          onFavouriteToggle: onFavouriteToggle,
          onProductTap: onProductTap,
        ),
      ],
    ),
  );
}
