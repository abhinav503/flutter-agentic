import 'package:flutter/material.dart';

import '../ui/molecules/bottom_sheet.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  @override
  Widget build(BuildContext context) => body(context);

  /// Required: the main content of the screen.
  Widget body(BuildContext context);

  // ── Bottom sheet ───────────────────────────────────────────────────────────

  /// Shows [AppBottomSheet] without needing to import it in every screen.
  ///
  /// Override [buildBottomSheetContent] to return content driven by the
  /// screen's own state, or pass [child] directly for one-off sheets.
  ///
  /// ```dart
  /// // One-off — pass child directly:
  /// showAppBottomSheet(title: 'Detail', child: DetailWidget());
  ///
  /// // State-driven — override buildBottomSheetContent and call:
  /// showAppBottomSheet(title: 'Options');
  /// ```
  Future<R?> showAppBottomSheet<R>({
    String? title,
    Widget? child,
    bool isDismissible = true,
    bool enableDrag = true,
    double maxHeightFraction = 0.9,
  }) =>
      AppBottomSheet.show<R>(
        context,
        title: title,
        child: child ?? buildBottomSheetContent(),
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        maxHeightFraction: maxHeightFraction,
      );

  /// Override to provide bottom sheet content driven by the screen's state.
  /// Used when [showAppBottomSheet] is called without an explicit [child].
  Widget buildBottomSheetContent() => const SizedBox.shrink();

  // ── Snack bar ──────────────────────────────────────────────────────────────

  /// Shows a floating snack bar. Clears any existing snack bar first.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
        ),
      );
  }

  /// Clears any visible snack bar immediately.
  void clearSnackBar() => ScaffoldMessenger.of(context).clearSnackBars();
}
