import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/ecommerce/product_meta_row.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/cart/presentation/cubit/cart_cubit.dart';
import 'package:gravia/feature/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_hero_header.dart';
import 'package:gravia/widgets/gravia_product_card.dart';
import 'package:gravia/widgets/gravia_sheet.dart';
import 'package:gravia/widgets/selector_chip.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../bloc/product_details_bloc.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_detail_image_carousel.dart';
import '../widgets/product_detail_key_info.dart';
import '../widgets/product_detail_similar_products.dart';
import '../widgets/product_details_skeleton_body.dart';

class ProductDetailsScreen extends BaseScreen {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends BaseScreenState<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedSizeIndex = 0;

  void _addToCart(ProductEntity product, int quantity) {
    context.read<CartCubit>().addToCart(product, quantity);
  }

  // Pushes a new copy of this same route for the tapped similar product —
  // each detail screen owns its own quantity/size selection, so a fresh
  // route (not a replace) is the correct navigation, same as any other
  // "product card in a list -> its own detail page" flow in this app.
  void _openProductDetails(ProductEntity product) =>
      context.push(AppRoutes.productDetailsPath(product.id));

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: _addToCart);

  @override
  Widget body(BuildContext context) {
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
          if (state case ProductDetailsError(:final message)) {
            showSnackBar(message);
          }
        },
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (state) {
            ProductDetailsLoading() => CollapsingHeaderSheet(
              key: const ValueKey('loading'),
              initialHeaderHeight: 130,
              header: GraviaHeroHeader(
                title: ValueConst.productDetailsTitle,
                onBack: () => context.pop(),
                trailing: GraviaGlassIconButton(
                  asset: ImageConst.navFavourite,
                  onTap: () {},
                ),
              ),
              body: const ProductDetailsSkeletonBody(),
            ),
            ProductDetailsError(:final message, :final productId) => SafeArea(
              key: const ValueKey('error'),
              child: ErrorView(
                message: message,
                onRetry: () => context.read<ProductDetailsBloc>().add(
                  ProductDetailsEvent.started(productId: productId),
                ),
              ),
            ),
            ProductDetailsLoaded(:final detail) => KeyedSubtree(
              key: const ValueKey('loaded'),
              child: _buildLoaded(context, detail),
            ),
          },
        ),
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, ProductDetailEntity detail) {
    final product = detail.product;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final favourites = context.watch<FavouritesCubit>().state.items;
    final isFavourite = favourites.any((p) => p.id == product.id);
    // Same divider colour as the bottom nav bar's top border (ShellPage uses
    // AppColorsExtension.dockedHairline for both its top and bottom borders)
    // — so the hairlines in this screen match the bar rather than the
    // generic Gray/200 hairline.
    final hairlineColor =
        Theme.of(context).extension<AppColorsExtension>()!.dockedHairline;

    return Column(
      children: [
        Expanded(
          child: CollapsingHeaderSheet(
            initialHeaderHeight: 130,
            // Header controls match SearchHeroHeader's back button exactly
            // (same GraviaGlassIconButton size + canvas padding) so the glass
            // circle sits in the identical spot on both screens — the
            // productDetails route fades rather than slides in (app.dart),
            // and a size/position mismatch would make that crossfade "jump."
            header: GraviaHeroHeader(
              title: ValueConst.productDetailsTitle,
              onBack: () => context.pop(),
              trailing: GraviaGlassIconButton(
                asset: isFavourite
                    ? ImageConst.favouriteFilled
                    : ImageConst.navFavourite,
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
                    style: TextStyleConst.textLgBold(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  ProductMetaRow(
                    meta: [
                      ProductCardMeta(
                        icon: GraviaProductCard.metaIcon(ImageConst.flash),
                        label: product.prepTime,
                      ),
                      ProductCardMeta(
                        icon: GraviaProductCard.metaIcon(
                          ImageConst.badgePercent,
                        ),
                        label: ValueConst.discountPercentOffLabel(
                          product.discountPercentage,
                        ),
                      ),
                    ],
                    labelStyle: TextStyleConst.textXsRegular(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        ValueConst.formattedPrice(product.price),
                        style: TextStyleConst.textLgBold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(width: AppSpacing.xs2),
                      Text(
                        ValueConst.formattedPrice(product.originalPrice),
                        style: TextStyleConst.textSmRegular(tt).copyWith(
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
                      ValueConst.selectQtyLabel,
                      style: TextStyleConst.textLgBold(
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
