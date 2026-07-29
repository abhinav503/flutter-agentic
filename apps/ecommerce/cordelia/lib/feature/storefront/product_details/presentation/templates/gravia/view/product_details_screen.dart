import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/cart/presentation/quantity_selection.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_dimen_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_product_card.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_sheet.dart';
import 'package:cordelia/templates/gravia/widgets/selector_chip.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_hero_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/ui/atoms/app_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/ecommerce/product_meta_row.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../../domain/entities/product_detail_entity.dart';
import '../../../bloc/product_details_bloc.dart';
import '../../../product_details_actions.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_detail_image_carousel.dart';
import '../widgets/product_detail_key_info.dart';
import '../widgets/product_detail_similar_products.dart';
import '../widgets/product_details_skeleton_body.dart';

class ProductDetailsScreen extends BaseScreen {
  final String storeId;

  const ProductDetailsScreen({super.key, required this.storeId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends BaseScreenState<ProductDetailsScreen>
    with QuantitySelection, ProductDetailsActions {
  int _selectedSizeIndex = 0;

  @override
  String get storeId => widget.storeId;

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: addToCart);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.lightStatusIcons;

  @override
  Widget body(BuildContext context) {
    // The header canvas is coloured (like Home/Search), so status bar icons
    // need to stay light for contrast — same override as HomeScreen.
    return BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
        if (state case ProductDetailsError(:final message)) {
          showSnackBar(message);
        }
      },
      builder: (context, state) => AppSwitcher(
        child: switch (state) {
          ProductDetailsLoading() => CollapsingHeaderSheet(
            key: const ValueKey('loading'),
            initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
            header: GraviaHeroHeader(
              title: GraviaValueConst.productDetailsTitle,
              onBack: () => context.pop(),
              trailing: GraviaGlassIconButton(
                asset: GraviaImageConst.navFavourite,
                onTap: () {},
              ),
            ),
            body: const ProductDetailsSkeletonBody(),
          ),
          ProductDetailsError(
            :final message,
            :final storeId,
            :final productId,
          ) => SafeArea(
            key: const ValueKey('error'),
            child: ErrorView(
              message: message,
              onRetry: () =>
                  retryLoad(storeId: storeId, productId: productId),
            ),
          ),
          ProductDetailsLoaded(:final detail) => KeyedSubtree(
            key: const ValueKey('loaded'),
            child: _buildLoaded(context, detail),
          ),
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ProductDetailEntity detail) {
    final product = detail.product;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isFavourite =
        context.watch<FavouritesCubit>().isFavourite(product.id);
    // Same divider colour as the bottom nav bar's top border (ShellPage uses
    // AppColorsExtension.dockedHairline for both its top and bottom borders)
    // — so the hairlines in this screen match the bar rather than the
    // generic Gray/200 hairline.
    final hairlineColor =
        context.appColors.dockedHairline;

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: GraviaDimenConst.headerHeightRegular,
            // Header controls match SearchHeroHeader's back button exactly
            // (same GraviaGlassIconButton size + canvas padding) so the glass
            // circle sits in the identical spot on both screens — the
            // productDetails route fades rather than slides in (app.dart),
            // and a size/position mismatch would make that crossfade "jump."
            header: GraviaHeroHeader(
              title: GraviaValueConst.productDetailsTitle,
              onBack: () => context.pop(),
              trailing: GraviaGlassIconButton(
                asset: isFavourite
                    ? GraviaImageConst.favouriteFilled
                    : GraviaImageConst.navFavourite,
                onTap: () =>
                    context.read<FavouritesCubit>().toggle(product),
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
                    style: GraviaTextStyleConst.textLgBold(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  ProductMetaRow(
                    meta: [
                      ProductCardMeta(
                        icon: GraviaProductCard.metaIcon(GraviaImageConst.flash),
                        label: product.prepTime,
                      ),
                      ProductCardMeta(
                        icon: GraviaProductCard.metaIcon(
                          GraviaImageConst.badgePercent,
                        ),
                        label: GraviaValueConst.discountPercentOffLabel(
                          product.discountPercentage,
                        ),
                      ),
                    ],
                    labelStyle: GraviaTextStyleConst.textXsRegular(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        GraviaValueConst.formattedPrice(product.price),
                        style: GraviaTextStyleConst.textLgBold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(width: AppSpacing.xs2),
                      Text(
                        GraviaValueConst.formattedPrice(product.originalPrice),
                        style: GraviaTextStyleConst.textSmRegular(tt).copyWith(
                          color: cs.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  // "Select QTY" only renders when the product actually has
                  // package sizes (admin-driven) — an empty list means no size
                  // picker, not an orphaned heading between two dividers.
                  if (detail.sizeOptions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl2),
                    Divider(color: hairlineColor, height: 1, thickness: 1),
                    const SizedBox(height: AppSpacing.xl2),
                    Text(
                      GraviaValueConst.selectQtyLabel,
                      style: GraviaTextStyleConst.textLgBold(
                        tt,
                      ).copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      children: [
                        for (var i = 0; i < detail.sizeOptions.length; i++) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.base),
                          SelectorChip(
                            label: product.unitType.format(
                              detail.sizeOptions[i],
                            ),
                            selected: i == _selectedSizeIndex,
                            onTap: () => setState(() => _selectedSizeIndex = i),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl2),
                  Divider(color: hairlineColor, height: 1, thickness: 1),
                  const SizedBox(height: AppSpacing.xl2),
                  ProductDetailKeyInfo(description: detail.description),
                  const SizedBox(height: AppSpacing.xl2),
                  ProductDetailSimilarProducts(
                    products: detail.similarProducts,
                    onAddToCart: addToCart,
                    onQuickAdd: _showAddToCartSheet,
                    onProductTap: openProductDetails,
                  ),
                ],
              ),
            ),
          ),
        ),
        ProductDetailBottomBar(
          storeId: widget.storeId,
          quantity: quantity,
          unitPrice: product.price,
          onIncrement: incrementQuantity,
          onDecrement: decrementQuantity,
          onAddToCart: () {
            addToCart(product, quantity);
            resetQuantity();
          },
        ),
      ],
    );
  }
}
