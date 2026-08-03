import 'package:flutter/material.dart';

import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_image_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

import 'grofast_price.dart';

/// GROFAST's one true product card. Every surface that shows a product
/// renders THIS widget, never a hand-styled composition.
///
/// The composition (spec sheet §10): a tinted card at radius 28, its image
/// well filling the top, the favourite heart floating on the top-right, the
/// name and split price bottom-left, and the **add button welded into the
/// bottom-right corner** — sharing the card's 28 radius on that corner and
/// rounding its top-left by 15, so it reads as a piece cut out of the card
/// rather than a button placed on it. That corner button is the pack's
/// single most recognisable element.
///
/// Deliberately **not** built on `core`'s `blocks/ecommerce/product_card.dart`
/// (badge → title → meta → price → full-width pill CTA): every slot would
/// have to be overridden, and the corner button has no equivalent there
/// (spec sheet §12 — recorded so nobody "fixes" it back).
class GrofastProductCard extends StatelessWidget {
  final ProductEntity product;

  /// Adds one unit straight to the bag — the corner **+**. This pack has no
  /// quantity sheet on the card; that lives on Product Details.
  final VoidCallback onAdd;
  final VoidCallback? onTap;

  final bool isFavourite;

  /// Omit to hide the heart entirely rather than show one that does nothing.
  final VoidCallback? onFavouriteToggle;

  /// The kit's grid gives its first cell a shorter card, which is what
  /// staggers the two columns — see `GrofastProductGrid`.
  final double height;

  const GrofastProductCard({
    super.key,
    required this.product,
    required this.onAdd,
    this.onTap,
    this.isFavourite = false,
    this.onFavouriteToggle,
    this.height = GrofastDimenConst.productCardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.appShapes.cardRadius);

    return SizedBox(
      height: height,
      child: Material(
        color: cs.surfaceContainerLow,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: InkWell(
                onTap: onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height:
                          height - GrofastDimenConst.productCardChromeHeight,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          GrofastDimenConst.productImageInset,
                        ),
                        child: AppNetworkImage(
                          url: product.imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GrofastTextStyleConst.cardTitleBold(tt),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          GrofastPrice(
                            value: product.price,
                            unit: product.unitType.pricePerLabel(product.unitValue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _AddButton(onTap: onAdd, cardRadius: radius.bottomRight),
            ),
            if (onFavouriteToggle != null)
              Positioned(
                top: GrofastDimenConst.productHeartInset,
                right: GrofastDimenConst.productHeartInset,
                child: GrofastFavouriteHeart(
                  isFavourite: isFavourite,
                  onTap: onFavouriteToggle!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The corner add-to-bag control. Not an [AppButton]: it is a notched shape
/// welded into the card, with no label and no pill radius.
class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  final Radius cardRadius;

  const _AddButton({required this.onTap, required this.cardRadius});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: GrofastValueConst.addToBagTooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: GrofastDimenConst.productAddButtonWidth,
          height: GrofastDimenConst.productAddButtonHeight,
          decoration: BoxDecoration(
            gradient: GrofastColorConst.brandGradient,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(
                GrofastDimenConst.productAddButtonNotchRadius,
              ),
              bottomRight: cardRadius,
            ),
          ),
          alignment: Alignment.center,
          child: AppSvgImage.asset(
            GrofastImageConst.plus,
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            color: cs.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// The floating favourite heart used on cards and on Product Details.
///
/// The kit draws it as two concentric circles — a Ø20 disc inside a Ø25 one —
/// and the *outer* circle only appears once saved, as a ring:
///
/// | | Ø25 outer | Ø20 inner | glyph |
/// |---|---|---|---|
/// | not saved | nothing | white disc | `cs.error` |
/// | saved | `cs.error` hairline **ring** at 15%, no fill | `cs.error` disc | white |
///
/// So saving doesn't just recolour the disc, it grows a detached ring around
/// it with the card showing through the gap — measured off the kit's two card
/// variants (`Card/Product/Tall` and `-favorite-disabled`), which differ in
/// exactly this. The Ø25 box is kept in both states so the tap target and the
/// card's layout don't move when it toggles.
class GrofastFavouriteHeart extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onTap;
  final double size;

  const GrofastFavouriteHeart({
    super.key,
    required this.isFavourite,
    required this.onTap,
    this.size = GrofastDimenConst.productHeartSize,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Both circles are fractions of the outer box, so a caller that scales the
    // control (Product Details' 56) keeps the kit's proportions: 20.2 of 25,
    // and an 8.1 glyph inside that.
    final innerSize = size * 0.81;

    return Semantics(
      button: true,
      selected: isFavourite,
      label: GrofastValueConst.favouriteTooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // A whisper, not a stroke — the kit's ring measures ~15% of the
            // ink a full hairline would lay down, and reads as a halo rather
            // than a second outline around the disc.
            border: isFavourite
                ? Border.all(
                    color: cs.error.withValues(
                      alpha: GrofastDimenConst.favouriteRingOpacity,
                    ),
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              color: isFavourite ? cs.error : cs.surface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AppSvgImage.asset(
              GrofastImageConst.heart,
              width: innerSize * 0.4,
              height: innerSize * 0.4,
              color: isFavourite ? cs.onError : cs.error,
            ),
          ),
        ),
      ),
    );
  }
}
