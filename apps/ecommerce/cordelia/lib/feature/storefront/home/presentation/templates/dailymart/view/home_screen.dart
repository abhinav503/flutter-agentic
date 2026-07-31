import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/banner_target_type.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/address/presentation/selected_address_label.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_screen_body.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';

import '../../../../domain/entities/home_entity.dart';
import '../../../bloc/home_bloc.dart';
import '../widgets/home_category_rail.dart';
import '../widgets/home_header.dart';
import '../widgets/home_popular_products_grid.dart';
import '../widgets/home_promo_carousel.dart';
import '../widgets/home_skeleton_body.dart';

/// `dailymart` template's Home — the pack's signature screen: one continuous
/// mint canvas carrying the header, a Top Seller carousel, a category rail
/// and a 2-column product grid, all scrolling as a single page (spec sheet
/// §8). No app bar, no coloured header block, no collapsing sheet.
///
/// Reads the same shared storefront `domain`/`data` as the `gravia` template
/// — everything store-scoped comes off [ActiveStoreCubit], so this widget
/// tree serves any store that selects `dailymart`.
class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen>
    with SelectedAddressLabelState {
  String get _storeId => context.read<ActiveStoreCubit>().state!.storeId;

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id), extra: _storeId);

  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
    extra: _storeId,
  );

  /// A banner links to a product or a category by id — or to nothing, in
  /// which case the card passes a null `onTap` and this is never reached.
  ///
  /// The category branch needs a display name for the details title, and Home
  /// already holds every category, so it resolves one here rather than having
  /// the banner snapshot a name that a later rename would leave stale.
  void _openBanner(BannerEntity banner, HomeEntity home) {
    switch (banner.targetType) {
      case BannerTargetType.product:
        context.push(
          AppRoutes.productDetailsPath(banner.targetId),
          extra: _storeId,
        );
      case BannerTargetType.category:
        final matches = home.categories.where((c) => c.id == banner.targetId);
        if (matches.isNotEmpty) _openCategoryDetails(matches.first);
      case BannerTargetType.none:
        break;
    }
  }

  void _addToCart(ProductEntity product, int quantity) {
    context.read<CartCubit>().addToCart(product, quantity);
    showSnackBar(
      DailyMartValueConst.addedToCartMessage(product.name, quantity),
    );
  }

  /// The card's **+** opens the quantity sheet — same entry as Search's
  /// result rows and Product Details, so "add to cart" is one gesture
  /// everywhere in this pack.
  void _showAddToCartSheet(ProductEntity product) =>
      showDailyMartAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.canvas,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state case HomeError(:final message)) showSnackBar(message);
            // Cached content is still on screen — a failed silent refresh
            // is a toast, not an error view.
            if (state case HomeLoaded(refreshFailed: true)) {
              showSnackBar(DailyMartValueConst.homeLoadErrorMessage);
            }
          },
          // Every state shares the header and the scroll shell, so only the
          // body swaps — a differently-structured loading (or error) state
          // makes the whole page jump when data lands, and an error outside
          // the shell would lose the header and its bottom inset.
          builder: (context, state) => DailyMartScreenBody(
            headerRow: DailyMartHomeHeader(
              addressLabel: _addressLabel,
              onLocationTap: openSelectAddress,
              onNotificationTap: _openNotifications,
              onSearchTap: _openSearch,
              storeId: _storeId,
            ),
            gap: AppSpacing.xl4,
            // The shell's nav bar owns the bottom edge; this is breathing
            // room above it, not a device inset.
            bottomInset: AppSpacing.xl10,
            fullBleedBody: true,
            body: switch (state) {
              HomeError() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: ErrorView(
                  message: DailyMartValueConst.homeLoadErrorMessage,
                  onRetry: () => context.read<HomeBloc>().add(
                    HomeEvent.started(storeId: _storeId),
                  ),
                ),
              ),
              HomeLoading() => const DailyMartHomeSkeletonBody(),
              HomeLoaded(:final home) => _HomeContent(
                home: home,
                onProductTap: _openProductDetails,
                onCategoryTap: _openCategoryDetails,
                onBannerTap: (banner) => _openBanner(banner, home),
                onAddToCart: _showAddToCartSheet,
                onFavouriteToggle: (product) =>
                    context.read<FavouritesCubit>().toggle(product),
              ),
            },
          ),
        ),
      ),
    );
  }

  String get _addressLabel =>
      selectedAddressLabel ?? DailyMartValueConst.noLocationSelectedLabel;

  void _openNotifications() => context.push(AppRoutes.notifications);

  void _openSearch() => context.push(AppRoutes.search, extra: _storeId);
}

class _HomeContent extends StatelessWidget {
  final HomeEntity home;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final ValueChanged<BannerEntity> onBannerTap;
  final ValueChanged<ProductEntity> onAddToCart;
  final ValueChanged<ProductEntity> onFavouriteToggle;

  const _HomeContent({
    required this.home,
    required this.onProductTap,
    required this.onCategoryTap,
    required this.onBannerTap,
    required this.onAddToCart,
    required this.onFavouriteToggle,
  });

  /// How many top sellers stand in for banners (see [_promosFromTopSellers]).
  /// The kit shows three peeking cards; beyond that the rail stops reading as
  /// a highlight. It doesn't cap real banners — silently dropping a store's
  /// fourth banner would be worse than a longer rail.
  static const _fallbackPromoCount = 3;

  /// A store that hasn't added banners yet still gets a Top Seller rail: its
  /// top products stand in, each linking to itself, with the subtitle derived
  /// from its own discount — exactly what this carousel showed before the
  /// banners resource existed.
  static List<BannerEntity> _promosFromTopSellers(
    List<ProductEntity> products,
  ) => products
      .take(_fallbackPromoCount)
      .map(
        (product) => BannerEntity(
          id: product.id,
          imageUrl: product.imageUrl,
          title: product.name,
          subtitle: DailyMartValueConst.promoSubtitle(
            product.discountPercentage,
          ),
          targetType: BannerTargetType.product,
          targetId: product.id,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final promos = home.banners.isNotEmpty
        ? home.banners
        : _promosFromTopSellers(home.popularProducts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (promos.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: DailyMartSectionHeader(
              title: DailyMartValueConst.topSellerTitle,
              onSeeAll: () => _openBrowse(context),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          DailyMartHomePromoCarousel(banners: promos, onBannerTap: onBannerTap),
          const SizedBox(height: AppSpacing.xl4),
        ],
        DailyMartHomeCategoryRail(
          categories: home.categories,
          onCategoryTap: onCategoryTap,
          onSeeAll: () => _openBrowse(context),
        ),
        const SizedBox(height: AppSpacing.xl4),
        DailyMartHomePopularProductsGrid(
          products: home.popularProducts,
          onAddToCart: onAddToCart,
          onProductTap: onProductTap,
          onFavouriteToggle: onFavouriteToggle,
          onSeeAll: () => _openBrowse(context),
        ),
        SizedBox(height: DailyMartDimenConst.floatingActionScrollInset(context)),
      ],
    );
  }

  /// This template has no Categories tab of its own yet (the shell's tab set
  /// is Home / Wishlist / Cart / Profile), so every "See all" lands on the
  /// shared Search screen scoped to the active store rather than a dead end.
  void _openBrowse(BuildContext context) => context.push(
    AppRoutes.search,
    extra: context.read<ActiveStoreCubit>().state!.storeId,
  );
}
