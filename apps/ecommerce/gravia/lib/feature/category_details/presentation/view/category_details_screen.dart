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
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_price_filter.dart';
import 'package:gravia/enums/product_sort_option.dart';
import 'package:gravia/feature/cart/domain/entities/cart_item_entity.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/feature/cart/presentation/widgets/cart_status_bar.dart';
import 'package:gravia/widgets/gravia_docked_bar.dart';
import 'package:gravia/widgets/gravia_product_card.dart';
import 'package:gravia/widgets/gravia_sheet.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../bloc/category_details_bloc.dart';
import '../widgets/category_details_hero_header.dart';
import '../widgets/radio_options_sheet_content.dart';

class CategoryDetailsScreen extends BaseScreen {
  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState
    extends BaseScreenState<CategoryDetailsScreen> {
  Future<void> _addToCart(ProductEntity product, int quantity) async {
    context.read<CartCubit>().addToCart(product, quantity);
  }

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _showFilterSheet(String title, Widget content) =>
      showGraviaSheet(title: title, child: content);

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<CategoryDetailsBloc, CategoryDetailsState>(
        listener: (context, state) {
          if (state case CategoryDetailsError(:final message)) {
            showSnackBar(message);
          }
        },
        builder: (context, state) => switch (state) {
          CategoryDetailsLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          CategoryDetailsError(
            :final message,
            :final categoryId,
            :final categoryName,
          ) =>
            SafeArea(
              child: ErrorView(
                message: message,
                onRetry: () => context.read<CategoryDetailsBloc>().add(
                  CategoryDetailsEvent.started(
                    categoryId: categoryId,
                    categoryName: categoryName,
                  ),
                ),
              ),
            ),
          CategoryDetailsLoaded() => _buildLoaded(context, state),
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, CategoryDetailsLoaded state) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final bloc = context.read<CategoryDetailsBloc>();
    final products = state.visibleProducts;

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: 165,
            header: CategoryDetailsHeroHeader(
              categoryName: state.categoryName,
              sort: state.sort,
              priceFilter: state.priceFilter,
              onBack: () => context.pop(),
              onSearchTap: () => context.push(AppRoutes.search),
              onSortTap: () => _showFilterSheet(
                ValueConst.sortBySheetTitle,
                RadioOptionsSheetContent<ProductSortOption>(
                  options: ProductSortOption.values,
                  labelOf: (o) => o.label,
                  selected: state.sort,
                  onSelected: (sort) {
                    bloc.add(CategoryDetailsEvent.sortChanged(sort: sort));
                    context.pop();
                  },
                ),
              ),
              onPriceTap: () => _showFilterSheet(
                ValueConst.priceSheetTitle,
                RadioOptionsSheetContent<ProductPriceFilter>(
                  options: ProductPriceFilter.values,
                  labelOf: (o) => o.label,
                  selected: state.priceFilter,
                  onSelected: (priceFilter) {
                    bloc.add(
                      CategoryDetailsEvent.priceFilterChanged(
                        priceFilter: priceFilter,
                      ),
                    );
                    context.pop();
                  },
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
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xl6,
                        ),
                        child: Text(
                          ValueConst.categoryDetailsEmptyMessage,
                          style: TextStyleConst.textMdRegular(
                            tt,
                          ).copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (var r = 0; r < products.length; r += 2) ...[
                          if (r > 0) const SizedBox(height: AppSpacing.lg),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _productCard(context, products[r]),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: r + 1 < products.length
                                    ? _productCard(context, products[r + 1])
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
        GraviaDockedBar(
          padding: EdgeInsets.only(top: 8),
          child: BlocBuilder<CartCubit, List<CartItemEntity>>(
            builder: (context, items) => items.isEmpty
                ? const SizedBox.shrink()
                : CartStatusBar(
                    itemCount: items.itemCount,
                    grandTotal: items.grandTotal,
                    onTap: () => context.push(AppRoutes.cart),
                    onClear: () => context.read<CartCubit>().clear(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _productCard(BuildContext context, ProductEntity product) =>
      GraviaProductCard(
        product: product,
        // '% OFF' per this screen's denser grid spec (rails use plain '%').
        discountLabel: ValueConst.discountPercentOffLabel(
          product.discountPercentage,
        ),
        onAddToCart: () => _addToCart(product, 1),
        onQuickAdd: () => _showAddToCartSheet(product),
        onTap: () => _openProductDetails(product),
      );
}
