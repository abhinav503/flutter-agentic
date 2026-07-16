import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';

import 'add_to_cart_sheet_content.dart';

/// Gravia-styled wrappers around [BaseScreenState.showAppBottomSheet] — the
/// pack's one sheet chrome (textLg/bold title, primary "Cancel" close
/// action, kit hairline divider + handle) lives here instead of a re-typed
/// styling recipe in every screen that opens a sheet.
extension GraviaSheetX<T extends BaseScreen> on BaseScreenState<T> {
  Future<R?> showGraviaSheet<R>({
    required String title,
    required Widget child,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hairline = cs.sheetHairline;

    return showAppBottomSheet<R>(
      title: title,
      titleStyle: TextStyleConst.textLgBold(tt),
      closeLabel: ValueConst.cancel,
      closeLabelStyle: TextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.primary),
      dividerColor: hairline,
      handleColor: hairline,
      child: child,
    );
  }

  /// The quantity-picking add-to-cart sheet every product surface opens from
  /// its glass quick-add button. [onAddToCart] receives the product back
  /// with the chosen quantity — screens pass their own `_addToCart`.
  Future<void> showGraviaAddToCartSheet({
    required ProductEntity product,
    required void Function(ProductEntity product, int quantity) onAddToCart,
  }) => showGraviaSheet(
    title: ValueConst.addToCartSheetTitle,
    child: AddToCartSheetContent(
      product: product,
      onAddToCart: (quantity) => onAddToCart(product, quantity),
    ),
  );
}
