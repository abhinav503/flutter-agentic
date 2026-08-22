import 'package:flutter/material.dart';

import 'package:core/core/extensions/num_extensions.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/enums/product_unit_type.dart';
import 'package:cordelia/templates/gravia/constants/gravia_color_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';

import 'gravia_tint_badge.dart';

/// Gravia's one true product card — core's [ProductCard] with the whole pack
/// spec baked in: weight badge on tinted-primary fill, flash/percent meta
/// row, strike-through original price, and the signature CTA rail — pill
/// "Add To Cart" with the glass bag-add quick-add button on its right.
///
/// Every surface that shows a product card (Home rail, Category Details
/// grid, Similar Products rail, Cart's "Before you checkout" rail) renders
/// THIS widget, never a hand-styled [ProductCard] — four call sites styling
/// the card inline is exactly how the CTA rail drifted apart per screen.
///
/// ```dart
/// GraviaProductCard(
///   product: product,
///   width: GraviaProductCard.railWidth, // rails; omit inside a grid cell
///   onAddToCart: () => ...,             // pill CTA — adds 1
///   onQuickAdd: () => ...,              // glass button — quantity sheet
///   onTap: () => ...,                   // open Product Details
/// )
/// ```
class GraviaProductCard extends StatelessWidget {
  /// Card width inside a horizontal rail (grids size cells themselves).
  static const double railWidth = 184;

  final ProductEntity product;
  final VoidCallback onAddToCart;
  final VoidCallback onQuickAdd;
  final VoidCallback? onTap;

  /// Set inside horizontal rails (unbounded width); leave null when the
  /// parent already constrains width (grid cell / `Expanded`).
  final double? width;

  final bool showPrepTime;
  final bool showDiscount;

  /// Discount meta text override — defaults to
  /// [GraviaValueConst.discountPercentLabel] (`20%`); Category Details
  /// passes [GraviaValueConst.discountPercentOffLabel] (`20% OFF`) per its
  /// denser grid spec.
  final String? discountLabel;

  /// Whether the image's top-right favourite toggle is filled. Ignored
  /// (heart hidden entirely) when [onFavouriteToggle] is null — a caller
  /// that has nowhere to persist the toggle just omits it rather than
  /// showing a heart that does nothing.
  final bool isFavourite;
  final VoidCallback? onFavouriteToggle;

  const GraviaProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onQuickAdd,
    this.onTap,
    this.width,
    this.showPrepTime = true,
    this.showDiscount = true,
    this.discountLabel,
    this.isFavourite = false,
    this.onFavouriteToggle,
  });

  /// How far the photo fades once the product is unbuyable — enough to read
  /// as inactive beside an in-stock card in the same rail, not so far the
  /// product stops being recognisable.
  static const double _soldOutImageOpacity = 0.45;

  /// The pack's 14px Gray/500 meta-row glyph (flash, percent, …) — public so
  /// a standalone meta row (same icons, outside a full card) doesn't
  /// re-inline the same size/colour recipe.
  static Widget metaIcon(String asset) => AppSvgImage.asset(
    asset,
    width: AppSpacing.md,
    height: AppSpacing.md,
    color: GraviaColorConst.gray500,
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final onOverlay = context.appColors.onOverlay;
    final soldOut = product.isOutOfStock;

    final image = AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover);

    final card = ProductCard(
      // Faded, not veiled: the pill below already says why, and a scrim
      // over the photo would fight the glass favourite heart sitting on it.
      image: soldOut
          ? Opacity(opacity: _soldOutImageOpacity, child: image)
          : image,
      title: product.name,
      titleStyle: GraviaTextStyleConst.textMdBold(tt),
      badgeLabel: product.unitType.format(product.unitValue),
      badgeLabelStyle: GraviaTintBadge.labelStyle(context),
      badgeBackgroundColor: GraviaTintBadge.backgroundColor(context),
      meta: [
        if (showPrepTime)
          ProductCardMeta(
            icon: metaIcon(GraviaImageConst.flash),
            label: product.prepTime,
          ),
        // Running low takes the discount's slot rather than adding a third
        // meta item: at 184 wide the row fits two, and "nearly gone" is the
        // more useful of the two things to know.
        if (product.isLowStock)
          ProductCardMeta(
            icon: metaIcon(GraviaImageConst.flash),
            label: ValueConst.onlyNLeftLabel(product.stock!),
            labelColor: cs.error,
          )
        else if (showDiscount)
          ProductCardMeta(
            icon: metaIcon(GraviaImageConst.badgePercent),
            label:
                discountLabel ??
                GraviaValueConst.discountPercentLabel(
                  product.discountPercentage,
                ),
          ),
      ],
      metaLabelStyle: GraviaTextStyleConst.textXsRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      price: product.price.asPrice,
      originalPrice: product.originalPrice.asPrice,
      actionLabel: soldOut
          ? ValueConst.outOfStockLabel
          : GraviaValueConst.addToCart,
      // The onOverlay pin is dropped while sold out: a pinned label colour
      // outranks AppButton's disabled ink, so keeping it would print white
      // text on the disabled fill.
      actionLabelStyle: soldOut
          ? GraviaTextStyleConst.textSmMedium(tt)
          : GraviaTextStyleConst.textSmMedium(tt).copyWith(color: onOverlay),
      onAction: soldOut ? null : onAddToCart,
      actionState: soldOut ? AppButtonState.disabled : AppButtonState.idle,
      // The quick-add sheet is dropped rather than disabled — a quantity
      // picker for a product with no units left has nothing to pick.
      trailingAction: soldOut
          ? null
          : AppIconButton(
              variant: AppIconButtonVariant.glass,
              containerSize: AppSpacing.xl6,
              iconSize: AppSpacing.lg,
              glassHighlightThickness: AppSpacing.xs3,
              glassBlurSigma: AppSpacing.xs4,
              iconBuilder: (color, size) => AppSvgImage.asset(
                GraviaImageConst.bagAdd,
                color: color,
                width: size,
                height: size,
              ),
              onTap: onQuickAdd,
            ),
      favouriteAction: onFavouriteToggle == null
          ? null
          : AppIconButton(
              variant: AppIconButtonVariant.glass,
              containerSize: AppSpacing.xl6,
              iconSize: AppSpacing.lg,
              glassHighlightThickness: AppSpacing.xs3,
              glassBlurSigma: AppSpacing.xs4,
              iconBuilder: (color, size) => AppSvgImage.asset(
                isFavourite
                    ? GraviaImageConst.favouriteFilled
                    : GraviaImageConst.navFavourite,
                color: color,
                width: size,
                height: size,
              ),
              onTap: onFavouriteToggle,
            ),
      onTap: onTap,
    );

    return width == null ? card : SizedBox(width: width, child: card);
  }
}
