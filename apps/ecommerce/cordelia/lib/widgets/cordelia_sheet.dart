import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';

import 'package:cordelia/feature/auth/presentation/widgets/verify_email_sheet_content.dart';

/// The persistent post-signup/unverified-login verification step — no
/// title/close row, plus `isDismissible`/`enableDrag: false` since this one
/// must not be swipe-or-tap-outside dismissible either. A top-level function
/// (not just the [CordeliaSheetX] extension below) since it has two call
/// sites outside a single `BaseScreenState`: Login/Signup open it right
/// after signing in/up, and `HomePage` (a `BasePageState`, not a
/// `BaseScreenState`) opens it on relaunch to resume a still-unverified
/// session — see `HomePage.buildBlocProviders`.
Future<void> showVerifyEmailSheet({
  required BuildContext context,
  required String email,
  required VoidCallback onResend,
}) => AppBottomSheet.show<void>(
  context,
  // Chromeless: no title row and no close action, because there is no way
  // out of this step but verifying. The handle is kept — it is the only
  // thing that makes the surface read as a sheet without one.
  showHeader: false,
  showHandle: true,
  handleColor: context.appColors.sheetHairline,
  isDismissible: false,
  enableDrag: false,
  child: VerifyEmailSheetContent(email: email, onResend: onResend),
);

/// Convenience for a [BaseScreenState] caller — delegates to the top-level
/// [showVerifyEmailSheet] using `this.context`. Callers close it by popping
/// the root navigator once `AuthBloc` reaches `authenticated`.
extension CordeliaSheetX<T extends BaseScreen> on BaseScreenState<T> {
  Future<void> showVerifyEmailSheetHere({
    required String email,
    required VoidCallback onResend,
  }) =>
      showVerifyEmailSheet(context: context, email: email, onResend: onResend);
}
