import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/network_image.dart';
import 'package:core/core/ui/atoms/svg_image.dart';
import 'package:core/core/ui/blocks/ecommerce/product_card.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/enums/product_unit_type.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';
import 'package:gravia/widgets/gravia_tint_badge.dart';

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
  /// [ValueConst.discountPercentLabel] (`20%`); Category Details passes
  /// [ValueConst.discountPercentOffLabel] (`20% OFF`) per its denser grid
  /// spec.
  final String? discountLabel;

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
  });

  /// The pack's 14px Gray/500 meta-row glyph (flash, percent, …) — public so
  /// [ProductDetailsScreen]'s standalone meta row (same icons, outside a
  /// full card) doesn't re-inline the same size/colour recipe.
  static Widget metaIcon(String asset) => AppSvgImage.asset(
    asset,
    width: 14,
    height: 14,
    color: ColorConst.gray500,
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    final card = ProductCard(
      image: AppNetworkImage(url: product.imageUrl, fit: BoxFit.cover),
      title: product.name,
      titleStyle: TextStyleConst.textMdBold(tt),
      badgeLabel: product.unitType.format(product.unitValue),
      badgeLabelStyle: GraviaTintBadge.labelStyle(context),
      badgeBackgroundColor: GraviaTintBadge.backgroundColor(context),
      meta: [
        if (showPrepTime)
          ProductCardMeta(
            icon: metaIcon(ImageConst.flash),
            label: product.prepTime,
          ),
        if (showDiscount)
          ProductCardMeta(
            icon: metaIcon(ImageConst.badgePercent),
            label:
                discountLabel ??
                ValueConst.discountPercentLabel(product.discountPercentage),
          ),
      ],
      metaLabelStyle: TextStyleConst.textXsRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      price: ValueConst.formattedPrice(product.price),
      originalPrice: ValueConst.formattedPrice(product.originalPrice),
      actionLabel: ValueConst.addToCart,
      actionLabelStyle: TextStyleConst.textSmMedium(
        tt,
      ).copyWith(color: onOverlay),
      onAction: onAddToCart,
      trailingAction: AppIconButton(
        variant: AppIconButtonVariant.glass,
        containerSize: AppSpacing.xl6,
        iconSize: AppSpacing.lg,
        glassHighlightThickness: AppSpacing.xs3,
        glassBlurSigma: AppSpacing.xs4,
        iconBuilder: (color, size) => AppSvgImage.asset(
          ImageConst.bagAdd,
          color: color,
          width: size,
          height: size,
        ),
        onTap: onQuickAdd,
      ),
      onTap: onTap,
    );

    return width == null ? card : SizedBox(width: width, child: card);
  }
}
