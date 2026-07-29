import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import 'dailymart_add_to_cart_sheet_content.dart';
import 'dailymart_icon_disc.dart';
import 'dailymart_order_placed_sheet_content.dart';

/// The DailyMart sheet chrome (kit Filter frame `21`): 24px top radius from
/// the theme's sheet shape, a 64 × 5 hairline drag handle, a 48px close
/// disc on the **left** and the Heading/H5 title centred against the sheet —
/// spec sheet §9/§13. One recipe here instead of a re-typed styling quartet
/// in every screen that opens a sheet.
extension DailyMartSheetX<T extends BaseScreen> on BaseScreenState<T> {
  Future<R?> showDailyMartSheet<R>({
    required String title,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline =
        Theme.of(context).extension<AppColorsExtension>()!.sheetHairline;

    return showAppBottomSheet<R>(
      title: title,
      titleStyle: DailyMartTextStyleConst.headingH5(
        tt,
      ).copyWith(color: cs.onSurface),
      centerTitle: true,
      // The pack closes with a leading disc, not a trailing X/Cancel —
      // `showCloseAction: false` suppresses the default trailing X so the
      // sheet doesn't grow two competing exits. Popping through the
      // screen's context targets the same navigator the sheet was pushed
      // on.
      leading: DailyMartIconDisc(
        icon: Icons.close_rounded,
        // The preset maps sheet-close discs one ramp step lighter than the
        // back disc.
        backgroundColor: cs.surfaceContainerLow,
        onTap: () => Navigator.of(context).pop(),
      ),
      showCloseAction: false,
      headerHeight: DailyMartDimenConst.sheetHeaderHeight,
      handleSize: const Size(
        DailyMartDimenConst.sheetHandleWidth,
        DailyMartDimenConst.sheetHandleHeight,
      ),
      handleColor: hairline,
      // The kit draws no hairline under the sheet title — the handle and
      // the centred H5 are the whole header.
      dividerColor: Colors.transparent,
      child: child,
    );
  }

  /// The quantity-picking add-to-cart sheet. [onAddToCart] receives the
  /// product back with the chosen quantity — screens pass their own
  /// `_addToCart`.
  Future<void> showDailyMartAddToCartSheet({
    required ProductEntity product,
    required void Function(ProductEntity product, int quantity) onAddToCart,
  }) => showDailyMartSheet(
    title: DailyMartValueConst.addToCartSheetTitle,
    child: DailyMartAddToCartSheetContent(
      product: product,
      onAddToCart: (quantity) => onAddToCart(product, quantity),
    ),
  );

  /// The checkout-success sheet. [onContinue] runs once the sheet has
  /// closed — through the CTA, the close disc, the barrier, or a drag —
  /// so no dismissal path strands the shopper on the now-empty cart.
  Future<void> showDailyMartOrderPlacedSheet({
    required VoidCallback onContinue,
  }) async {
    await showDailyMartSheet<void>(
      title: DailyMartValueConst.orderPlacedTitle,
      child: Builder(
        builder: (sheetContext) => DailyMartOrderPlacedSheetContent(
          onContinue: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    );
    if (context.mounted) onContinue();
  }
}
