import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/chunked_grid.dart';
import 'package:core/core/ui/molecules/error_view.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_bottom_fade.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_header_row.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_product_card.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_quantity_stepper.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_section_header.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_top_switcher.dart';

import '../../../../domain/entities/product_detail_entity.dart';
import '../../../bloc/product_details_bloc.dart';
import '../../../product_details_actions.dart';
import '../widgets/product_detail_bottom_bar.dart';
import '../widgets/product_detail_skeleton_body.dart';
import '../widgets/product_reviews_section.dart';

/// `dailymart` template's Product Details — kit frames `22`/`23`: header
/// row, one hero image well, name beside a bordered rating pill, price with
/// the bare green stepper, Descriptions/Reviews underline tabs (Reviews is
/// the kit's static frame — see [DailyMartProductReviewsSection]), a
/// Related Products grid, and the floating cart-disc + Add To Cart row over
/// a bottom fade.
class ProductDetailsScreen extends BaseScreen {
  final String storeId;

  const ProductDetailsScreen({super.key, required this.storeId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends BaseScreenState<ProductDetailsScreen>
    with ProductDetailsActions {
  @override
  String get storeId => widget.storeId;

  /// UI-local, like a tab index — which of the two content tabs shows.
  bool _showReviews = false;

  void _addToCart(ProductEntity product, int quantity) {
    addToCart(product, quantity);
    showSnackBar(
      DailyMartValueConst.addedToCartMessage(product.name, quantity),
    );
  }

  /// Same landing as Home's "See all" chips — this template has no
  /// Categories tab, so browse means the store-scoped Search screen.
  void _openBrowse() =>
      context.push(AppRoutes.search, extra: widget.storeId);

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
        child: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
          listener: (context, state) {
            if (state case ProductDetailsError(:final message)) {
              showSnackBar(message);
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
    );
  }

  Widget _loaded(ProductDetailEntity detail) {
    final cs = Theme.of(context).colorScheme;
    final hairline =
        Theme.of(context).extension<AppColorsExtension>()!.dockedHairline;
    final product = detail.product;
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
            onTap: () => context.read<FavouritesCubit>().toggle(product),
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
                  const _RatingPill(),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  Expanded(child: _PriceLabel(product: product)),
                  DailyMartQuantityStepper(
                    value: quantity,
                    onDecrement: decrementQuantity,
                    onIncrement: incrementQuantity,
                  ),
                ],
              ),
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
                    ? const DailyMartProductReviewsSection(
                        key: ValueKey('reviews'),
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
                ChunkedGrid(
                  itemCount: detail.similarProducts.length,
                  columns: 2,
                  spacing: AppSpacing.base,
                  runSpacing: AppSpacing.lg,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  itemBuilder: (context, index) {
                    final related = detail.similarProducts[index];
                    return DailyMartProductCard(
                      product: related,
                      onAdd: () => _addToCart(related, 1),
                      onTap: () => openProductDetails(related),
                      isFavourite: favouritesCubit.isFavourite(related.id),
                      onFavouriteToggle: () =>
                          context.read<FavouritesCubit>().toggle(related),
                    );
                  },
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
            onAddToCart: () {
              _addToCart(product, quantity);
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

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        bottomClearance,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DailyMartHeaderRow(
            title: DailyMartValueConst.productDetailsTitle,
            onBack: onBack,
            trailing: trailing,
          ),
          const SizedBox(height: AppSpacing.lg),
          body,
        ],
      ),
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

/// The bordered rating pill beside the name — static placeholder numbers,
/// same policy as the product card's rating row.
class _RatingPill extends StatelessWidget {
  const _RatingPill();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

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
            color: DailyMartColorConst.ratingStar,
          ),
          const SizedBox(width: AppSpacing.xs3),
          Text(
            DailyMartValueConst.staticRatingLabel,
            style: DailyMartTextStyleConst.bodyXsMedium(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  final ProductEntity product;

  const _PriceLabel({required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: DailyMartValueConst.formattedPrice(product.price),
            style: DailyMartTextStyleConst.bodyLgSemibold(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
          TextSpan(
            text: DailyMartValueConst.perUnitSuffix(
              product.unitType.format(product.unitValue),
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
    final hairline =
        Theme.of(context).extension<AppColorsExtension>()!.dockedHairline;

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
