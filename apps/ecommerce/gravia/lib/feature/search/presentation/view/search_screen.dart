import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

// Cross-feature reuse, not duplication — Search's "Popular Items" is the
// same composition and product data shape as Home's.
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/presentation/widgets/add_to_cart_sheet_content.dart';
import '../../../home/presentation/widgets/home_popular_items_section.dart';
import '../bloc/search_bloc.dart';
import '../widgets/recent_search_section.dart';
import '../widgets/search_hero_header.dart';

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

  void _showAddToCartSheet(ProductEntity product) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairlineColor = Theme.of(context).brightness == Brightness.dark
        ? ColorConst.gray900
        : ColorConst.gray200;

    showAppBottomSheet(
      title: ValueConst.addToCartSheetTitle,
      titleStyle: TextStyleConst.textLgBold(tt),
      closeLabel: ValueConst.cancel,
      closeLabelStyle: TextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.primary),
      dividerColor: hairlineColor,
      handleColor: hairlineColor,
      child: AddToCartSheetContent(
        product: product,
        onAddToCart: (quantity) => _addToCart(product, quantity),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state case SearchError(:final message)) showSnackBar(message);
      },
      builder: (context, state) => switch (state) {
        SearchLoading() => Container(
          color: cs.primary,
          child: const SafeArea(child: Center(child: LoadingIndicator())),
        ),
        SearchError() => SafeArea(
          child: ErrorView(
            message: ValueConst.searchLoadErrorMessage,
            onRetry: () =>
                context.read<SearchBloc>().add(const SearchEvent.started()),
          ),
        ),
        SearchLoaded(:final search) => CollapsingHeaderSheet(
          initialHeaderHeight: 120,
          header: SearchHeroHeader(
            controller: _searchController,
            focusNode: _searchFocus,
            onBack: _goBack,
            onSubmitted: (_) {},
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
            child: Column(
              children: [
                RecentSearchSection(
                  products: search.recentSearches,
                  onProductTap: _openProductDetails,
                  onRemove: (productId) => context.read<SearchBloc>().add(
                    SearchEvent.recentSearchRemoved(productId: productId),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl4),
                HomePopularItemsSection(
                  products: search.popularProducts,
               
                  onAddToCart: _addToCart,
                  onQuickAdd: _showAddToCartSheet,
                  onFavouriteToggle: (_) {},
                  onProductTap: _openProductDetails,
                  onComingSoon: () =>
                      showSnackBar(ValueConst.comingSoonMessage),
                ),
              ],
            ),
          ),
        ),
      },
    );
  }
}
