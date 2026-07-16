import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_shapes_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// Persistent "cart isn't empty" indicator docked above the bottom nav on
/// the Home/Categories tabs — lives inside [ShellPage]'s own body (not a
/// `ScaffoldMessenger` `SnackBar`, which would float above every pushed
/// route including Cart itself and can only host a text action, not real
/// icon buttons). Rendered by the caller only while the shared cart is
/// non-empty.
///
/// Layout: a cart icon, a "See more products"/"Explore" text block, the
/// item-count-and-total pill that opens Cart, then a separate delete pill
/// (same tinted-error styling as `AddressCard`'s Delete) that empties the
/// cart without opening it.
class CartStatusBar extends StatelessWidget {
  final int itemCount;
  final double grandTotal;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const CartStatusBar({
    super.key,
    required this.itemCount,
    required this.grandTotal,
    required this.onTap,
    required this.onClear,
  });

  static const _iconCircleSize = 44.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;
    final shapes =
        Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    // Same icon-circle convention as ProfileMenuTile — Gray/50 light /
    // Gray/950 dark — not a primary-tinted circle invented for this bar.
    final iconCircleColor = isDark ? ColorConst.gray950 : ColorConst.gray50;

    // No SafeArea here — unlike a docked bottom bar that IS the screen's
    // last widget, this sits above ShellPage's own BottomNavBar, which
    // already applies its own SafeArea for the device's bottom inset.
    // Adding one here would double that inset into an unwanted gap.
    //
    // No border either — BottomNavBar's own topBorderColor already draws
    // the hairline between it and this bar. Just the sheet-radius top
    // corners so this reads as a rounded card docked on the nav bar, not a
    // flush continuation of it.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(shapes.sheetRadius),
          topRight: Radius.circular(shapes.sheetRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.base,
        ),

        child: Row(
          children: [
            Container(
              width: _iconCircleSize,
              height: _iconCircleSize,
              decoration: BoxDecoration(
                color: iconCircleColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: AppSvgImage.asset(
                ImageConst.cart,
                color: cs.onSurface,
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ValueConst.cartBarTitle,
                      style: TextStyleConst.textSmMedium(
                        tt,
                      ).copyWith(color: cs.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ValueConst.exploreLabel,
                      style: TextStyleConst.textXsRegular(tt).copyWith(
                        color: cs.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(shapes.buttonRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ValueConst.cartSummaryLabel(itemCount, grandTotal),
                      style: TextStyleConst.textXsRegular(
                        tt,
                      ).copyWith(color: onOverlay),
                    ),
                    Text(
                      ValueConst.checkoutLabel,
                      style: TextStyleConst.textSmMedium(
                        tt,
                      ).copyWith(color: onOverlay),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            _ClearCartButton(onTap: onClear),
          ],
        ),
      ),
    );
  }
}

/// Same tinted-error styling as `AddressCard`'s `_DeleteButton`, but
/// icon-only (circular) rather than a labelled pill — this sits beside a
/// dense status bar, not a full-width action row.
class _ClearCartButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearCartButton({required this.onTap});

  static const _size = 44.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        color: cs.tintedErrorFill,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: AppSvgImage.asset(
              ImageConst.trash,
              color: ColorConst.error500,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
