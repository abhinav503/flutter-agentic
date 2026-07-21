import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_dots.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/recent_search_type.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

// Cross-feature reuse, not duplication — Search's "Popular Items" is the
// same composition and product data shape as Home's.
import '../../../home/domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/presentation/widgets/home_popular_items_section.dart';
import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_entity.dart';
import '../../domain/entities/search_results_entity.dart';
import '../bloc/search_bloc.dart';
import '../widgets/recent_search_section.dart';
import '../widgets/search_hero_header.dart';
import '../widgets/search_skeleton_body.dart';
import '../widgets/search_suggestions_section.dart';

class SearchScreen extends BaseScreen {
  const SearchScreen({super.key});

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

  void _addToCart(ProductEntity product, int quantity) =>
      showSnackBar(ValueConst.addedToCartMessage(product.name, quantity));

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

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
    context.push(AppRoutes.productDetailsPath(product.id));
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
    context.push(AppRoutes.categoryDetailsPath(category.id, category.name));
  }

  // Re-selecting an existing recent moves it back to the top of the list.
  void _openRecent(RecentSearchEntity item) {
    context.read<SearchBloc>().add(SearchEvent.resultSelected(item: item));
    switch (item.type) {
      case RecentSearchType.product:
        context.push(AppRoutes.productDetailsPath(item.id));
      case RecentSearchType.category:
        context.push(AppRoutes.categoryDetailsPath(item.id, item.name));
    }
  }

  Widget _header() => SearchHeroHeader(
    controller: _searchController,
    focusNode: _searchFocus,
    onBack: _goBack,
    onChanged: (value) =>
        context.read<SearchBloc>().add(SearchEvent.queryChanged(query: value)),
    onSubmitted: (_) {},
  );

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state case SearchError(:final message)) showSnackBar(message);
      },
      // One persistent sheet + header across every state — swapping whole
      // sheets in the AnimatedSwitcher rebuilt the header's text field on
      // loading → loaded, detaching the focus node and closing the keyboard
      // right after the screen opened. Only the sheet body animates now.
      builder: (context, state) => CollapsingHeaderSheet(
        initialHeaderHeight: 120,
        header: _header(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          // The default layout builder centers the child in the available
          // height — short bodies (a few suggestions) would float mid-sheet.
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.topCenter,
            children: [...previousChildren, ?currentChild],
          ),
          child: switch (state) {
            SearchLoading() => const SearchSkeletonBody(
              key: ValueKey('loading'),
            ),
            SearchError() => Padding(
              key: const ValueKey('error'),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
              child: ErrorView(
                message: ValueConst.searchLoadErrorMessage,
                onRetry: () =>
                    context.read<SearchBloc>().add(const SearchEvent.started()),
              ),
            ),
            SearchLoaded(
              :final search,
              :final query,
              :final searching,
              :final results,
              :final resultsError,
            ) =>
              Padding(
                key: const ValueKey('loaded'),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
                child: query.isEmpty
                    ? _browseBody(search)
                    : _resultsBody(query, searching, results, resultsError),
              ),
          },
        ),
      ),
    );
  }

  Widget _browseBody(SearchEntity search) => Column(
    children: [
      // The section renders nothing when recents are empty — the spacer must
      // go with it, or Popular Items gets a stray gap above it.
      if (search.recentSearches.isNotEmpty) ...[
        RecentSearchSection(
          items: search.recentSearches,
          onItemTap: _openRecent,
          onRemove: (item) => context.read<SearchBloc>().add(
            SearchEvent.recentSearchRemoved(item: item),
          ),
        ),
        const SizedBox(height: AppSpacing.xl4),
      ],
      HomePopularItemsSection(
        products: search.popularProducts,
        onAddToCart: _addToCart,
        onQuickAdd: _showAddToCartSheet,
        onFavouriteToggle: (_) {},
        onProductTap: _openProductDetails,
      ),
    ],
  );

  Widget _resultsBody(
    String query,
    bool searching,
    SearchResultsEntity? results,
    String? resultsError,
  ) {
    if (resultsError != null) {
      return ErrorView(
        message: ValueConst.searchResultsErrorMessage,
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
        iconData: Icons.search_off,
        title: ValueConst.searchNoResultsTitle,
        subtitle: ValueConst.searchNoResultsSubtitle(query),
      );
    }
    return SearchSuggestionsSection(
      products: results.products,
      categories: results.categories,
      onProductTap: _openProductResult,
      onCategoryTap: _openCategoryResult,
    );
  }
}
