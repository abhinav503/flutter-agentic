import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';
import 'package:core/core/ui/molecules/skeleton_rows.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/cart/presentation/quantity_selection.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/product_details/domain/entities/product_detail_entity.dart';
import 'package:cordelia/feature/storefront/product_details/domain/entities/size_variant_entity.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/product_details/presentation/product_details_actions.dart';
import 'package:cordelia/feature/storefront/reviews/domain/entities/product_reviews_entity.dart';
import 'package:cordelia/feature/storefront/reviews/domain/entities/review_entity.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/bloc/product_reviews_bloc.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/product_reviews_actions.dart';
import 'package:cordelia/feature/storefront/reviews/presentation/templates/grofast/widgets/product_reviews_section.dart';
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
          existing: existing,
          onSubmit: submitReview,
          onMessage: showSnackBar,
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
          );
        },
      );

  void _addToBag(ProductDetailEntity detail) {
    addSelectedToCart(detail, quantity);
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
              variant: selectedVariant(detail),
              selectedSizeIndex: effectiveSizeIndex(detail),
              onSelectSize: selectSize,
              onIncrement: incrementQuantity,
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

  /// The selected size (null = no size picker) with the state/callback the
  /// host's `ProductDetailsActions` mixin owns — price and the chip row
  /// follow it.
  final SizeVariantEntity? variant;
  final int selectedSizeIndex;
  final ValueChanged<int> onSelectSize;

  final VoidCallback onIncrement;
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
    required this.variant,
    required this.selectedSizeIndex,
    required this.onSelectSize,
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
                    context.read<FavouritesCubit>().toggle(product),
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
                                label: product.hasRating
                                    ? ValueConst.ratingLabel(
                                        product.ratingAverage,
                                        product.reviewCount,
                                      )
                                    : ValueConst.unratedLabel,
                                leading: Icon(
                                  Icons.star_rounded,
                                  size: GrofastDimenConst.badgeLeadingSize,
                                  color: product.hasRating
                                      ? GrofastColorConst.ratingStar
                                      : cs.onSurfaceVariant,
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
                          value: variant?.price ?? product.price,
                          unit: product.unitType.pricePerLabel(
                            variant?.value ?? product.unitValue,
                          ),
                          scale: GrofastDimenConst.detailPriceScale,
                        ),
                      ],
                    ),
                    // Kit deviation (recorded in the spec sheet): the kit has
                    // no size picker — the pack's single-select chip row
                    // carries the sizes, each priced by its own variant.
                    if (detail.sizeVariants.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl4),
                      Text(
                        GrofastValueConst.selectSizeTitle,
                        style: GrofastTextStyleConst.sectionBold(tt),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GrofastChipRow(
                        labels: [
                          for (final v in detail.sizeVariants)
                            product.unitType.format(v.value),
                        ],
                        selectedIndex: selectedSizeIndex,
                        onSelected: onSelectSize,
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
                    const SizedBox(height: AppSpacing.xl6),
                    reviewsSection,
                    if (detail.similarProducts.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl6),
                      const GrofastSectionHeader(
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
                            context.read<FavouritesCubit>().toggle(p),
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
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToBag;

  const _AddToBagDock({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToBag,
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
                  child: GestureDetector(
                    onTap: onAddToBag,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: GrofastColorConst.brandGradient,
                        borderRadius: BorderRadius.only(
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
                            GrofastValueConst.addToBag,
                            style: GrofastTextStyleConst.labelSemibold(
                              tt,
                            ).copyWith(color: cs.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
