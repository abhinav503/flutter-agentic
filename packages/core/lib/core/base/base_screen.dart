import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ui/molecules/bottom_sheet.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  @override
  Widget build(BuildContext context) {
    final style = overlayStyle(context);
    final content = body(context);
    if (style == null) return content;
    return AnnotatedRegion<SystemUiOverlayStyle>(value: style, child: content);
  }

  /// Required: the main content of the screen.
  Widget body(BuildContext context);

  /// Status-bar icon style for this screen — override instead of wrapping
  /// [body] in an `AnnotatedRegion` yourself. `null` (the default) leaves
  /// whatever the route already set.
  ///
  /// Two overrides cover the app: [lightStatusIcons] for a screen whose top
  /// edge is a coloured header canvas, [themedStatusIcons] for one whose top
  /// edge is the plain (theme-following) surface.
  SystemUiOverlayStyle? overlayStyle(BuildContext context) => null;

  /// Light (white) status icons over a coloured header, in both modes.
  static const SystemUiOverlayStyle lightStatusIcons = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  /// Status icons that follow the theme — dark icons on a light surface,
  /// light icons on a dark one.
  static SystemUiOverlayStyle themedStatusIcons(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;

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
    TextStyle? titleStyle,
    Widget? child,
    String? closeLabel,
    TextStyle? closeLabelStyle,
    Color? dividerColor,
    Color? handleColor,
    Size? handleSize,
    Widget? leading,
    bool centerTitle = false,
    double? headerHeight,
    bool showCloseAction = true,
    bool showHeader = true,
    bool? showHandle,
    ShapeBorder? shape,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    double maxHeightFraction = 0.9,
  }) => context.showAppBottomSheet<R>(
    title: title,
    titleStyle: titleStyle,
    child: child ?? buildBottomSheetContent(),
    closeLabel: closeLabel,
    closeLabelStyle: closeLabelStyle,
    dividerColor: dividerColor,
    handleColor: handleColor,
    handleSize: handleSize,
    leading: leading,
    centerTitle: centerTitle,
    headerHeight: headerHeight,
    showCloseAction: showCloseAction,
    showHeader: showHeader,
    showHandle: showHandle,
    shape: shape,
    actions: actions,
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
  }) => context.showSnackBar(message, duration: duration, action: action);

  /// Clears any visible snack bar immediately.
  void clearSnackBar() => context.clearSnackBar();
}

/// The same overlay helpers as [BaseScreenState], reachable from **any**
/// context — a `BasePageState` host (a shell's docked bar), a sheet's own
/// content, a pack helper function. [BaseScreenState] delegates here, so the
/// two can't drift; packs write one `showXSheet` helper on `BuildContext`
/// instead of a twin API per host type.
extension AppOverlaysX on BuildContext {
  /// Shows [AppBottomSheet] — see [BaseScreenState.showAppBottomSheet].
  Future<R?> showAppBottomSheet<R>({
    required Widget child,
    String? title,
    TextStyle? titleStyle,
    String? closeLabel,
    TextStyle? closeLabelStyle,
    Color? dividerColor,
    Color? handleColor,
    Size? handleSize,
    Widget? leading,
    bool centerTitle = false,
    double? headerHeight,
    bool showCloseAction = true,
    bool showHeader = true,
    bool? showHandle,
    ShapeBorder? shape,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    double maxHeightFraction = 0.9,
  }) => AppBottomSheet.show<R>(
    this,
    title: title,
    titleStyle: titleStyle,
    child: child,
    closeLabel: closeLabel,
    closeLabelStyle: closeLabelStyle,
    dividerColor: dividerColor,
    handleColor: handleColor,
    handleSize: handleSize,
    leading: leading,
    centerTitle: centerTitle,
    headerHeight: headerHeight,
    showCloseAction: showCloseAction,
    showHeader: showHeader,
    showHandle: showHandle,
    shape: shape,
    actions: actions,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    maxHeightFraction: maxHeightFraction,
  );

  /// Shows a floating snack bar. Clears any existing snack bar first.
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: duration, action: action),
      );
  }

  /// Clears any visible snack bar immediately.
  void clearSnackBar() => ScaffoldMessenger.of(this).clearSnackBars();
}
