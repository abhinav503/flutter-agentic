import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/loading_indicator.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/ecommerce/product_meta_row.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/widgets/selector_chip.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../../home/presentation/widgets/add_to_cart_sheet_content.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../bloc/product_details_bloc.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_detail_hero_header.dart';
import '../widgets/product_detail_image_carousel.dart';
import '../widgets/product_detail_key_info.dart';
import '../widgets/product_detail_similar_products.dart';

class ProductDetailsScreen extends BaseScreen {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends BaseScreenState<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedSizeIndex = 0;

  void _addToCart(ProductEntity product, int quantity) =>
      showSnackBar(ValueConst.addedToCartMessage(product.name, quantity));

  // Pushes a new copy of this same route for the tapped similar product —
  // each detail screen owns its own quantity/size selection, so a fresh
  // route (not a replace) is the correct navigation, same as any other
  // "product card in a list -> its own detail page" flow in this app.
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

    // The header canvas is coloured (like Home/Search), so status bar icons
    // need to stay light for contrast — same override as HomeScreen.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        listener: (context, state) {
          if (state case ProductDetailsError(:final message)) showSnackBar(message);
        },
        builder: (context, state) => switch (state) {
          ProductDetailsLoading() => Container(
            color: cs.primary,
            child: const SafeArea(child: Center(child: LoadingIndicator())),
          ),
          ProductDetailsError(:final message, :final productId) => SafeArea(
            child: ErrorView(
              message: message,
              onRetry: () => context.read<ProductDetailsBloc>().add(
                ProductDetailsEvent.started(productId: productId),
              ),
            ),
          ),
          ProductDetailsLoaded(:final detail) => _buildLoaded(context, detail),
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ProductDetailEntity detail) {
    final product = detail.product;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Same divider colour as the bottom nav bar's top border (ShellPage's
    // _dividerColor) — Gray/500 in light, white in dark — so the hairlines
    // in this screen match the bar rather than the generic Gray/200 hairline.
    final hairlineColor = isDark ? ColorConst.gray900 : ColorConst.gray500;

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: 130,
            header: ProductDetailHeroHeader(
              isFavourite: product.isFavourite,
              onBack: () => context.pop(),
              onFavouriteTap: () => context.read<ProductDetailsBloc>().add(
                const ProductDetailsEvent.favouriteToggled(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailImageCarousel(images: detail.images),
                  const SizedBox(height: AppSpacing.base),
                  Text(
                    product.name,
                    style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  ProductMetaRow(
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
                    labelStyle: TextStyleConst.textXsRegular(tt).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(width: AppSpacing.xs2),
                      Text(
                        '\$${product.originalPrice.toStringAsFixed(2)}',
                        style: TextStyleConst.textSmRegular(tt).copyWith(
                          color: cs.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  Divider(color: hairlineColor, height: 1, thickness: 1),
                  const SizedBox(height: AppSpacing.xl2),
                  Text(
                    ValueConst.selectQtyLabel,
                    style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Row(
                    children: [
                      for (var i = 0; i < detail.sizeOptions.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.base),
                        SelectorChip(
                          label: product.unitType.format(detail.sizeOptions[i]),
                          selected: i == _selectedSizeIndex,
                          onTap: () => setState(() => _selectedSizeIndex = i),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  Divider(color: hairlineColor, height: 1, thickness: 1),
                  const SizedBox(height: AppSpacing.xl2),
                  ProductDetailKeyInfo(description: detail.description),
                  const SizedBox(height: AppSpacing.xl2),
                  ProductDetailSimilarProducts(
                    products: detail.similarProducts,
                    onAddToCart: _addToCart,
                    onQuickAdd: _showAddToCartSheet,
                    onProductTap: _openProductDetails,
                  ),
                ],
              ),
            ),
          ),
        ),
        ProductDetailBottomBar(
          quantity: _quantity,
          unitPrice: product.price,
          onIncrement: () => setState(() => _quantity++),
          onDecrement: _quantity > 1 ? () => setState(() => _quantity--) : null,
          onAddToCart: () {
            _addToCart(product, _quantity);
            setState(() => _quantity = 1);
          },
        ),
      ],
    );
  }
}
