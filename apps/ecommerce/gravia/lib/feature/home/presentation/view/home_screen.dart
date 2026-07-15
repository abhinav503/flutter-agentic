import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/add_to_cart_sheet_content.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/home_popular_items_section.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  void _addToCart(ProductEntity product, int quantity) =>
      showSnackBar(ValueConst.addedToCartMessage(product.name, quantity));

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _openCategoryDetails(CategoryEntity category) => context.push(
    AppRoutes.categoryDetailsPath(category.id, category.name),
  );

  void _showAddToCartSheet(ProductEntity product) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    // Neither outlineVariant nor onSurfaceVariant lands on the kit's exact
    // hairline/handle shade in both modes, so it's an explicit override —
    // Gray/200 light, Light/900 dark.
    final hairlineColor = Theme.of(context).brightness == Brightness.dark
        ? ColorConst.gray900
        : ColorConst.gray200;

    showAppBottomSheet(
      title: ValueConst.addToCartSheetTitle,
      titleStyle: TextStyleConst.textLgBold(tt),
      closeLabel: ValueConst.cancel,
      closeLabelStyle: TextStyleConst.textSmRegular(tt).copyWith(color: cs.primary),
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state case HomeError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          HomeLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          HomeError() => SafeArea(
            child: ErrorView(
              message: ValueConst.homeLoadErrorMessage,
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeEvent.started()),
            ),
          ),
          HomeLoaded(:final home) => _HomeContent(
            home: home,
            onAddToCart: _addToCart,
            onQuickAdd: _showAddToCartSheet,
            onFavouriteToggle: (id) => context.read<HomeBloc>().add(
              HomeEvent.favouriteToggled(productId: id),
            ),
            onProductTap: _openProductDetails,
            onCategoryTap: _openCategoryDetails,
            onComingSoon: () => showSnackBar(ValueConst.comingSoonMessage),
            onSearchTap: () => context.push(AppRoutes.search),
          ),
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeEntity home;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<String> onFavouriteToggle;
  final ValueChanged<ProductEntity> onProductTap;
  final VoidCallback onComingSoon;
  final VoidCallback onSearchTap;
  final ValueChanged<CategoryEntity> onCategoryTap;

  const _HomeContent({
    required this.home,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onFavouriteToggle,
    required this.onProductTap,
    required this.onComingSoon,
    required this.onSearchTap,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) => CollapsingHeaderSheet(
    header: HomeHeroHeader(
      onNotificationTap: onComingSoon,
      onSearchTap: onSearchTap,
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl4),
      child: Column(
        children: [
          HomeCategorySection(
            categories: home.categories,
            onComingSoon: onComingSoon,
            onCategoryTap: onCategoryTap,
          ),
          const SizedBox(height: AppSpacing.xl4),
          HomePopularItemsSection(
            products: home.popularProducts,
            onAddToCart: onAddToCart,
            onQuickAdd: onQuickAdd,
            onFavouriteToggle: onFavouriteToggle,
            onProductTap: onProductTap,
            onComingSoon: onComingSoon,
          ),
        ],
      ),
    ),
  );
}
