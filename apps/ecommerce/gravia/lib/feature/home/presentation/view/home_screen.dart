import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/address/presentation/view/address_page.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/feature/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:gravia/feature/shell/presentation/view/shell_page.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_category_section.dart';
import '../widgets/home_hero_header.dart';
import '../widgets/home_popular_items_section.dart';
import '../widgets/home_skeleton_body.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  // Not BLoC-derived — a direct local-storage read, same "screen-local via
  // setState" carve-out architecture.md documents for ShellPage's tab index.
  // No addresses ever saved -> the key is missing -> the null fallback below.
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

  Future<void> _openSelectAddress() async {
    await context.push(AppRoutes.selectAddress);
    if (!mounted) return;
    setState(_loadSelectedAddress);
  }

  void _addToCart(ProductEntity product, int quantity) {
    context.read<CartCubit>().addToCart(product, quantity);
  }

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _openCategoryDetails(CategoryEntity category) =>
      context.push(AppRoutes.categoryDetailsPath(category.id, category.name));

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  Widget body(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state case HomeError(:final message)) showSnackBar(message);
          // Warm-start background refresh failed — cached content is still
          // showing, so this is a toast, not an error view.
          if (state case HomeLoaded(refreshFailed: true)) {
            showSnackBar(ValueConst.homeRefreshFailedMessage);
          }
        },
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state) {
            HomeLoading() => CollapsingHeaderSheet(
              key: const ValueKey('loading'),
              header: HomeHeroHeader(
                addressLabel:
                    _selectedAddressLabel ?? ValueConst.noLocationSelectedLabel,
                onLocationTap: _openSelectAddress,
                onNotificationTap: () => context.push(AppRoutes.notifications),
                onSearchTap: () => context.push(AppRoutes.search),
              ),
              body: const HomeSkeletonBody(),
            ),
            HomeError() => SafeArea(
              key: const ValueKey('error'),
              child: ErrorView(
                message: ValueConst.homeLoadErrorMessage,
                onRetry: () =>
                    context.read<HomeBloc>().add(const HomeEvent.started()),
              ),
            ),
            HomeLoaded(:final home) => _HomeContent(
              key: const ValueKey('loaded'),
              home: home,
              addressLabel:
                  _selectedAddressLabel ?? ValueConst.noLocationSelectedLabel,
              onLocationTap: _openSelectAddress,
              onAddToCart: _addToCart,
              onQuickAdd: _showAddToCartSheet,
              onFavouriteToggle: (product) =>
                  context.read<FavouritesCubit>().toggle(product),
              onProductTap: _openProductDetails,
              onCategoryTap: _openCategoryDetails,
              onSeeAllCategories: () =>
                  context.go(AppRoutes.home, extra: ShellPage.categoriesTabIndex),
              onNotificationTap: () => context.push(AppRoutes.notifications),
              onSearchTap: () => context.push(AppRoutes.search),
            ),
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeEntity home;
  final String addressLabel;
  final VoidCallback onLocationTap;
  final void Function(ProductEntity product, int quantity) onAddToCart;
  final ValueChanged<ProductEntity> onQuickAdd;
  final ValueChanged<ProductEntity> onFavouriteToggle;
  final ValueChanged<ProductEntity> onProductTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onSearchTap;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final VoidCallback onSeeAllCategories;

  const _HomeContent({
    super.key,
    required this.home,
    required this.addressLabel,
    required this.onLocationTap,
    required this.onAddToCart,
    required this.onQuickAdd,
    required this.onFavouriteToggle,
    required this.onProductTap,
    required this.onNotificationTap,
    required this.onSearchTap,
    required this.onCategoryTap,
    required this.onSeeAllCategories,
  });

  @override
  Widget build(BuildContext context) => CollapsingHeaderSheet(
    header: HomeHeroHeader(
      addressLabel: addressLabel,
      onLocationTap: onLocationTap,
      onNotificationTap: onNotificationTap,
      onSearchTap: onSearchTap,
    ),
    body: Padding(
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
    ),
  );
}
