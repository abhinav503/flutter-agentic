import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_price_filter.dart';
import 'package:gravia/enums/product_sort_option.dart';
import 'package:gravia/enums/product_unit_type.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../../home/presentation/widgets/add_to_cart_sheet_content.dart';
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
  void _addToCart(ProductEntity product, int quantity) =>
      showSnackBar(ValueConst.addedToCartMessage(product.name, quantity));

  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  Color _hairlineColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? ColorConst.gray900
      : ColorConst.gray200;

  void _showFilterSheet(String title, Widget content) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairlineColor = _hairlineColor(context);

    showAppBottomSheet(
      title: title,
      titleStyle: TextStyleConst.textLgBold(tt),
      closeLabel: ValueConst.cancel,
      closeLabelStyle: TextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.primary),
      dividerColor: hairlineColor,
      handleColor: hairlineColor,
      child: content,
    );
  }

  void _showAddToCartSheet(ProductEntity product) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairlineColor = _hairlineColor(context);

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

    return CollapsingHeaderSheet(
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
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl6),
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
                        Expanded(child: _productCard(context, products[r])),
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
    );
  }

  Widget _productCard(BuildContext context, ProductEntity product) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ProductCard(
      image: AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover),
      title: product.name,
      titleStyle: TextStyleConst.textMdBold(tt),
      badgeLabel: product.unitType.format(product.unitValue),
      badgeLabelStyle: TextStyleConst.badgeLabel(
        tt,
      ).copyWith(color: cs.primary),
      badgeBackgroundColor: cs.tintedPrimaryFill,
      meta: [
        ProductCardMeta(
          icon: AppSvgImage.asset(
            ImageConst.flash,
            width: 14,
            height: 14,
            color: ColorConst.gray500,
          ),
          label: product.prepTime,
        ),
        ProductCardMeta(
          icon: AppSvgImage.asset(
            ImageConst.badgePercent,
            width: 14,
            height: 14,
            color: ColorConst.gray500,
          ),
          label: '${product.discountPercentage.toStringAsFixed(0)}% OFF',
        ),
      ],
      metaLabelStyle: TextStyleConst.textXsRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      price: '\$${product.price.toStringAsFixed(2)}',
      originalPrice: '\$${product.originalPrice.toStringAsFixed(2)}',
      actionLabel: ValueConst.addToCart,
      actionLabelStyle: TextStyleConst.textSmMedium(
        tt,
      ).copyWith(color: cs.onPrimary),
      onAction: () => _addToCart(product, 1),
      trailingAction: AppIconButton(
        variant: AppIconButtonVariant.glass,
        containerSize: AppSpacing.xl6,
        iconSize: AppSpacing.lg,
        glassHighlightThickness: AppSpacing.xs3,
        glassBlurSigma: AppSpacing.xs4,
        iconBuilder: (color, size) => AppSvgImage.asset(
          ImageConst.bagAdd,
          color: color,
          width: size,
          height: size,
        ),
        onTap: () => _showAddToCartSheet(product),
      ),
      onTap: () => _openProductDetails(product),
    );
  }
}
