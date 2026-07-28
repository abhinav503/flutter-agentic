import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/banner_target_type.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/address/presentation/templates/gravia/view/address_page.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';

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

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  String? _selectedAddressLabel;

  @override
  void initState() {
    super.initState();
    _loadSelectedAddress();
  }

  void _loadSelectedAddress() {
    _selectedAddressLabel = SharedPreferenceService.instance.getString(
      kSelectedAddressLabelPrefKey,
    );
  }

  String get _storeId => context.read<ActiveStoreCubit>().state!.storeId;

  Future<void> _openSelectAddress() async {
    await context.push(AppRoutes.selectAddress);
    if (!mounted) return;
    setState(_loadSelectedAddress);
  }

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

  /// The card's **+** adds one unit outright — this pack has no quantity
  /// sheet on the card (spec sheet §10).
  void _addToCart(ProductEntity product) =>
      context.read<CartCubit>().addToCart(product, 1);

  @override
  Widget body(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // The canvas is a light mint (or, in dark mode, the near-black
      // surface) — the status bar draws straight onto it, so its icons take
      // the theme's brightness rather than the light-on-colour pairing a
      // coloured header would need.
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: ColoredBox(
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
            builder: (context, state) => switch (state) {
              HomeError() => ErrorView(
                message: DailyMartValueConst.homeLoadErrorMessage,
                onRetry: () => context.read<HomeBloc>().add(
                  HomeEvent.started(storeId: _storeId),
                ),
              ),
              // Loading and loaded share the header and the scroll view, so
              // only the body swaps — a differently-structured loading state
              // makes the whole page jump when data lands.
              HomeLoading() => _Page(
                addressLabel: _addressLabel,
                onLocationTap: _openSelectAddress,
                onNotificationTap: _openNotifications,
                onSearchTap: _openSearch,
                body: const DailyMartHomeSkeletonBody(),
              ),
              HomeLoaded(:final home) => _Page(
                addressLabel: _addressLabel,
                onLocationTap: _openSelectAddress,
                onNotificationTap: _openNotifications,
                onSearchTap: _openSearch,
                body: _HomeContent(
                  home: home,
                  onProductTap: _openProductDetails,
                  onCategoryTap: _openCategoryDetails,
                  onBannerTap: (banner) => _openBanner(banner, home),
                  onAddToCart: _addToCart,
                  onFavouriteToggle: (product) =>
                      context.read<FavouritesCubit>().toggle(product),
                ),
              ),
            },
          ),
        ),
      ),
    );
  }

  String get _addressLabel =>
      _selectedAddressLabel ?? DailyMartValueConst.noLocationSelectedLabel;

  void _openNotifications() => context.push(AppRoutes.notifications);

  void _openSearch() => context.push(AppRoutes.search, extra: _storeId);
}

/// The page shell both the skeleton and the loaded body sit in.
class _Page extends StatelessWidget {
  final String addressLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;
  final Widget body;

  const _Page({
    required this.addressLabel,
    required this.onLocationTap,
    required this.onNotificationTap,
    required this.onSearchTap,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: AppSpacing.xl10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.base,
            AppSpacing.lg,
            0,
          ),
          child: DailyMartHomeHeader(
            addressLabel: addressLabel,
            onLocationTap: onLocationTap,
            onNotificationTap: onNotificationTap,
            onSearchTap: onSearchTap,
          ),
        ),
        const SizedBox(height: AppSpacing.xl4),
        body,
      ],
    ),
  );
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
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            child: DailyMartHomePromoCarousel(
              banners: promos,
              onBannerTap: onBannerTap,
            ),
          ),
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
