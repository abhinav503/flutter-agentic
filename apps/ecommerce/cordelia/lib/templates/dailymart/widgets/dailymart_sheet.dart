import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_shapes_extension.dart';

import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_dimen_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_value_const.dart';

import 'dailymart_add_to_cart_sheet_content.dart';
import 'dailymart_confirm_sheet_content.dart';
import 'dailymart_icon_disc.dart';

/// DailyMart's destructive-confirmation sheet — [DailyMartConfirmSheetContent]
/// presented chrome-free, bypassing [DailyMartSheetX.showDailyMartSheet]
/// because the content carries its own centred title and its two CTAs are
/// the only exits (spec sheet §9/§13).
///
/// A top-level function rather than another [DailyMartSheetX] method so a
/// `BasePageState` host can open it too, same reasoning as
/// `showGraviaConfirmSheet`. [onConfirm] runs the action; the sheet only
/// gates the tap.
Future<void> showDailyMartConfirmSheet({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
}) {
  final cs = Theme.of(context).colorScheme;
  final sheetRadius =
      (Theme.of(context).extension<AppShapes>() ?? AppShapes.standard)
          .sheetRadius;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: cs.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(sheetRadius)),
    ),
    builder: (_) => DailyMartConfirmSheetContent(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      onConfirm: onConfirm,
    ),
  );
}

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
    final hairline = context.appColors.sheetHairline;

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
}
