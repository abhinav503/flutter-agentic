import 'package:flutter/material.dart';

import 'package:core/core/base/base_screen.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/molecules/bottom_sheet.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

import 'grofast_confirm_sheet_content.dart';
import 'grofast_dome.dart';

/// Every overlay in this pack is the same domed sheet (spec sheet §9) — the
/// only axes that vary are whether it carries a title and whether it can be
/// dismissed. These two helpers are the only ways to open one.
///
/// The dome and its floating drag handle are one [GrofastDomeSheetBorder],
/// which `AppBottomSheet` both fills and clips to, so the content only has to
/// stay clear of [GrofastSheetMetrics.contentTop]. Everything else — keyboard
/// padding, max height, the bottom device inset — still comes from core.
extension GrofastSheetX<T extends BaseScreen> on BaseScreenState<T> {
  Future<R?> showGrofastSheet<R>({
    String? title,
    required Widget child,
    bool isDismissible = true,
  }) {
    final tt = Theme.of(context).textTheme;

    return showAppBottomSheet<R>(
      // Chromeless: the arc leaves no room for a pinned header row, so the
      // pack draws its own start-aligned title inside the content instead.
      showHeader: false,
      shape: const GrofastDomeSheetBorder(),
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          GrofastDimenConst.screenGutter,
          GrofastSheetMetrics.contentTop,
          GrofastDimenConst.screenGutter,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(title, style: GrofastTextStyleConst.subheadBold(tt)),
              const SizedBox(height: AppSpacing.lg),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// The destructive-confirmation sheet — the same dome, presented as a
/// top-level function rather than another [GrofastSheetX] method so a
/// `BasePageState` host (the shell's log-out row) can open it too.
///
/// [onConfirm] runs the action; the sheet only gates the tap.
Future<void> showGrofastConfirmSheet({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required VoidCallback onConfirm,
  String? cancelLabel,
}) => AppBottomSheet.show<void>(
  context,
  showHeader: false,
  shape: const GrofastDomeSheetBorder(),
  child: GrofastConfirmSheetContent(
    title: title,
    message: message,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
    onConfirm: onConfirm,
  ),
);

/// The terminal confirmation the kit calls "Success!" — the same dome, with
/// nothing to cancel: no handle drag, no barrier dismiss, and one CTA out.
///
/// Returns once that CTA is tapped, so the caller owns where the shopper
/// lands next.
Future<void> showGrofastSuccessSheet({
  required BuildContext context,
  required Widget child,
}) => AppBottomSheet.show<void>(
  context,
  showHeader: false,
  shape: const GrofastDomeSheetBorder(),
  isDismissible: false,
  enableDrag: false,
  child: child,
);
