import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/enums/product_price_filter.dart';
import 'package:cordelia/enums/product_sort_option.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/dailymart/widgets/cart_status_bar.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_filter_pill.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_search_bar.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../bloc/category_details_bloc.dart';
import '../widgets/category_details_filter_sheet_content.dart';
import '../widgets/category_details_skeleton_body.dart';

/// `dailymart` template's Category Details (kit frames `20`/`21`) — back disc
/// + search bar over a result-count row and the pack's 2-column product grid,
/// with the floating Filter pill opening the sort/price sheet.
///
/// The kit draws this layout as its *Search results* frame; this pack put a
/// different body on Search (a vertical list mixing categories and products,
/// see `SearchScreen`) and reserved the gridded one — and the Filter pill the
/// kit floats over it — for here, which is the screen that actually has a
/// fixed result set to sort and filter.
///
/// Two departures from that frame, both because it is a *search* frame being
/// reused: its editable field becomes the pack's idle tap-to-navigate
/// [DailyMartSearchBar] (typing belongs to Search, which this pushes), and
/// its `Result for "Fruits"` heading becomes the category's own name — this
/// screen is a category, not a query, and quoting the name back as a search
/// term would misdescribe how the shopper got here. The count keeps the
/// kit's own "N founds" wording.
class CategoryDetailsScreen extends BaseScreen {
  final String storeId;
  final String categoryName;

  const CategoryDetailsScreen({
    super.key,
    required this.storeId,
    required this.categoryName,
  });

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState
    extends BaseScreenState<CategoryDetailsScreen> {
  Future<void> _addToCart(ProductEntity product, int quantity) async {
    if (!await context.addToCartOrSignIn(product, quantity) || !mounted) return;
    showSnackBar(
      DailyMartValueConst.addedToCartMessage(product.name, quantity),
    );
  }

  void _showAddToCartSheet(ProductEntity product) =>
      showDailyMartAddToCartSheet(product: product, onAddToCart: _addToCart);

  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    extra: widget.storeId,
  );

  void _openSearch() => context.push(AppRoutes.search, extra: widget.storeId);

  void _openCart() =>
      context.pushIfSignedIn(AppRoutes.cart, extra: widget.storeId);

  /// Both exits of the sheet (Reset and Apply) land here — Reset simply
  /// commits the defaults, so one path covers clearing and committing.
  Future<void> _openFilterSheet(CategoryDetailsLoaded state) {
    final bloc = context.read<CategoryDetailsBloc>();

    return showDailyMartSheet(
      title: DailyMartValueConst.filterLabel,
      child: DailyMartCategoryFilterSheetContent(
        initialSort: state.sort,
        initialPriceFilter: state.priceFilter,
        showSheet: showDailyMartSheet,
        onApply: (sort, priceFilter) {
          bloc
            ..add(CategoryDetailsEvent.sortChanged(sort: sort))
            ..add(
              CategoryDetailsEvent.priceFilterChanged(priceFilter: priceFilter),
            );
          Navigator.of(context).pop();
        },
      ),
    );
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
      // The floating controls re-add the device inset themselves, so the fade
      // behind them can bleed to the edge.
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<CategoryDetailsBloc, CategoryDetailsState>(
          builder: (context, state) => Column(
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
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: AppSpacing.base),
                    // No hero tag: the flight pairs Home's bar with Search's
                    // field, and a third bar sharing it would make the tag
                    // ambiguous while this screen is on the stack.
                    Expanded(child: DailyMartSearchBar(onTap: _openSearch)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl2),
              Expanded(
                child: Stack(
                  children: [
                    DailyMartTopSwitcher(
                      child: switch (state) {
                        // Same bottom clearance as the loaded grid, so the
                        // skeleton scrolls clear of the pill and the device
                        // inset like the content it stands in for.
                        CategoryDetailsLoading() => SingleChildScrollView(
                          key: const ValueKey('loading'),
                          padding: EdgeInsets.only(
                            bottom:
                                DailyMartDimenConst.floatingActionScrollInset(
                                  context,
                                ),
                          ),
                          child: const DailyMartCategoryDetailsSkeletonBody(),
                        ),
                        CategoryDetailsError(
                          :final storeId,
                          :final categoryId,
                          :final categoryName,
                        ) =>
                          Padding(
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
                              message: DailyMartValueConst
                                  .categoryDetailsErrorMessage,
                              onRetry: () =>
                                  context.read<CategoryDetailsBloc>().add(
                                    CategoryDetailsEvent.started(
                                      storeId: storeId,
                                      categoryId: categoryId,
                                      categoryName: categoryName,
                                    ),
                                  ),
                            ),
                          ),
                        final CategoryDetailsLoaded loaded => KeyedSubtree(
                          key: const ValueKey('loaded'),
                          child: _LoadedBody(
                            state: loaded,
                            cartDocked: cartItems.isNotEmpty,
                            onAdd: _showAddToCartSheet,
                            onProductTap: _openProductDetails,
                          ),
                        ),
                      },
                    ),
                    // Loaded only: there is nothing to sort behind a skeleton,
                    // and an error state has no grid to narrow.
                    if (state case final CategoryDetailsLoaded loaded) ...[
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        // Grows with the cluster: the standard fade is sized
                        // for one floating control, and a stacked pair would
                        // otherwise have its top pill sitting on undissolved
                        // content.
                        child: DailyMartBottomFade(
                          height:
                              DailyMartDimenConst.bottomFadeHeight +
                              (cartItems.isEmpty
                                  ? 0
                                  : DailyMartDimenConst.controlHeight +
                                        AppSpacing.base),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.lg,
                        right: AppSpacing.lg,
                        bottom:
                            MediaQuery.paddingOf(context).bottom +
                            AppSpacing.lg,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DailyMartFilterPill(
                              active:
                                  loaded.sort != ProductSortOption.relevance ||
                                  loaded.priceFilter != ProductPriceFilter.all,
                              onTap: () => _openFilterSheet(loaded),
                            ),
                            // The cart pill every out-of-shell screen floats
                            // (spec sheet §8) stacks under the Filter pill
                            // rather than replacing it — they answer
                            // different questions, and this is the one screen
                            // in the pack where both belong.
                            if (cartItems.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.base),
                              DailyMartCartStatusBar(
                                itemCount: cartItems.itemCount,
                                grandTotal: cartItems.grandTotal,
                                onTap: _openCart,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The result-count row over the grid — the kit's `20` body, minus its
/// search-specific heading (see [CategoryDetailsScreen]).
class _LoadedBody extends StatelessWidget {
  final CategoryDetailsLoaded state;

  /// Whether the cart pill is stacked under the Filter pill, which makes the
  /// floating cluster taller and the scroll inset with it.
  final bool cartDocked;

  final ValueChanged<ProductEntity> onAdd;
  final ValueChanged<ProductEntity> onProductTap;

  const _LoadedBody({
    required this.state,
    required this.cartDocked,
    required this.onAdd,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final products = state.visibleProducts;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        DailyMartDimenConst.floatingActionScrollInset(context) +
            (cartDocked
                ? DailyMartDimenConst.controlHeight + AppSpacing.base
                : 0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  state.categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DailyMartTextStyleConst.bodyLgSemibold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Text(
                DailyMartValueConst.resultsCountLabel(products.length),
                style: DailyMartTextStyleConst.bodyMdMedium(
                  tt,
                ).copyWith(color: cs.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl4),
              child: EmptyState(
                iconData: Icons.filter_alt_off_outlined,
                title: DailyMartValueConst.categoryDetailsEmptyTitle,
                subtitle: DailyMartValueConst.categoryDetailsEmptySubtitle,
              ),
            )
          else
            DailyMartProductGrid(
              products: products,
              onAdd: onAdd,
              onProductTap: onProductTap,
              onFavouriteToggle: (product) =>
                  context.toggleFavouriteOrSignIn(product),
            ),
        ],
      ),
    );
  }
}
