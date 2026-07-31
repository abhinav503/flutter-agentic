import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/product_price_filter.dart';
import 'package:cordelia/enums/product_sort_option.dart';
import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';
import 'package:cordelia/feature/storefront/cart/presentation/cubit/cart_cubit.dart';
import 'package:cordelia/feature/storefront/cart/presentation/templates/gravia/widgets/cart_status_bar.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_grid.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_grid_skeleton.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/radio_options_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/molecules/empty_state.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:core/core/ui/blocks/docked_bar.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../bloc/category_details_bloc.dart';
import '../widgets/category_details_hero_header.dart';

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
    context.read<CartCubit>().addToCart(product, quantity);
  }

  void _openProductDetails(ProductEntity product) => context.push(
    AppRoutes.productDetailsPath(product.id),
    extra: widget.storeId,
  );

  void _showFilterSheet(String title, Widget content) =>
      showGraviaSheet(title: title, child: content);

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    return BlocConsumer<CategoryDetailsBloc, CategoryDetailsState>(
      listener: (context, state) {
        if (state case CategoryDetailsError(:final message)) {
          showSnackBar(message);
        }
      },
      builder: (context, state) => AppSwitcher(
        child: switch (state) {
          CategoryDetailsLoading() => CollapsingHeaderSheet(
            key: const ValueKey('loading'),
            initialHeaderHeight: GraviaDimenConst.headerHeightChips,
            header: CategoryDetailsHeroHeader(
              categoryName: widget.categoryName,
              sort: ProductSortOption.relevance,
              priceFilter: ProductPriceFilter.all,
              onBack: () => context.pop(),
              onSearchTap: () =>
                  context.push(AppRoutes.search, extra: widget.storeId),
              onSortTap: () {},
              onPriceTap: () {},
            ),
            body: const GraviaProductGridSkeleton(
              padding: EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.xl4,
                bottom: AppSpacing.xl14,
              ),
            ),
          ),
          CategoryDetailsError(
            :final message,
            :final storeId,
            :final categoryId,
            :final categoryName,
          ) =>
            SafeArea(
              key: const ValueKey('error'),
              child: ErrorView(
                message: message,
                onRetry: () => context.read<CategoryDetailsBloc>().add(
                  CategoryDetailsEvent.started(
                    storeId: storeId,
                    categoryId: categoryId,
                    categoryName: categoryName,
                  ),
                ),
              ),
            ),
          CategoryDetailsLoaded() => KeyedSubtree(
            key: const ValueKey('loaded'),
            child: _buildLoaded(context, state),
          ),
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, CategoryDetailsLoaded state) {
    final bloc = context.read<CategoryDetailsBloc>();
    final products = state.visibleProducts;

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: GraviaDimenConst.headerHeightChips,
            header: CategoryDetailsHeroHeader(
              categoryName: state.categoryName,
              sort: state.sort,
              priceFilter: state.priceFilter,
              onBack: () => context.pop(),
              onSearchTap: () =>
                  context.push(AppRoutes.search, extra: widget.storeId),
              onSortTap: () => _showFilterSheet(
                GraviaValueConst.sortBySheetTitle,
                RadioOptionsSheetContent<ProductSortOption>(
                  options: ProductSortOption.values,
                  labelOf: (o) => o.label,
                  selected: state.sort,
                  onSelected: (sort) =>
                      bloc.add(CategoryDetailsEvent.sortChanged(sort: sort)),
                ),
              ),
              onPriceTap: () => _showFilterSheet(
                GraviaValueConst.priceSheetTitle,
                RadioOptionsSheetContent<ProductPriceFilter>(
                  options: ProductPriceFilter.values,
                  labelOf: (o) => o.label,
                  selected: state.priceFilter,
                  onSelected: (priceFilter) => bloc.add(
                    CategoryDetailsEvent.priceFilterChanged(
                      priceFilter: priceFilter,
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                top: AppSpacing.xl4,
                bottom: AppSpacing.xl14,
              ),
              child: products.isEmpty
                  ? const EmptyState(
                      iconData: Icons.filter_alt_off_outlined,
                      title: GraviaValueConst.categoryDetailsEmptyMessage,
                    )
                  : GraviaProductGrid(
                      products: products,
                      onAddToCart: _addToCart,
                      onQuickAdd: _showAddToCartSheet,
                      onProductTap: _openProductDetails,
                    ),
            ),
          ),
        ),
        DockedBar(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: BlocBuilder<CartCubit, List<CartItemEntity>>(
            builder: (context, items) => items.isEmpty
                ? const SizedBox.shrink()
                : CartStatusBar(
                    itemCount: items.itemCount,
                    grandTotal: items.grandTotal,
                    onTap: () =>
                        context.push(AppRoutes.cart, extra: widget.storeId),
                    onClear: () => context.read<CartCubit>().clear(),
                  ),
          ),
        ),
      ],
    );
  }
}
