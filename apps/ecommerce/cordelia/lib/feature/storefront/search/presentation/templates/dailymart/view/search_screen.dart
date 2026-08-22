import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/enums/recent_search_type.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/widgets/cart_status_bar.dart';
// Cross-feature reuse, not duplication — Search's product grid is the same
// composition and data shape as Home's Popular Products.
import 'package:cordelia/feature/storefront/home/presentation/templates/dailymart/widgets/home_popular_products_grid.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_search_bar.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../../home/domain/entities/category_entity.dart';
import '../../../../../home/domain/entities/product_entity.dart';
import '../../../../domain/entities/recent_search_entity.dart';
import '../../../../domain/entities/search_entity.dart';
import '../../../../domain/entities/search_results_entity.dart';
import '../../../bloc/search_bloc.dart';
import '../widgets/recent_search_section.dart';
import '../widgets/search_field_bar.dart';
import '../widgets/search_results_section.dart';
import '../widgets/search_skeleton_body.dart';

/// `dailymart` template's Search — the kit's screens `19`/`20`: back disc +
/// live search field pinned at the top, then either the browse body (Recent
/// Search rows + the product grid) or the results body (result count + one
/// vertical list of categories and products). The kit's Filter pill belongs
/// to Category Details, not here.
///
/// The header row stays outside the swapping body on purpose — rebuilding
/// the text field between states detaches its focus node and closes the
/// keyboard (the bug gravia's search hit first).
class SearchScreen extends BaseScreen {
  final String storeId;

  const SearchScreen({super.key, required this.storeId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseScreenState<SearchScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Animation<double>? _routeAnimation;

  @override
  void initState() {
    super.initState();
    // Focus only once the route transition has settled — grabbing it during
    // the fade animates the keyboard against the page and drops frames.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _searchFocus.requestFocus();
      } else {
        _routeAnimation = animation..addStatusListener(_onRouteAnimationStatus);
      }
    });
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _routeAnimation = null;
    if (mounted) _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _goBack() {
    _searchFocus.unfocus();
    context.pop();
  }

  Future<void> _addToCart(ProductEntity product, int quantity) async {
    if (!await context.addToCartOrSignIn(product, quantity) || !mounted) return;
    showSnackBar(
      DailyMartValueConst.addedToCartMessage(product.name, quantity),
    );
  }

  void _showAddToCartSheet(ProductEntity product) =>
      showDailyMartAddToCartSheet(product: product, onAddToCart: _addToCart);

  void _openCart() =>
      context.pushIfSignedIn(AppRoutes.cart, extra: widget.storeId);

  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    extra: widget.storeId,
  );

  // Tapping any search result records it as a recent search (the bloc's
  // concern) and deep-links to its details page (this screen's concern).
  void _openProductResult(ProductEntity product) {
    context.read<SearchBloc>().add(
      SearchEvent.resultSelected(
        item: RecentSearchEntity(
          id: product.id,
          name: product.name,
          type: RecentSearchType.product,
        ),
      ),
    );
    _openProductDetails(product);
  }

  void _openCategoryResult(CategoryEntity category) {
    context.read<SearchBloc>().add(
      SearchEvent.resultSelected(
        item: RecentSearchEntity(
          id: category.id,
          name: category.name,
          type: RecentSearchType.category,
        ),
      ),
    );
    context.push(
      AppRoutes.categoryDetailsPath(category.id, category.name),
      extra: widget.storeId,
    );
  }

  // Re-selecting an existing recent moves it back to the top of the list.
  void _openRecent(RecentSearchEntity item) {
    context.read<SearchBloc>().add(SearchEvent.resultSelected(item: item));
    switch (item.type) {
      case RecentSearchType.product:
        context.push(
          AppRoutes.productDetailsPath(item.id),
          extra: widget.storeId,
        );
      case RecentSearchType.category:
        context.push(
          AppRoutes.categoryDetailsPath(item.id, item.name),
          extra: widget.storeId,
        );
    }
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cartItems = context.watch<CartCubit>().state;

    return ColoredBox(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state case SearchError(:final message)) showSnackBar(message);
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.base,
                    AppSpacing.lg,
                    0,
                  ),
                  child: Row(
                    children: [
                      DailyMartIconDisc(
                        asset: ImageConst.arrowLeft,
                        iconSize: AppSpacing.xl2,
                        onTap: _goBack,
                      ),
                      const SizedBox(width: AppSpacing.base),
                      Expanded(
                        child: DailyMartSearchFieldBar(
                          heroTag: DailyMartSearchBar.heroTagFor(
                            widget.storeId,
                          ),
                          controller: _searchController,
                          focusNode: _searchFocus,
                          onChanged: (value) => context.read<SearchBloc>().add(
                            SearchEvent.queryChanged(query: value),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl2),
                Expanded(
                  child: Stack(
                    children: [
                      DailyMartTopSwitcher(
                        child: switch (state) {
                          // Same bottom clearance as the loaded results, so
                          // the skeleton scrolls clear of the device inset.
                          SearchLoading() => SingleChildScrollView(
                            key: const ValueKey('loading'),
                            padding: EdgeInsets.only(
                              bottom:
                                  DailyMartDimenConst.floatingActionScrollInset(
                                    context,
                                  ),
                            ),
                            child: const DailyMartSearchSkeletonBody(),
                          ),
                          SearchError() => Padding(
                            key: const ValueKey('error'),
                            // Bottom re-adds the device inset — this branch
                            // sits in the same SafeArea(bottom: false) as the
                            // others, so it owns its own bottom edge.
                            padding: EdgeInsets.fromLTRB(
                              0,
                              AppSpacing.xl4,
                              0,
                              AppSpacing.xl4 +
                                  MediaQuery.paddingOf(context).bottom,
                            ),
                            child: ErrorView(
                              message:
                                  DailyMartValueConst.searchLoadErrorMessage,
                              onRetry: () => context.read<SearchBloc>().add(
                                const SearchEvent.started(),
                              ),
                            ),
                          ),
                          SearchLoaded(
                            :final search,
                            :final query,
                            :final searching,
                            :final results,
                            :final resultsError,
                          ) =>
                            KeyedSubtree(
                              key: const ValueKey('loaded'),
                              child: query.isEmpty
                                  ? _browseBody(search)
                                  : _resultsBody(
                                      query,
                                      searching,
                                      results,
                                      resultsError,
                                    ),
                            ),
                        },
                      ),
                      // The cart pill floats over the bottom fade so
                      // scrolling content dissolves rather than collides
                      // (spec sheet §11).
                      if (cartItems.isNotEmpty) ...[
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: DailyMartBottomFade(),
                        ),
                        _BottomSlot(
                          fullWidth: true,
                          child: DailyMartCartStatusBar(
                            itemCount: cartItems.itemCount,
                            grandTotal: cartItems.grandTotal,
                            onTap: _openCart,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _browseBody(SearchEntity search) => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: AppSpacing.xl13),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The section renders nothing when recents are empty — the spacer
        // must go with it, or the grid gets a stray gap above it.
        if (search.recentSearches.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: DailyMartRecentSearchSection(
              items: search.recentSearches,
              onItemTap: _openRecent,
              onRemove: (item) => context.read<SearchBloc>().add(
                SearchEvent.recentSearchRemoved(item: item),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl4),
        ],
        DailyMartHomePopularProductsGrid(
          products: search.popularProducts,
          onAddToCart: _showAddToCartSheet,
          onProductTap: _openProductDetails,
          onFavouriteToggle: (product) =>
              context.toggleFavouriteOrSignIn(product),
        ),
      ],
    ),
  );

  Widget _resultsBody(
    String query,
    bool searching,
    SearchResultsEntity? results,
    String? resultsError,
  ) {
    if (resultsError != null) {
      return ErrorView(
        message: DailyMartValueConst.searchResultsErrorMessage,
        onRetry: () => context.read<SearchBloc>().add(
          SearchEvent.queryChanged(query: query),
        ),
      );
    }
    // `results == null` without an error means the search is still in
    // flight (or the debounce hasn't fired) — same visual as `searching`.
    if (searching || results == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.xl4),
        child: Center(child: LoadingDots()),
      );
    }
    if (results.products.isEmpty && results.categories.isEmpty) {
      return EmptyState(
        iconData: Icons.search_off_rounded,
        title: DailyMartValueConst.searchNoResultsTitle,
        subtitle: DailyMartValueConst.searchNoResultsSubtitle(query),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl13,
      ),
      child: DailyMartSearchResultsSection(
        query: query,
        categories: results.categories,
        products: results.products,
        onCategoryTap: _openCategoryResult,
        onProductTap: _openProductResult,
        onAdd: _showAddToCartSheet,
      ),
    );
  }
}

/// Docks its child over the fade, clear of the device's bottom inset (the
/// screen's own SafeArea deliberately leaves the bottom edge to the fade).
class _BottomSlot extends StatelessWidget {
  final Widget child;
  final bool fullWidth;

  const _BottomSlot({required this.child, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      bottom: bottomInset + AppSpacing.lg,
      child: fullWidth ? child : Center(child: child),
    );
  }
}
