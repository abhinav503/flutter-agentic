import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/banner_target_type.dart';
import 'package:cordelia/feature/storefront/active_store/presentation/cubit/active_store_cubit.dart';
import 'package:cordelia/feature/storefront/address/presentation/selected_address_label.dart';
import 'package:cordelia/feature/storefront/address/presentation/templates/grofast/widgets/address_picker_sheet.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/banner_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../../domain/entities/home_entity.dart';
import '../../../bloc/home_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/home_promo_carousel.dart';
import '../widgets/home_sections.dart';

/// `grofast` template's Home (kit frame `17:1`) — the identity band, the
/// greeting, a search field, a peeking promo carousel, the category rail and
/// the staggered Popular grid, all scrolling as one white page (spec sheet
/// §8). No app bar and no coloured header block.
///
/// Reads the same shared storefront `domain`/`data` as the other two
/// templates — everything store-scoped comes off [ActiveStoreCubit].
class HomeScreen extends BaseScreen {
  /// Opens the Categories tab — the shell owns tab state, so "see all" is
  /// handed down rather than routed.
  final VoidCallback onSeeAllCategories;

  const HomeScreen({super.key, required this.onSeeAllCategories});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen>
    with SelectedAddressLabelState {
  String get _storeId => context.read<ActiveStoreCubit>().state!.storeId;

  String get _addressLabel =>
      selectedAddressLabel ?? GrofastValueConst.noLocationSelectedLabel;

  /// This pack picks addresses in the kit's Select Location sheet, not the
  /// routed page the shared mixin pushes — same commit, same pref re-read.
  Future<void> _openAddressPicker() async {
    await showGrofastAddressPicker(this);
    if (!mounted) return;
    setState(loadSelectedAddressLabel);
  }

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id), extra: _storeId);

  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
    extra: _storeId,
  );

  void _openSearch() => context.push(AppRoutes.search, extra: _storeId);

  void _openNotifications() => context.push(AppRoutes.notifications);

  /// A banner links to a product or a category by id — or to nothing, in
  /// which case the card passes a null `onTap` and this is never reached.
  ///
  /// The category branch needs a display name for the details title, and Home
  /// already holds every category, so it resolves one here rather than having
  /// the banner snapshot a name a later rename would leave stale.
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

  /// The card's corner **+** adds one unit straight to the bag — this pack
  /// has no quantity sheet on a card; that lives on Product Details.
  void _addToBag(ProductEntity product) {
    context.read<CartCubit>().addToCart(product, 1);
    showSnackBar(GrofastValueConst.addedToBagMessage(product.name, 1));
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state case HomeError(:final message)) showSnackBar(message);
          // Cached content is still on screen — a failed silent refresh is a
          // toast, not an error view.
          if (state case HomeLoaded(refreshFailed: true)) {
            showSnackBar(GrofastValueConst.homeLoadErrorMessage);
          }
        },
        // Every state shares the header and the scroll shell, so only the
        // body swaps — a differently-structured loading (or error) state
        // makes the whole page jump when data lands, and an error outside the
        // shell would lose the header and its bottom inset.
        builder: (context, state) => GrofastScreenBody(
          headerRow: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GrofastHomeHeader(
                addressLabel: _addressLabel,
                onLocationTap: _openAddressPicker,
                onNotificationTap: _openNotifications,
              ),
              const SizedBox(height: AppSpacing.xl2),
              GrofastSearchField(
                hint: GrofastValueConst.searchHint,
                onTap: _openSearch,
              ),
            ],
          ),
          gap: AppSpacing.xl4,
          fullBleedBody: true,
          // The shell runs `extendBody`, so this scroll view reaches under
          // the nav: clear the bar, and let the last row pass behind the
          // dome — that content is what makes the dome visible.
          bottomInset: GrofastDimenConst.navScrollInset(context),
          body: GrofastSwitcher(
            child: switch (state) {
              HomeLoading() => const GrofastHomeSkeletonBody(),
              HomeError(:final message) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GrofastDimenConst.screenGutter,
                ),
                child: GrofastErrorView(
                  message: message,
                  onRetry: () =>
                      context.read<HomeBloc>().add(const HomeEvent.started()),
                ),
              ),
              HomeLoaded(:final home) => _HomeContent(
                home: home,
                onProductTap: _openProductDetails,
                onCategoryTap: _openCategoryDetails,
                onBannerTap: (banner) => _openBanner(banner, home),
                onAddToBag: _addToBag,
                onFavouriteToggle: (product) =>
                    context.read<FavouritesCubit>().toggle(product),
                onSeeAllCategories: widget.onSeeAllCategories,
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeEntity home;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final ValueChanged<BannerEntity> onBannerTap;
  final ValueChanged<ProductEntity> onAddToBag;
  final ValueChanged<ProductEntity> onFavouriteToggle;
  final VoidCallback onSeeAllCategories;

  const _HomeContent({
    required this.home,
    required this.onProductTap,
    required this.onCategoryTap,
    required this.onBannerTap,
    required this.onAddToBag,
    required this.onFavouriteToggle,
    required this.onSeeAllCategories,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (home.banners.isNotEmpty) ...[
        GrofastHomePromoCarousel(
          banners: home.banners,
          onBannerTap: onBannerTap,
        ),
        const SizedBox(height: AppSpacing.xl6),
      ],
      if (home.categories.isNotEmpty) ...[
        GrofastHomeCategoryRail(
          categories: home.categories,
          onCategoryTap: onCategoryTap,
          onSeeAll: onSeeAllCategories,
        ),
        const SizedBox(height: AppSpacing.xl6),
      ],
      GrofastHomePopularGrid(
        products: home.popularProducts,
        onProductTap: onProductTap,
        onAddToBag: onAddToBag,
        onFavouriteToggle: onFavouriteToggle,
        onSeeAll: onSeeAllCategories,
      ),
    ],
  );
}
