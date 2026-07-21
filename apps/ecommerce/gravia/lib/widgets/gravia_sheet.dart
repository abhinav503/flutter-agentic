import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:gravia/constants/color_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/feature/address/presentation/widgets/delete_address_sheet_content.dart';
import 'package:gravia/feature/auth/presentation/widgets/verify_email_sheet_content.dart';
import 'package:gravia/feature/home/domain/entities/product_entity.dart';

import 'add_to_cart_sheet_content.dart';
import 'order_placed_sheet_content.dart';

/// The persistent post-signup/unverified-login verification step — no
/// title/close row, same bypass reasoning as [GraviaSheetX.showOrderPlacedSheet],
/// plus `isDismissible`/`enableDrag: false` since this one must not be
/// swipe-or-tap-outside dismissible either. A top-level function (not just
/// the [GraviaSheetX] extension below) since it has two call sites outside
/// a single `BaseScreenState`: Login/Signup open it right after signing
/// in/up, and `ShellPage` (a `BasePageState`, not a `BaseScreenState`) opens
/// it on relaunch to resume a still-unverified session — see
/// `ShellPage.buildBlocProviders`.
Future<void> showVerifyEmailSheet({
  required BuildContext context,
  required String email,
  required VoidCallback onResend,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  isDismissible: false,
  enableDrag: false,
  backgroundColor: Colors.transparent,
  builder: (_) => VerifyEmailSheetContent(email: email, onResend: onResend),
);

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

  /// The delete-confirmation sheet opened from [AddressCard]'s Delete
  /// action. [onConfirm] dispatches the actual delete — the sheet itself
  /// only gates the tap, it never touches the bloc.
  Future<void> showGraviaDeleteAddressSheet({required VoidCallback onConfirm}) =>
      showGraviaSheet(
        title: ValueConst.deleteAddressTitle,
        child: DeleteAddressSheetContent(onConfirm: onConfirm),
      );

  /// The checkout confirmation sheet — bypasses [showGraviaSheet] since
  /// [OrderPlacedSheetContent] has no title row or close control to render;
  /// presented directly via `showModalBottomSheet` instead.
  Future<void> showOrderPlacedSheet({required VoidCallback onTrackOrder}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => OrderPlacedSheetContent(
          onTrackOrder: () {
            Navigator.of(sheetContext).pop();
            onTrackOrder();
          },
        ),
      );

  /// Convenience for a [BaseScreenState] caller — delegates to the top-level
  /// [showVerifyEmailSheet] using `this.context`. Callers close it by
  /// popping the root navigator once `AuthBloc` reaches `authenticated`.
  Future<void> showVerifyEmailSheetHere({
    required String email,
    required VoidCallback onResend,
  }) =>
      showVerifyEmailSheet(context: context, email: email, onResend: onResend);
}
