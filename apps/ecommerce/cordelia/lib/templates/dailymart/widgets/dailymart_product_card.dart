import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/surface_card.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_image_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_icon_disc.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_pill.dart';

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
  /// How far the photo fades once the product is unbuyable — public so the
  /// pack's list tile fades by the same amount as its card.
  static const double soldOutImageOpacity = 0.45;

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
    final shapes = context.appShapes;
    final soldOut = product.isOutOfStock;

    // Shadow, not a lighter fill — on the mint canvas there is nothing
    // lighter than white to step up to (spec sheet §6). The shadow-under-fill
    // ordering it needs is [AppSurfaceCard]'s whole reason for existing.
    return AppSurfaceCard(
      color: cs.surface,
      borderRadius: BorderRadius.circular(shapes.cardRadius),
      shadows: DailyMartElevation.card,
      onTap: onTap,
      // The kit's price row can overhang; the card never clipped before.
      clipBehavior: Clip.none,
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
              soldOut: soldOut,
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs2),
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
                              style: DailyMartTextStyleConst.bodySmSemibold(
                                tt,
                              ).copyWith(color: cs.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs4),
                            Text(
                              product.price.asPrice,
                              style: DailyMartTextStyleConst.bodySmSemibold(
                                tt,
                              ).copyWith(color: cs.onSurface),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _AddButton(onTap: soldOut ? null : onAdd),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs3),
                  _RatingRow(product: product),
                ],
              ),
            ),
          ],
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
  final bool soldOut;

  const _ImageWell({
    required this.product,
    required this.isFavourite,
    required this.onFavouriteToggle,
    required this.radius,
    required this.soldOut,
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
            // Faded rather than scrimmed — the pill on top of it says why,
            // and a scrim would darken the white favourite disc beside it.
            Opacity(
              opacity: soldOut ? DailyMartProductCard.soldOutImageOpacity : 1,
              child: AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // One pill, one corner: availability is the news when
                  // there is any, so it takes the slot rather than stacking
                  // a second pill into a 2-column grid cell.
                  if (soldOut)
                    DailyMartPill(
                      label: ValueConst.outOfStockLabel,
                      color: cs.onSurface,
                      style: DailyMartTextStyleConst.bodyXsSemibold(
                        Theme.of(context).textTheme,
                      ).copyWith(color: cs.surface),
                    )
                  // Running low outranks the discount for the same slot: a
                  // shopper can act on "nearly gone", and the price is right
                  // below it either way.
                  else if (product.isLowStock)
                    DailyMartPill(
                      label: ValueConst.onlyNLeftLabel(product.stock!),
                      color: cs.error,
                      style: DailyMartTextStyleConst.bodyXsSemibold(
                        Theme.of(context).textTheme,
                      ).copyWith(color: cs.onError),
                    )
                  else if (product.discountPercentage > 0)
                    DailyMartPill(
                      label: DailyMartValueConst.discountPercentOffLabel(
                        product.discountPercentage,
                      ),
                      color: cs.error,
                      style: DailyMartTextStyleConst.bodyXsSemibold(
                        Theme.of(context).textTheme,
                      ).copyWith(color: cs.onError),
                    ),
                  const Spacer(),
                  if (onFavouriteToggle != null)
                    DailyMartIconDisc(
                      asset: isFavourite
                          ? DailyMartImageConst.heartFilled
                          : DailyMartImageConst.heart,
                      onTap: onFavouriteToggle,
                      size: DailyMartDimenConst.cardActionSize,
                      iconSize: AppSpacing.lg,
                      backgroundColor: cs.surface,
                      foregroundColor: isFavourite ? cs.primary : cs.onSurface,
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

class _AddButton extends StatelessWidget {
  /// Null while the product is sold out — the disc stays in place (the row
  /// is laid out around it) but greys out and stops responding.
  final VoidCallback? onTap;

  const _AddButton({required this.onTap});

  /// Matches the composed kit export this replaced: a 16-span glyph in the
  /// 28 disc (the kit's 14/24 glyph-to-disc ratio).
  static const double _glyphSize = 16;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final enabled = onTap != null;

    return DailyMartIconDisc(
      asset: DailyMartImageConst.plus,
      onTap: onTap,
      size: DailyMartDimenConst.cardActionSize,
      iconSize: _glyphSize,
      backgroundColor: enabled
          ? cs.primary
          : cs.onSurface.withValues(alpha: 0.12),
      foregroundColor: enabled
          ? cs.onPrimary
          : cs.onSurface.withValues(alpha: 0.38),
    );
  }
}

/// The kit's amber star + the product's rating. The row always renders,
/// unrated products included: the kit's card is laid out around it, and
/// showing it on some cards and not others would ripple a height change
/// through the grid. An unrated product greys the star and says so rather
/// than printing 0.0, which would read as a badly-reviewed product.
class _RatingRow extends StatelessWidget {
  final ProductEntity product;

  const _RatingRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final rated = product.hasRating;

    return Row(
      children: [
        AppSvgImage.asset(
          DailyMartImageConst.star,
          width: AppSpacing.md,
          height: AppSpacing.md,
          color: rated
              ? DailyMartColorConst.ratingStar
              : cs.surfaceContainerHighest,
        ),
        const SizedBox(width: AppSpacing.xs3),
        Expanded(
          child: Text(
            rated
                ? ValueConst.ratingLabel(
                    product.ratingAverage,
                    product.reviewCount,
                  )
                : ValueConst.unratedLabel,
            style: DailyMartTextStyleConst.bodyXsMedium(
              tt,
            ).copyWith(color: rated ? cs.onSurface : cs.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
