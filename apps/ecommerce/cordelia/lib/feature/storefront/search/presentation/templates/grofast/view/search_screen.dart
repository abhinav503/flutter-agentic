import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/recent_search_type.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/category_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/search/domain/entities/recent_search_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_search_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../widgets/search_skeleton_body.dart';
import '../../../bloc/search_bloc.dart';
import '../widgets/recent_search_section.dart';

/// `grofast` template's Search (kit frames `119:795` / `146:1237` /
/// `148:2151`): a live search field under the header, the recent-search list
/// while the field is empty, and the pack's staggered grid of results once it
/// isn't.
///
/// The kit's results screen also lists matching *categories* above the
/// products; that stays, rendered as the pack's chip row rather than the
/// kit's list rows, so a category match is one tap from here.
class SearchScreen extends BaseScreen {
  final String storeId;

  const SearchScreen({super.key, required this.storeId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseScreenState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openProductDetails(ProductEntity product) {
    context.read<SearchBloc>().add(
      SearchEvent.resultSelected(
        item: RecentSearchEntity(
          id: product.id,
          name: product.name,
          type: RecentSearchType.product,
        ),
      ),
    );
    context.push(
      AppRoutes.productDetailsPath(product.id),
      extra: widget.storeId,
    );
  }

  void _openCategoryDetails(CategoryEntity category) {
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

  /// A recent search deep-links straight back to whatever kind it was.
  void _openRecent(RecentSearchEntity item) => switch (item.type) {
    RecentSearchType.product => context.push(
      AppRoutes.productDetailsPath(item.id),
      extra: widget.storeId,
    ),
    RecentSearchType.category => context.push(
      AppRoutes.categoryDetailsPath(item.id, item.name),
      extra: widget.storeId,
    ),
  };

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
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) => GrofastScreenBody(
          headerRow: Column(
            children: [
              GrofastHeaderRow(
                title: GrofastValueConst.searchTitle,
                trailing: GrofastBagAction(storeId: widget.storeId),
              ),
              const SizedBox(height: AppSpacing.xl2),
              // The kit docks its filter square here too, opening the Sort
              // By / Price sheet. `SearchBloc` carries neither axis — those
              // live on `CategoryDetailsBloc`, which is where this pack does
              // ship the square — so reproducing it would be a control that
              // decides nothing (spec sheet §11).
              GrofastSearchField(
                hint: GrofastValueConst.searchHint,
                controller: _controller,
                autofocus: true,
                onChanged: (query) => context.read<SearchBloc>().add(
                  SearchEvent.queryChanged(query: query),
                ),
              ),
            ],
          ),
          gap: AppSpacing.xl4,
          body: GrofastSwitcher(
            child: switch (state) {
              SearchLoading() => const GrofastSearchSkeletonBody(),
              SearchError(:final message) => GrofastErrorView(
                message: message,
                onRetry: () =>
                    context.read<SearchBloc>().add(const SearchEvent.started()),
              ),
              SearchLoaded(query: '') => GrofastRecentSearchSection(
                items: state.search.recentSearches,
                onItemTap: _openRecent,
                onItemRemove: (item) => context.read<SearchBloc>().add(
                  SearchEvent.recentSearchRemoved(item: item),
                ),
              ),
              SearchLoaded(searching: true) =>
                const GrofastSearchSkeletonBody(),
              SearchLoaded(:final resultsError?, :final query) =>
                GrofastErrorView(
                  message: resultsError,
                  onRetry: () => context.read<SearchBloc>().add(
                    SearchEvent.queryChanged(query: query),
                  ),
                ),
              SearchLoaded(:final results?, :final query) => _SearchResults(
                products: results.products,
                categories: results.categories,
                query: query,
                onProductTap: _openProductDetails,
                onCategoryTap: _openCategoryDetails,
                onAddToBag: _addToBag,
                onFavouriteToggle: (product) =>
                    context.read<FavouritesCubit>().toggle(product),
              ),
              // A non-empty query with neither results nor an error yet —
              // the debounce window before the fetch starts.
              SearchLoaded() => const GrofastSearchSkeletonBody(),
            },
          ),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<ProductEntity> products;
  final List<CategoryEntity> categories;
  final String query;
  final ValueChanged<ProductEntity> onProductTap;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final ValueChanged<ProductEntity> onAddToBag;
  final ValueChanged<ProductEntity> onFavouriteToggle;

  const _SearchResults({
    required this.products,
    required this.categories,
    required this.query,
    required this.onProductTap,
    required this.onCategoryTap,
    required this.onAddToBag,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    if (products.isEmpty && categories.isEmpty) {
      return GrofastEmptyState(
        icon: Icons.search_off_rounded,
        title: GrofastValueConst.searchNoResultsTitle,
        subtitle: GrofastValueConst.searchNoResultsSubtitle(query),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GrofastValueConst.resultsCountLabel(products.length),
          style: GrofastTextStyleConst.sectionBold(tt),
        ),
        const SizedBox(height: AppSpacing.xl2),
        if (categories.isNotEmpty) ...[
          // One horizontal band that scrolls off the edge, like every chip
          // row in this pack — wrapping to more lines would push the grid
          // down by however many categories happened to match.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                for (final (i, category) in categories.indexed) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
                  _CategoryResultChip(
                    category: category,
                    onTap: () => onCategoryTap(category),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl2),
        ],
        GrofastProductGrid(
          products: products,
          onAdd: onAddToBag,
          onProductTap: onProductTap,
          onFavouriteToggle: onFavouriteToggle,
        ),
      ],
    );
  }
}

/// A matched category, rendered as a chip rather than the kit's list row so
/// several of them stay one compact band above the product grid.
class _CategoryResultChip extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const _CategoryResultChip({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSpacing.xl7,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        // A pill, not a rounded box — the kit's 18 is exactly half the row's
        // 36, so it reads as `full` rather than as a radius of its own.
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: AppRadius.full,
        ),
        child: Text(
          category.name,
          style: GrofastTextStyleConst.bodyMedium(
            tt,
          ).copyWith(color: cs.onSurface),
        ),
      ),
    );
  }
}
