import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:cordelia/feature/storefront/cart/presentation/quantity_selection.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/product_details/domain/entities/product_detail_entity.dart';
import 'package:cordelia/feature/storefront/product_details/presentation/widgets/product_attributes_list.dart';
import 'package:cordelia/feature/storefront/product_details/presentation/product_details_actions.dart';
import 'package:cordelia/feature/storefront/reviews/domain/entities/product_reviews_entity.dart';
import 'package:cordelia/feature/storefront/reviews/domain/entities/review_entity.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/bloc/product_reviews_bloc.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/product_reviews_actions.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/templates/grofast/widgets/product_reviews_section.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/templates/grofast/widgets/report_review_sheet_content.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/templates/grofast/widgets/write_review_sheet_content.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_chip.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_dome.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_price.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_card.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_sheet.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';
import 'package:cordelia/feature/storefront/home/presentation/product_rating_label.dart';

import '../../../bloc/product_details_bloc.dart';

/// `grofast` template's Product Details (kit frame `27:288`) — the pack's one
/// screen whose header floats on the artwork rather than sitting above it.
///
/// The composition: a tall tinted hero well whose **bottom** edge is the
/// pack's dome (the only place the arc is flipped), the back and bag controls
/// floating over it, the favourite disc inside the well clear of the arc, and
/// the copy below. The stepper and the gradient "Add to bag" panel share the
/// docked row at the bottom, exactly as the kit draws them.
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
      showGrofastSheet<void>(
        title: ValueConst.reviewSheetTitle,
        child: GrofastWriteReviewSheetContent(
          initialRating: existing?.rating ?? 0,
          initialText: existing?.text ?? '',
          onSubmit: submitReview,
        ),
      );

  @override
  Future<void> showReportReviewSheet(ReviewEntity review) =>
      showGrofastSheet<void>(
        title: ValueConst.reportReviewSheetTitle,
        child: GrofastReportReviewSheetContent(
          onSubmit: (reason, block) => submitReport(review.uid, reason, block),
        ),
      );

  @override
  Future<void> showDeleteReviewSheet({required VoidCallback onConfirm}) =>
      showGrofastConfirmSheet(
        context: context,
        title: ValueConst.reviewDeleteConfirmTitle,
        message: ValueConst.reviewDeleteConfirmMessage,
        confirmLabel: ValueConst.deleteReviewLabel,
        onConfirm: onConfirm,
      );

  /// The Reviews block, built here and handed to [_DetailsContent] — a write
  /// repaints only this subtree, leaving the hero, price and chips untouched.
  Widget _reviewsSection() =>
      BlocBuilder<ProductReviewsBloc, ProductReviewsState>(
        builder: (context, state) {
          final reviews = state.reviewsOrNull;
          // Only before the seed lands (and while a refresh re-reads) — a
          // skeleton in the section's own shape, never a spinner.
          if (reviews == null) return const ShimmerListRow(itemCount: 2);

          return GrofastProductReviewsSection(
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

  Future<void> _addToBag(ProductDetailEntity detail) async {
    if (!await addSelectedToCart(detail, quantity) || !mounted) return;
    showSnackBar(
      GrofastValueConst.addedToBagMessage(detail.product.name, quantity),
    );
    resetQuantity();
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    // A review write's outcome is a side effect, not a rebuild — the section
    // itself repaints from the reloaded list.
    return BlocListener<ProductReviewsBloc, ProductReviewsState>(
      listener: (_, state) => handleReviewsState(state),
      child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        // Hands the reviews section the page it already loaded, instead of
        // it fetching the same first page again.
        listener: (context, state) {
          if (state case ProductDetailsLoaded(:final detail)) {
            seedReviews(detail.reviews);
          }
        },
        builder: (context, state) => GrofastSwitcher(
          child: switch (state) {
            ProductDetailsLoading() => _DetailsSkeletonBody(
              storeId: widget.storeId,
            ),
            ProductDetailsError(
              :final message,
              :final storeId,
              :final productId,
            ) =>
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GrofastDimenConst.screenGutter,
                  ),
                  child: Column(
                    children: [
                      const GrofastHeaderRow(),
                      Expanded(
                        child: Center(
                          child: GrofastErrorView(
                            message: message,
                            onRetry: () => retryLoad(
                              storeId: storeId,
                              productId: productId,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ProductDetailsLoaded(:final detail) => _DetailsContent(
              detail: detail,
              storeId: widget.storeId,
              quantity: quantity,
              unitPrice: unitPrice(detail),
              packLabel: packLabel(
                detail,
                detail.product.unitType.pricePerLabel,
              ),
              lowStock: isSelectedLowStock(detail)
                  ? selectedStock(detail)
                  : null,
              soldOut: isSelectedOutOfStock(detail),
              axes: optionAxes(detail),
              onSelectOption: selectOption,
              onIncrement: incrementQuantityUpTo(selectedPurchaseLimit(detail)),
              onDecrement: decrementQuantity,
              onAddToBag: () => _addToBag(detail),
              onSimilarTap: openProductDetails,
              onSimilarAdd: (product) {
                addToCart(product, 1);
                showSnackBar(
                  GrofastValueConst.addedToBagMessage(product.name, 1),
                );
              },
              reviewsSection: _reviewsSection(),
            ),
          },
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final ProductDetailEntity detail;
  final String storeId;
  final int quantity;

  /// What the selected variant resolves to — the host's
  /// `ProductDetailsActions` mixin owns the selection; price, the pack label,
  /// the stock badge, the dock and the chip rows all follow it.
  final double unitPrice;
  final String packLabel;

  /// Units left when running low, else null.
  final int? lowStock;
  final bool soldOut;
  final List<OptionAxis> axes;
  final void Function(int axis, String value) onSelectOption;

  /// Null at the product's remaining stock, same as [onDecrement] at 1.
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToBag;
  final ValueChanged<ProductEntity> onSimilarTap;
  final ValueChanged<ProductEntity> onSimilarAdd;

  /// Built by the host (it owns the reviews bloc's dispatches) and slotted
  /// in below the description.
  final Widget reviewsSection;

  const _DetailsContent({
    required this.detail,
    required this.storeId,
    required this.quantity,
    required this.unitPrice,
    required this.packLabel,
    required this.lowStock,
    required this.soldOut,
    required this.axes,
    required this.onSelectOption,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToBag,
    required this.onSimilarTap,
    required this.onSimilarAdd,
    required this.reviewsSection,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final product = detail.product;
    final favourites = context.watch<FavouritesCubit>().state.items;
    final isFavourite = favourites.any((p) => p.id == product.id);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: GrofastDimenConst.detailScrollInset(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroWell(
                imageUrl: product.imageUrl,
                isFavourite: isFavourite,
                onFavouriteToggle: () =>
                    context.toggleFavouriteOrSignIn(product),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  GrofastDimenConst.screenGutter,
                  AppSpacing.xl4,
                  GrofastDimenConst.screenGutter,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GrofastTextStyleConst.displayBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // The kit's one row: what the product *is* on the left,
                    // what it costs on the right. The price carries the pack
                    // size in its suffix ("/kg", "/500 g"), which is why no
                    // separate size line sits under the title.
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              // An unrated product greys the star and says
                              // so rather than printing 0.0, which would
                              // read as a badly-reviewed product.
                              GrofastBadge.outlined(
                                label: product.ratingLabel,
                                leading: Icon(
                                  Icons.star_rounded,
                                  size: GrofastDimenConst.badgeLeadingSize,
                                  color: product.hasRating
                                      ? GrofastColorConst.ratingStar
                                      : cs.onSurfaceVariant,
                                ),
                              ),
                              // The kit's badge row is where this page says
                              // what a product *is*; running out is the one
                              // fact on it that changes by the minute, so it
                              // leads.
                              if (lowStock case final left?)
                                GrofastBadge.outlined(
                                  label: ValueConst.onlyNLeftLabel(left),
                                  leading: Icon(
                                    Icons.inventory_2_outlined,
                                    size: GrofastDimenConst.badgeLeadingSize,
                                    color: cs.error,
                                  ),
                                ),
                              if (detail.category case final category?)
                                GrofastBadge.tinted(
                                  label: category.name,
                                  leading: ClipOval(
                                    child: AppNetworkImage(
                                      url: category.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              // Kit deviation (recorded in the spec sheet):
                              // the kit predates brands — the brand joins the
                              // product's label pills, artwork when it has a
                              // logo, the rounded-icon system otherwise.
                              if (detail.brand case final brand?)
                                brand.imageUrl.isEmpty
                                    ? GrofastBadge.outlined(
                                        label: brand.name,
                                        leading: Icon(
                                          Icons.sell_rounded,
                                          size: GrofastDimenConst
                                              .badgeLeadingSize,
                                          color: cs.primary,
                                        ),
                                      )
                                    : GrofastBadge.outlined(
                                        label: brand.name,
                                        leading: ClipOval(
                                          child: AppNetworkImage(
                                            url: brand.imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        GrofastPrice(
                          value: unitPrice,
                          unit: packLabel,
                          scale: GrofastDimenConst.detailPriceScale,
                        ),
                      ],
                    ),
                    // Kit deviation (recorded in the spec sheet): the kit has
                    // no option picker — the pack's single-select chip row
                    // carries one row per axis (Size, Colour, a pack size),
                    // each unit priced and stocked on its own.
                    for (final axis in axes) ...[
                      const SizedBox(height: AppSpacing.xl4),
                      Text(
                        GrofastValueConst.selectOptionTitle(axis.name),
                        style: GrofastTextStyleConst.sectionBold(tt),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GrofastChipRow(
                        labels: [for (final v in axis.values) v.value],
                        selectedIndex: axis.values.indexWhere(
                          (v) => v.selected,
                        ),
                        unavailable: {
                          for (var i = 0; i < axis.values.length; i++)
                            if (!axis.values[i].available) i,
                        },
                        onSelected: (i) =>
                            onSelectOption(axis.index, axis.values[i].value),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl4),
                    Text(
                      GrofastValueConst.descriptionTitle,
                      style: GrofastTextStyleConst.sectionBold(tt),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      detail.description.isEmpty
                          ? GrofastValueConst.noDescriptionLabel
                          : detail.description,
                      style: GrofastTextStyleConst.bodyRelaxed(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                    if (product.attributes.isNotEmpty)
                      const SizedBox(height: AppSpacing.sm),
                    ProductAttributesList(
                      attributes: product.attributes,
                      keyStyle: GrofastTextStyleConst.bodySmall(
                        tt,
                      ).copyWith(color: cs.onSurface),
                      valueStyle: GrofastTextStyleConst.bodyRelaxed(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.xl6),
                    reviewsSection,
                    if (detail.similarProducts.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl6),
                      GrofastSectionHeader(
                        title: GrofastValueConst.popularTitle,
                      ),
                      const SizedBox(height: AppSpacing.xl2),
                      GrofastProductGrid(
                        products: detail.similarProducts,
                        // The related grid keeps a single card height: the
                        // stagger is Home's and Search's rhythm, and starting
                        // it two-thirds down another screen just looks broken.
                        stagger: false,
                        onAdd: onSimilarAdd,
                        onProductTap: onSimilarTap,
                        onFavouriteToggle: (p) =>
                            context.toggleFavouriteOrSignIn(p),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: GrofastDimenConst.detailDockHeight(context),
          child: const GrofastBottomFade.overDock(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _AddToBagDock(
            quantity: quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onAddToBag: onAddToBag,
            soldOut: soldOut,
          ),
        ),
        // Pinned over the scrolling hero, not inside it — every back-button
        // header in this pack stays docked; the controls carry their own
        // fills, so they hold up over whatever scrolls beneath.
        Positioned(
          top: MediaQuery.paddingOf(context).top + AppSpacing.base,
          left: GrofastDimenConst.screenGutter,
          right: GrofastDimenConst.screenGutter,
          child: GrofastHeaderRow(trailing: GrofastBagAction(storeId: storeId)),
        ),
      ],
    );
  }
}

/// The kit's docked row (`27:316` + `101:1254`), which is not the pack's
/// usual floating-CTA-over-a-fade at all: the "Add to bag" gradient is a
/// **panel** welded into the bottom-right corner — one 28 radius on its
/// top-left, no others, and no safe-area inset, so it runs behind the home
/// indicator — while the stepper beside it rests on that inset. The band
/// itself is opaque `cs.surface`; the fade sits above it, not under it, so
/// nothing scrolls through the row.
class _AddToBagDock extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToBag;

  /// Sold out: the panel keeps its welded shape (it is part of the band's
  /// silhouette) but loses the gradient and its tap, and the stepper goes —
  /// there is no quantity to pick.
  final bool soldOut;

  const _AddToBagDock({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToBag,
    required this.soldOut,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bottomInset = GrofastDimenConst.detailStepperBottomInset(context);

    return ColoredBox(
      color: cs.surface,
      child: SizedBox(
        height: GrofastDimenConst.detailDockHeight(context),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: GrofastDimenConst.detailDockPanelWidthFraction,
                heightFactor: 1,
                child: Semantics(
                  button: true,
                  enabled: !soldOut,
                  child: GestureDetector(
                    onTap: soldOut ? null : onAddToBag,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: soldOut
                            ? null
                            : GrofastColorConst.brandGradient,
                        color: soldOut
                            ? cs.onSurface.withValues(alpha: 0.12)
                            : null,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            GrofastDimenConst.detailDockPanelRadius,
                          ),
                        ),
                      ),
                      // The label centres on the stepper's line, not on the
                      // panel's — the panel is taller than the row it joins
                      // because it swallows the device inset.
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: bottomInset),
                      child: SizedBox(
                        height: GrofastDimenConst.detailStepperButtonSize,
                        child: Center(
                          child: Text(
                            soldOut
                                ? ValueConst.outOfStockLabel
                                : GrofastValueConst.addToBag,
                            style: GrofastTextStyleConst.labelSemibold(tt)
                                .copyWith(
                                  color: soldOut
                                      ? cs.onSurface.withValues(alpha: 0.38)
                                      : cs.onPrimary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!soldOut)
              Positioned(
                left: GrofastDimenConst.screenGutter,
                bottom: bottomInset,
                child: GrofastQuantityStepper.large(
                  quantity: quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The hero: a tinted well whose bottom edge is the pack's dome. The header
/// row is NOT here — it pins in the screen's outer Stack so it can't scroll
/// away with the well; only the favourite disc scrolls with the artwork.
class _HeroWell extends StatelessWidget {
  final String imageUrl;
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;

  const _HeroWell({
    required this.imageUrl,
    required this.isFavourite,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return ClipPath(
      clipper: const GrofastBottomDomeClipper(),
      child: SizedBox(
        height: GrofastDimenConst.detailImageHeight(context),
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: cs.surfaceContainerLow,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topInset + AppSpacing.xl8,
                    // The artwork clears the favourite disc *and* the arc the
                    // dome cuts out of the well's bottom.
                    bottom:
                        GrofastDimenConst.detailFavouriteBottomInset +
                        GrofastDimenConst.detailFavouriteSize,
                    left: GrofastDimenConst.screenGutter,
                    right: GrofastDimenConst.screenGutter,
                  ),
                  child: AppNetworkImage(url: imageUrl, fit: BoxFit.contain),
                ),
              ),
            ),
            // Inside the well, clear of the arc — the kit never lets this
            // disc straddle the dome's edge.
            Positioned(
              right: GrofastDimenConst.screenGutter,
              bottom: GrofastDimenConst.detailFavouriteBottomInset,
              child: GrofastFavouriteHeart(
                isFavourite: isFavourite,
                onTap: onFavouriteToggle,
                size: GrofastDimenConst.detailFavouriteSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mirrors [_DetailsContent]'s Stack, not just its copy: the domed hero well,
/// the same scroll inset, and the dock's silhouette — otherwise the layout
/// jumps when data lands and, worse, the dock's device inset is unpaid while
/// loading. The header row is the real one, so Back and the bag work before
/// the product arrives.
class _DetailsSkeletonBody extends StatelessWidget {
  final String storeId;

  const _DetailsSkeletonBody({required this.storeId});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: GrofastDimenConst.detailScrollInset(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: const GrofastBottomDomeClipper(),
                child: ShimmerBox(
                  width: double.infinity,
                  height: GrofastDimenConst.detailImageHeight(context),
                  borderRadius: BorderRadius.zero,
                ),
              ),
              const SizedBox(height: AppSpacing.xl4),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: GrofastDimenConst.screenGutter,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 200, height: AppSpacing.xl6),
                    SizedBox(height: AppSpacing.base),
                    ShimmerBox(width: 120, height: AppSpacing.lg),
                    SizedBox(height: AppSpacing.xl4),
                    ShimmerBox(width: double.infinity, height: AppSpacing.base),
                    SizedBox(height: AppSpacing.xs),
                    ShimmerBox(width: double.infinity, height: AppSpacing.base),
                    SizedBox(height: AppSpacing.xs),
                    ShimmerBox(width: 220, height: AppSpacing.base),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: const _DockSkeleton()),
        // Same pinned header as the loaded body, so Back and the bag work
        // (and hold still) before the product arrives.
        Positioned(
          top: topInset + AppSpacing.base,
          left: GrofastDimenConst.screenGutter,
          right: GrofastDimenConst.screenGutter,
          child: GrofastHeaderRow(trailing: GrofastBagAction(storeId: storeId)),
        ),
      ],
    );
  }
}

/// The dock's silhouette while loading — same height, same welded corner, so
/// the bottom edge is paid for and the panel doesn't pop into place.
class _DockSkeleton extends StatelessWidget {
  const _DockSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = GrofastDimenConst.detailStepperBottomInset(context);

    return ColoredBox(
      color: cs.surface,
      child: SizedBox(
        height: GrofastDimenConst.detailDockHeight(context),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: GrofastDimenConst.detailDockPanelWidthFraction,
                heightFactor: 1,
                child: const ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      GrofastDimenConst.detailDockPanelRadius,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: GrofastDimenConst.screenGutter,
              bottom: bottomInset,
              child: const ShimmerBox(
                width: GrofastDimenConst.detailStepperWidth,
                height: GrofastDimenConst.detailStepperButtonSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
