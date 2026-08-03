import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/shimmer_box.dart';

import 'package:cordelia/constants/app_routes.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/cart/presentation/quantity_selection.dart';
import 'package:cordelia/feature/storefront/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/product_details/domain/entities/product_detail_entity.dart';
import 'package:cordelia/feature/storefront/product_details/presentation/product_details_actions.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_dome.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_header_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_line_item_row.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_price.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_card.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_product_grid.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_screen_body.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_section_header.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_state_views.dart';

import '../../../bloc/product_details_bloc.dart';

/// `grofast` template's Product Details (kit frame `27:288`) — the pack's one
/// screen whose header floats on the artwork rather than sitting above it.
///
/// The composition: a tall tinted hero well whose **bottom** edge is the
/// pack's dome (the only place the arc is flipped), the back and bag controls
/// floating over it, the favourite disc overlapping the arc on the right, and
/// the copy below. The stepper and the gradient "Add to bag" pill share the
/// docked row at the bottom, exactly as the kit draws them.
class ProductDetailsScreen extends BaseScreen {
  final String storeId;

  const ProductDetailsScreen({super.key, required this.storeId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends BaseScreenState<ProductDetailsScreen>
    with QuantitySelection, ProductDetailsActions {
  @override
  String get storeId => widget.storeId;

  void _addToBag(ProductEntity product) {
    addToCart(product, quantity);
    showSnackBar(GrofastValueConst.addedToBagMessage(product.name, quantity));
    resetQuantity();
  }

  @override
  SystemUiOverlayStyle? overlayStyle(BuildContext context) =>
      BaseScreenState.themedStatusIcons(context);

  @override
  Widget body(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) => switch (state) {
        ProductDetailsLoading() => const _DetailsSkeletonBody(),
        ProductDetailsError(:final message, :final storeId, :final productId) =>
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
                        onRetry: () =>
                            retryLoad(storeId: storeId, productId: productId),
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
          onIncrement: incrementQuantity,
          onDecrement: decrementQuantity,
          onAddToBag: () => _addToBag(detail.product),
          onSimilarTap: openProductDetails,
          onSimilarAdd: (product) {
            addToCart(product, 1);
            showSnackBar(GrofastValueConst.addedToBagMessage(product.name, 1));
          },
        ),
      },
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final ProductDetailEntity detail;
  final String storeId;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback onAddToBag;
  final ValueChanged<ProductEntity> onSimilarTap;
  final ValueChanged<ProductEntity> onSimilarAdd;

  const _DetailsContent({
    required this.detail,
    required this.storeId,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToBag,
    required this.onSimilarTap,
    required this.onSimilarAdd,
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
            bottom: GrofastDimenConst.floatingActionScrollInset(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroWell(
                imageUrl: product.imageUrl,
                storeId: storeId,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: GrofastTextStyleConst.displayBold(tt),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        GrofastPrice(
                          value: product.price,
                          unit: product.unitType.unitLabel(product.unitValue),
                          scale: 1.3,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      product.unitType.format(product.unitValue),
                      style: GrofastTextStyleConst.meta(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant),
                    ),
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
                      style: GrofastTextStyleConst.bodyMedium(
                        tt,
                      ).copyWith(color: cs.onSurfaceVariant, height: 1.6),
                    ),
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
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: GrofastBottomFade(),
        ),
        Positioned(
          left: GrofastDimenConst.screenGutter,
          right: GrofastDimenConst.screenGutter,
          bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          child: Row(
            children: [
              GrofastQuantityStepper(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: GrofastPrimaryButton(
                  label: GrofastValueConst.addToBag,
                  onTap: onAddToBag,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The hero: a tinted well whose bottom edge is the pack's dome, with the
/// floating chrome over it.
class _HeroWell extends StatelessWidget {
  final String imageUrl;
  final String storeId;
  final bool isFavourite;
  final VoidCallback onFavouriteToggle;

  const _HeroWell({
    required this.imageUrl,
    required this.storeId,
    required this.isFavourite,
    required this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;

    return SizedBox(
      // The favourite disc hangs half outside the well, so the stack has to
      // be taller than the clipped surface by that overhang.
      height:
          GrofastDimenConst.detailImageHeight +
          GrofastDimenConst.detailFavouriteSize / 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: const GrofastBottomDomeClipper(),
            child: Container(
              height: GrofastDimenConst.detailImageHeight,
              width: double.infinity,
              color: cs.surfaceContainerLow,
              padding: EdgeInsets.only(
                top: topInset + AppSpacing.xl8,
                bottom: AppSpacing.xl6,
                left: GrofastDimenConst.screenGutter,
                right: GrofastDimenConst.screenGutter,
              ),
              child: AppNetworkImage(url: imageUrl, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: topInset + AppSpacing.base,
            left: GrofastDimenConst.screenGutter,
            right: GrofastDimenConst.screenGutter,
            child: GrofastHeaderRow(
              trailing: GrofastHeaderAction(
                icon: Icons.shopping_bag_rounded,
                onTap: () => context.push(AppRoutes.cart, extra: storeId),
                tooltip: GrofastValueConst.bagTitle,
              ),
            ),
          ),
          Positioned(
            right: GrofastDimenConst.screenGutter,
            bottom: 0,
            child: DecoratedBox(
              // The disc sits half on the arc and half on the page, so it
              // needs its own white ring to stay legible over both.
              decoration: BoxDecoration(
                color: cs.surface,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs3),
                child: GrofastFavouriteHeart(
                  isFavourite: isFavourite,
                  onTap: onFavouriteToggle,
                  size: GrofastDimenConst.detailFavouriteSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsSkeletonBody extends StatelessWidget {
  const _DetailsSkeletonBody();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ShimmerBox(
        width: double.infinity,
        height: GrofastDimenConst.detailImageHeight,
        borderRadius: BorderRadius.zero,
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
  );
}
