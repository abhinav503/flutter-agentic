import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/constants/value_const.dart';
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

import 'package:core/core/extensions/num_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:cordelia/templates/gravia/widgets/gravia_switcher.dart';
import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/collapsing_header_sheet.dart';
import 'package:core/core/ui/blocks/ecommerce/product_meta_row.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import '../../../../../home/domain/entities/product_entity.dart';
import '../../../../../reviews/domain/entities/product_reviews_entity.dart';
import '../../../../../reviews/domain/entities/review_entity.dart';
import '../../../../../reviews/presentation/bloc/product_reviews_bloc.dart';
import '../../../../../reviews/presentation/product_reviews_actions.dart';
import '../../../../../reviews/presentation/templates/gravia/widgets/product_reviews_section.dart';
import '../../../../../reviews/presentation/templates/gravia/widgets/write_review_sheet_content.dart';
import '../../../../../reviews/presentation/templates/gravia/widgets/report_review_sheet_content.dart';
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
    with QuantitySelection, ProductDetailsActions, ProductReviewsActions {
  @override
  String get storeId => widget.storeId;

  void _showAddToCartSheet(ProductEntity product) =>
      showGraviaAddToCartSheet(product: product, onAddToCart: addToCart);

  @override
  Future<void> showWriteReviewSheet(ReviewEntity? existing) =>
      showGraviaSheet<void>(
        title: ValueConst.reviewSheetTitle,
        child: GraviaWriteReviewSheetContent(
          initialRating: existing?.rating ?? 0,
          initialText: existing?.text ?? '',
          onSubmit: submitReview,
        ),
      );

  @override
  Future<void> showReportReviewSheet(ReviewEntity review) =>
      showGraviaSheet<void>(
        title: ValueConst.reportReviewSheetTitle,
        child: GraviaReportReviewSheetContent(
          onSubmit: (reason, block) => submitReport(review.uid, reason, block),
        ),
      );

  @override
  Future<void> showDeleteReviewSheet({required VoidCallback onConfirm}) =>
      showGraviaConfirmSheet(
        context: context,
        title: ValueConst.reviewDeleteConfirmTitle,
        message: ValueConst.reviewDeleteConfirmMessage,
        confirmLabel: ValueConst.deleteReviewLabel,
        onConfirm: onConfirm,
      );

  /// The Ratings & Reviews block. Its own builder rather than part of the
  /// details switch: a write repaints only this section, leaving the hero,
  /// price and size chips untouched.
  Widget _reviewsSection() =>
      BlocBuilder<ProductReviewsBloc, ProductReviewsState>(
        builder: (context, state) {
          final reviews = state.reviewsOrNull;
          // Only before the seed lands (and while a refresh re-reads) — a
          // skeleton in the section's own shape, never a spinner.
          if (reviews == null) return const ShimmerListRow(itemCount: 2);

          return GraviaProductReviewsSection(
            reviews: reviews,
            currentUid: currentUid,
            // Null while a write is in flight: the CTA stops accepting taps
            // instead of stacking a second submit on the first.
            onWriteReview: state.isSubmitting
                ? null
                : () => writeReview(reviews.mine(currentUid)),
            onDeleteReview: state.isSubmitting ? null : confirmDeleteReview,
            onReportReview: state.isSubmitting ? null : reportReview,
          );
        },
      );

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
        // Hands the reviews section the page it already loaded, instead of
        // it fetching the same first page again.
        if (state case ProductDetailsLoaded(:final detail)) {
          seedReviews(detail.reviews);
        }
      },
      builder: (context, state) => GraviaSwitcher(
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
          ) =>
            SafeArea(
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
    // Everything priced on this screen follows the selected size — the price
    // row, the discount meta chip, and the bottom bar all read the variant,
    // so a chip tap can't leave any of them showing the base pack's numbers.
    final variant = selectedVariant(detail);
    final unitPrice = variant?.price ?? product.price;
    final originalUnitPrice = variant?.originalPrice ?? product.originalPrice;
    final discountPercentage =
        variant?.discountPercentage ?? product.discountPercentage;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isFavourite = context.watch<FavouritesCubit>().isFavourite(
      product.id,
    );
    // Same divider colour as the bottom nav bar's top border (ShellPage uses
    // AppColorsExtension.dockedHairline for both its top and bottom borders)
    // — so the hairlines in this screen match the bar rather than the
    // generic Gray/200 hairline.
    final hairlineColor = context.appColors.dockedHairline;

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
                onTap: () => context.toggleFavouriteOrSignIn(product),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailImageCarousel(images: detail.images),
                  const SizedBox(height: AppSpacing.base),
                  // Kit deviation (recorded in the spec sheet): the Gravia kit
                  // predates brands, so the brand line borrows the meta row's
                  // muted supporting-text role above the name.
                  if (detail.brand != null) ...[
                    Text(
                      detail.brand!.name,
                      style: GraviaTextStyleConst.textXsRegular(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xs2),
                  ],
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
                        icon: GraviaProductCard.metaIcon(
                          GraviaImageConst.flash,
                        ),
                        label: product.prepTime,
                      ),
                      ProductCardMeta(
                        icon: GraviaProductCard.metaIcon(
                          GraviaImageConst.badgePercent,
                        ),
                        label: GraviaValueConst.discountPercentOffLabel(
                          discountPercentage,
                        ),
                      ),
                      // Third here, unlike the card's two: the details page
                      // has the full width to spend, so running low is added
                      // to the row rather than taking the discount's place.
                      if (product.isLowStock)
                        ProductCardMeta(
                          icon: GraviaProductCard.metaIcon(
                            GraviaImageConst.flash,
                          ),
                          label: ValueConst.onlyNLeftLabel(product.stock!),
                          labelColor: cs.error,
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
                        unitPrice.asPrice,
                        style: GraviaTextStyleConst.textLgBold(
                          tt,
                        ).copyWith(color: cs.onSurface),
                      ),
                      const SizedBox(width: AppSpacing.xs2),
                      Text(
                        originalUnitPrice.asPrice,
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
                  if (detail.sizeVariants.isNotEmpty) ...[
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
                        for (
                          var i = 0;
                          i < detail.sizeVariants.length;
                          i++
                        ) ...[
                          if (i > 0) const SizedBox(width: AppSpacing.base),
                          SelectorChip(
                            label: product.unitType.format(
                              detail.sizeVariants[i].value,
                            ),
                            selected: i == effectiveSizeIndex(detail),
                            onTap: () => selectSize(i),
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
                  Divider(color: hairlineColor, height: 1, thickness: 1),
                  const SizedBox(height: AppSpacing.xl2),
                  _reviewsSection(),
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
          unitPrice: unitPrice,
          onIncrement: incrementQuantityUpTo(product.purchaseLimit),
          onDecrement: decrementQuantity,
          soldOut: product.isOutOfStock,
          onAddToCart: () {
            addSelectedToCart(detail, quantity);
            resetQuantity();
          },
        ),
      ],
    );
  }
}
