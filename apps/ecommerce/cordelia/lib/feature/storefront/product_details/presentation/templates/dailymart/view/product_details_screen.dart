import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/molecules/error_view.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/cart/presentation/quantity_selection.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_filter_chip.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_grid.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_quantity_stepper.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_sheet.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';
import 'package:cordelia/feature/storefront/home/presentation/product_rating_label.dart';

import '../../../../../reviews/domain/entities/product_reviews_entity.dart';
import '../../../../../reviews/domain/entities/review_entity.dart';
import '../../../../../reviews/presentation/bloc/product_reviews_bloc.dart';
import '../../../../../reviews/presentation/product_reviews_actions.dart';
import '../../../../../reviews/presentation/templates/dailymart/widgets/product_reviews_section.dart';
import '../../../../../reviews/presentation/templates/dailymart/widgets/write_review_sheet_content.dart';
import '../../../../../reviews/presentation/templates/dailymart/widgets/report_review_sheet_content.dart';
import '../../../../domain/entities/product_detail_entity.dart';
import '../../../../domain/entities/size_variant_entity.dart';
import '../../../bloc/product_details_bloc.dart';
import '../../../product_details_actions.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_detail_skeleton_body.dart';

/// `dailymart` template's Product Details — kit frames `22`/`23`: header
/// row, one hero image well, name beside a bordered rating pill, price with
/// the bare green stepper, Descriptions/Reviews underline tabs (Reviews
/// renders the store's real reviews — see [DailyMartProductReviewsSection]),
/// a
/// Related Products grid, and the floating cart-disc + Add To Cart row over
/// a bottom fade.
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

  @override
  Future<void> showWriteReviewSheet(ReviewEntity? existing) =>
      showDailyMartSheet<void>(
        title: ValueConst.reviewSheetTitle,
        child: DailyMartWriteReviewSheetContent(
          initialRating: existing?.rating ?? 0,
          initialText: existing?.text ?? '',
          onSubmit: submitReview,
        ),
      );

  @override
  Future<void> showReportReviewSheet(ReviewEntity review) =>
      showDailyMartSheet<void>(
        title: ValueConst.reportReviewSheetTitle,
        child: DailyMartReportReviewSheetContent(
          onSubmit: (reason, block) => submitReport(review.uid, reason, block),
        ),
      );

  @override
  Future<void> showDeleteReviewSheet({required VoidCallback onConfirm}) =>
      showDailyMartConfirmSheet(
        context: context,
        title: ValueConst.reviewDeleteConfirmTitle,
        message: ValueConst.reviewDeleteConfirmMessage,
        confirmLabel: ValueConst.deleteReviewLabel,
        onConfirm: onConfirm,
      );

  /// UI-local, like a tab index — which of the two content tabs shows.
  bool _showReviews = false;

  void _addToCart(ProductEntity product, int quantity) {
    addToCart(product, quantity);
    showSnackBar(
      DailyMartValueConst.addedToCartMessage(product.name, quantity),
    );
  }

  /// The Reviews tab's body. Its own builder rather than part of the
  /// details switch: a write re-renders only this subtree, leaving the hero,
  /// price and stepper untouched.
  Widget _reviewsTab() => BlocBuilder<ProductReviewsBloc, ProductReviewsState>(
    builder: (context, state) {
      final reviews = state.reviewsOrNull;
      // Only before the seed lands (and while a refresh re-reads) — a
      // skeleton in the section's own shape, never a spinner.
      if (reviews == null) return const ShimmerListRow(itemCount: 2);

      return DailyMartProductReviewsSection(
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

  /// Same landing as Home's "See all" chips — this template has no
  /// Categories tab, so browse means the store-scoped Search screen.
  void _openBrowse() => context.push(AppRoutes.search, extra: widget.storeId);

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ColoredBox(
      color: cs.surface,
      child: SafeArea(
        bottom: false,
        // A review write's outcome is a side effect, not a rebuild — the
        // section itself repaints from the reloaded list.
        child: BlocListener<ProductReviewsBloc, ProductReviewsState>(
          listener: (_, state) => handleReviewsState(state),
          child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
            listener: (context, state) {
              if (state case ProductDetailsError(:final message)) {
                showSnackBar(message);
              }
              // Hands the reviews section the page it already loaded, instead
              // of it fetching the same first page again.
              if (state case ProductDetailsLoaded(:final detail)) {
                seedReviews(detail.reviews);
              }
            },
            builder: (context, state) => switch (state) {
              ProductDetailsError(:final storeId, :final productId) => _Page(
                onBack: () => context.pop(),
                body: ErrorView(
                  message: DailyMartValueConst.productDetailsLoadErrorMessage,
                  onRetry: () =>
                      retryLoad(storeId: storeId, productId: productId),
                ),
              ),
              // Loading and loaded share the header and scroll view, so only
              // the body swaps — a differently-structured loading state makes
              // the whole page jump when data lands.
              ProductDetailsLoading() => _Page(
                onBack: () => context.pop(),
                body: const DailyMartProductDetailSkeletonBody(),
              ),
              ProductDetailsLoaded(:final detail) => _loaded(detail),
            },
          ),
        ),
      ),
    );
  }

  Widget _loaded(ProductDetailEntity detail) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;
    final product = detail.product;
    final variant = selectedVariant(detail);
    final favouritesCubit = context.watch<FavouritesCubit>();
    final isFavourite = favouritesCubit.isFavourite(product.id);

    return Stack(
      // The scroll view is the stack's only non-positioned child and it
      // shrink-wraps to its content — without expanding, a short page (brief
      // description, no related grid) ends the stack early and the
      // Positioned fade + action row "pin" to the content's bottom edge
      // instead of the device's.
      fit: StackFit.expand,
      children: [
        _Page(
          onBack: () => context.pop(),
          trailing: DailyMartIconDisc(
            asset: isFavourite
                ? DailyMartImageConst.heartFilled
                : DailyMartImageConst.heart,
            foregroundColor: isFavourite ? cs.primary : null,
            onTap: () => context.toggleFavouriteOrSignIn(product),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroImage(
                url: detail.images.isNotEmpty
                    ? detail.images.first
                    : product.imageUrl,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Kit deviation (recorded in the spec sheet): the kit predates
              // brands, so the brand line takes the card meta's muted small
              // role above the name.
              if (detail.brand != null) ...[
                Text(
                  detail.brand!.name,
                  style: DailyMartTextStyleConst.bodyXsMedium(
                    tt,
                  ).copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs3),
              ],
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: DailyMartTextStyleConst.bodyLgSemibold(
                        Theme.of(context).textTheme,
                      ).copyWith(color: cs.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _RatingPill(product: product),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  Expanded(
                    child: _PriceLabel(product: product, variant: variant),
                  ),
                  // Between the price and the stepper, which is where the
                  // shopper is looking as they decide how many to take.
                  if (product.isLowStock) ...[
                    Text(
                      ValueConst.onlyNLeftLabel(product.stock!),
                      style: DailyMartTextStyleConst.bodyXsSemibold(
                        tt,
                      ).copyWith(color: cs.error),
                    ),
                    const SizedBox(width: AppSpacing.base),
                  ],
                  if (product.isInStock)
                    DailyMartQuantityStepper(
                      value: quantity,
                      onDecrement: decrementQuantity,
                      onIncrement: incrementQuantityUpTo(product.purchaseLimit),
                    ),
                ],
              ),
              // Kit deviation (recorded in the spec sheet): the kit has no
              // size picker; the row reuses My Orders' filter-chip recipe so
              // the selected size — which now carries its own price — is a
              // real choice, not decoration.
              if (detail.sizeVariants.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  DailyMartValueConst.selectSizeLabel,
                  style: DailyMartTextStyleConst.bodyMdSemibold(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: AppSpacing.base),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < detail.sizeVariants.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.base),
                        DailyMartFilterChip(
                          label: product.unitType.format(
                            detail.sizeVariants[i].value,
                          ),
                          selected: i == effectiveSizeIndex(detail),
                          onTap: () => selectSize(i),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Divider(height: 1, thickness: 1, color: hairline),
              const SizedBox(height: AppSpacing.xl4),
              _DetailTabs(
                showReviews: _showReviews,
                onChanged: (showReviews) =>
                    setState(() => _showReviews = showReviews),
              ),
              const SizedBox(height: AppSpacing.lg),
              DailyMartTopSwitcher(
                child: _showReviews
                    ? KeyedSubtree(
                        key: const ValueKey('reviews'),
                        child: _reviewsTab(),
                      )
                    : _DescriptionText(
                        key: const ValueKey('description'),
                        description: detail.description,
                      ),
              ),
              if (detail.similarProducts.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl4),
                DailyMartSectionHeader(
                  title: DailyMartValueConst.relatedProductsTitle,
                  onSeeAll: _openBrowse,
                ),
                const SizedBox(height: AppSpacing.lg),
                DailyMartProductGrid(
                  products: detail.similarProducts,
                  onAdd: (related) => _addToCart(related, 1),
                  onProductTap: openProductDetails,
                  onFavouriteToggle: (related) =>
                      context.toggleFavouriteOrSignIn(related),
                ),
              ],
            ],
          ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DailyMartBottomFade(
            height: DailyMartDimenConst.detailBottomFadeHeight,
          ),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          child: DailyMartProductDetailBottomBar(
            storeId: widget.storeId,
            soldOut: product.isOutOfStock,
            onAddToCart: () async {
              if (!await addSelectedToCart(detail, quantity) || !mounted) {
                return;
              }
              showSnackBar(
                DailyMartValueConst.addedToCartMessage(product.name, quantity),
              );
              resetQuantity();
            },
          ),
        ),
      ],
    );
  }
}

/// The page shell the skeleton, error, and loaded bodies share.
class _Page extends StatelessWidget {
  final VoidCallback onBack;
  final Widget? trailing;
  final Widget body;

  const _Page({required this.onBack, this.trailing, required this.body});

  @override
  Widget build(BuildContext context) {
    // Clearance under the scroll for the floating action row (and the cart
    // status pill above it) — derived from the controls it must clear.
    final bottomClearance =
        MediaQuery.paddingOf(context).bottom +
        DailyMartDimenConst.ctaHeight +
        DailyMartDimenConst.controlHeight +
        AppSpacing.xl10;

    // The header docks above the scroll view — the pack pins every
    // back-button header (same pattern as DailyMartScreenBody's pinned mode).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.base,
            AppSpacing.lg,
            0,
          ),
          child: DailyMartHeaderRow(
            title: DailyMartValueConst.productDetailsTitle,
            onBack: onBack,
            trailing: trailing,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              bottomClearance,
            ),
            child: body,
          ),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String url;

  const _HeroImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      // The kit's one 12px well (deviation recorded in the spec sheet §2) —
      // the hero reads as a photo frame, not a card.
      borderRadius: AppRadius.lg,
      child: Container(
        height: DailyMartDimenConst.detailImageHeight,
        width: double.infinity,
        // The recessed neutral, not the product card's cool tint — the kit
        // draws this well one step darker (spec sheet §6).
        color: cs.surfaceContainer,
        child: AppNetworkImage(url: url, fit: BoxFit.cover),
      ),
    );
  }
}

/// The bordered rating pill beside the name. An unrated product greys the
/// star and says so rather than printing 0.0 — same policy as the product
/// card's rating row.
class _RatingPill extends StatelessWidget {
  final ProductEntity product;

  const _RatingPill({required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final rated = product.hasRating;

    return Container(
      height: DailyMartDimenConst.ratingPillHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline),
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgImage.asset(
            DailyMartImageConst.star,
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            color: rated
                ? DailyMartColorConst.ratingStar
                : cs.surfaceContainerHighest,
          ),
          const SizedBox(width: AppSpacing.xs3),
          Text(
            product.ratingLabel,
            style: DailyMartTextStyleConst.bodyXsMedium(
              tt,
            ).copyWith(color: rated ? cs.onSurface : cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final ProductEntity product;

  /// The selected size — price and the per-pack suffix follow it; null (no
  /// size picker) falls back to the product's base pack.
  final SizeVariantEntity? variant;

  const _PriceLabel({required this.product, this.variant});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: (variant?.price ?? product.price).asPrice,
            style: DailyMartTextStyleConst.bodyLgSemibold(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
          TextSpan(
            text: DailyMartValueConst.perUnitSuffix(
              product.unitType.format(variant?.value ?? product.unitValue),
            ),
            style: DailyMartTextStyleConst.bodySmSemibold(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// The kit's two underline tabs — active takes the primary label and a
/// primary bottom border, inactive stays ink on the hairline.
class _DetailTabs extends StatelessWidget {
  final bool showReviews;
  final ValueChanged<bool> onChanged;

  const _DetailTabs({required this.showReviews, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Tab(
            label: DailyMartValueConst.descriptionsTabLabel,
            active: !showReviews,
            onTap: () => onChanged(false),
          ),
        ),
        Expanded(
          child: _Tab(
            label: DailyMartValueConst.reviewsTabLabel,
            active: showReviews,
            onTap: () => onChanged(true),
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = context.appColors.dockedHairline;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        // The micro tier — a state flip, same as a nav tab (spec sheet §7).
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: active ? cs.primary : hairline),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: active
                ? DailyMartTextStyleConst.bodyMdSemibold(
                    tt,
                  ).copyWith(color: cs.primary)
                : DailyMartTextStyleConst.bodyMdMedium(
                    tt,
                  ).copyWith(color: cs.onSurface),
          ),
        ),
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  final String description;

  const _DescriptionText({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: Text(
        description,
        style: DailyMartTextStyleConst.bodySmRegular(
          tt,
        ).copyWith(color: cs.onSurface),
      ),
    );
  }
}
