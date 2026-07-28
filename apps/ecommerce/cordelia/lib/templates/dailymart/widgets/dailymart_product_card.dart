import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

/// DailyMart's one true product card. Every surface that shows a product
/// renders THIS widget, never a hand-styled composition — four call sites
/// styling a card inline is exactly how gravia's CTA rail drifted per screen.
///
/// Deliberately **not** built on `core`'s `blocks/ecommerce/product_card.dart`:
/// that block is square-image → badge → title → meta → price → full-width
/// pill CTA, while this pack's card is a fixed-height image well with corner
/// overlays → name+price beside a circular add button → rating row. The
/// element order and the CTA shape both differ, so bending the block into
/// this would mean overriding every slot (see spec sheet §12 — recorded so
/// nobody "fixes" it back).
class DailyMartProductCard extends StatelessWidget {
  final ProductEntity product;

  /// Adds one unit straight to the cart — the green **+** disc. This pack has
  /// no quantity sheet on the card (that lives on Product Details).
  final VoidCallback onAdd;
  final VoidCallback? onTap;

  /// Omit to hide the heart entirely rather than show one that does nothing.
  final bool isFavourite;
  final VoidCallback? onFavouriteToggle;

  const DailyMartProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    this.onTap,
    this.isFavourite = false,
    this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;

    // Shadow on the outer box, surface inside it: a `boxShadow` declared on a
    // child of the Material paints *after* the white fill, so the two have to
    // be in this order. Shadow, not a lighter fill — on the mint canvas there
    // is nothing lighter than white to step up to (spec sheet §6).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(shapes.cardRadius),
        boxShadow: DailyMartElevation.card,
      ),
      child: Material(
        color: cs.surface,
        borderRadius: BorderRadius.circular(shapes.cardRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(shapes.cardRadius),
          child: Padding(
            // The image well insets 2px inside the card, which is why its
            // own radius is 2 less than the card's.
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs4,
              AppSpacing.xs4,
              AppSpacing.xs4,
              AppSpacing.xs2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _ImageWell(
                  product: product,
                  isFavourite: isFavourite,
                  onFavouriteToggle: onFavouriteToggle,
                  radius: shapes.cardRadius - AppSpacing.xs4,
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.name,
                                  style:
                                      DailyMartTextStyleConst.bodySmSemibold(
                                        tt,
                                      ).copyWith(color: cs.onSurface),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppSpacing.xs4),
                                Text(
                                  DailyMartValueConst.formattedPrice(
                                    product.price,
                                  ),
                                  style:
                                      DailyMartTextStyleConst.bodySmSemibold(
                                        tt,
                                      ).copyWith(color: cs.onSurface),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          _AddButton(onTap: onAdd),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs3),
                      const _RatingRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageWell extends StatelessWidget {
  final ProductEntity product;
  final bool isFavourite;
  final VoidCallback? onFavouriteToggle;
  final double radius;

  const _ImageWell({
    required this.product,
    required this.isFavourite,
    required this.onFavouriteToggle,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: DailyMartDimenConst.productImageHeight,
        width: double.infinity,
        // Cool tint behind the photo so produce reads warm against it.
        color: cs.surfaceContainerHighest,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.discountPercentage > 0)
                    _DiscountPill(percentage: product.discountPercentage),
                  const Spacer(),
                  if (onFavouriteToggle != null)
                    _FavouriteDisc(
                      isFavourite: isFavourite,
                      onTap: onFavouriteToggle!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscountPill extends StatelessWidget {
  final double percentage;

  const _DiscountPill({required this.percentage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.xs3,
      ),
      decoration: BoxDecoration(color: cs.error, borderRadius: AppRadius.full),
      child: Text(
        DailyMartValueConst.discountPercentOffLabel(percentage),
        style: DailyMartTextStyleConst.bodyXsSemibold(
          tt,
        ).copyWith(color: cs.onError),
      ),
    );
  }
}

class _FavouriteDisc extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onTap;

  const _FavouriteDisc({required this.isFavourite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: DailyMartDimenConst.cardActionSize,
          child: Center(
            // One glyph for both states, tinted: the kit exports only the
            // outline heart, so favouriting is marked by colour rather than
            // by swapping in a filled counterpart that doesn't exist.
            child: AppSvgImage.asset(
              DailyMartImageConst.heart,
              width: AppSpacing.lg,
              height: AppSpacing.lg,
              color: isFavourite ? cs.error : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox.square(
          dimension: DailyMartDimenConst.cardActionSize,
          child: Icon(
            Icons.add_rounded,
            size: AppSpacing.xl2,
            color: cs.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// The kit's amber star + `4.9 (345)`. Both values are static placeholder
/// copy — see [DailyMartValueConst.staticRatingLabel] for why, and for what
/// to change when reviews reach `ProductEntity`. The row always renders: the
/// kit's card is laid out around it, and showing it on some cards and not
/// others would ripple a height change through the grid.
class _RatingRow extends StatelessWidget {
  const _RatingRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        AppSvgImage.asset(
          DailyMartImageConst.star,
          width: AppSpacing.md,
          height: AppSpacing.md,
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
    );
  }
}
