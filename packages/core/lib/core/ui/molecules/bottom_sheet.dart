import 'package:flutter/material.dart';

import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shapes_extension.dart';
import '../../../core/theme/app_spacing.dart';

/// Bottom sheet with an optional pinned header and a scrollable body.
///
/// Use [AppBottomSheet.show] to present it:
///
/// ```dart
/// AppBottomSheet.show(
///   context,
///   title: 'Filter',
///   child: FilterOptions(),
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;

  /// Overrides the title's text style — for a caller whose spec calls out
  /// exact typography (e.g. `gravia`'s Text/lg/bold) rather than the
  /// theme's `titleMedium` role. Omit (default) to use the role.
  final TextStyle? titleStyle;
  final VoidCallback? onClose;

  /// Renders the header's close action as a text button with this label
  /// (in `cs.primary`) instead of the default `X` icon — for style packs
  /// whose spec calls for a "Cancel" link (e.g. `gravia`). Ignored if
  /// [onClose] is null.
  final String? closeLabel;

  /// Overrides the [closeLabel] button's text style — for a caller whose
  /// spec calls out exact typography (e.g. `gravia`'s Text/sm/regular)
  /// rather than the button theme's default. Ignored if [closeLabel] is
  /// null.
  final TextStyle? closeLabelStyle;

  /// Overrides the header's bottom divider colour — for a caller whose
  /// spec calls out an exact shade (e.g. `gravia`'s Gray/200 light /
  /// Light/900 dark) rather than the theme's `outlineVariant` role. Omit
  /// (default) to use the role.
  final Color? dividerColor;

  /// Overrides the drag-handle bar's colour — for a caller whose spec
  /// calls out an exact shade rather than the theme's `onSurfaceVariant`
  /// role. Omit (default) to use the role.
  final Color? handleColor;

  /// Overrides the drag-handle bar's size — for a caller whose spec calls
  /// out exact geometry (e.g. `dailymart`'s 64 × 5) rather than the default
  /// 44 × 3. Omit (default) to keep the default.
  final Size? handleSize;

  /// A widget docked at the header row's leading edge (e.g. `dailymart`'s
  /// close disc). Omit (default) for the classic title-first header.
  final Widget? leading;

  /// Centres the title against the whole sheet (drawn under [leading] and
  /// the close action in a stack) instead of the default start-aligned
  /// title — for packs whose sheets centre their title between a leading
  /// disc and an empty trailing slot.
  final bool centerTitle;

  /// Overrides the pinned header's height — for a header whose [leading]
  /// control is taller than the default 56 leaves room for. Omit (default)
  /// to keep the default.
  final double? headerHeight;

  /// Set false to suppress the trailing close control entirely — for packs
  /// whose sheets close through [leading] instead (a sheet with both reads
  /// as two competing exits). [AppBottomSheet.show] still synthesizes its
  /// pop-on-close [onClose], so this flag, not a null [onClose], is how a
  /// caller opts out of the trailing X.
  final bool showCloseAction;
  final List<Widget>? actions;
  final bool isScrollable;
  final double maxHeightFraction;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.titleStyle,
    this.onClose,
    this.closeLabel,
    this.closeLabelStyle,
    this.dividerColor,
    this.handleColor,
    this.handleSize,
    this.leading,
    this.centerTitle = false,
    this.headerHeight,
    this.showCloseAction = true,
    this.actions,
    this.isScrollable = true,
    this.maxHeightFraction = 0.9,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    TextStyle? titleStyle,
    VoidCallback? onClose,
    String? closeLabel,
    TextStyle? closeLabelStyle,
    Color? dividerColor,
    Color? handleColor,
    Size? handleSize,
    Widget? leading,
    bool centerTitle = false,
    double? headerHeight,
    bool showCloseAction = true,
    List<Widget>? actions,
    bool isScrollable = true,
    double maxHeightFraction = 0.9,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => AppBottomSheet(
        title: title,
        titleStyle: titleStyle,
        onClose: () {
          Navigator.of(sheetContext).pop();
          onClose?.call();
        },
        closeLabel: closeLabel,
        closeLabelStyle: closeLabelStyle,
        dividerColor: dividerColor,
        handleColor: handleColor,
        handleSize: handleSize,
        leading: leading,
        centerTitle: centerTitle,
        headerHeight: headerHeight,
        showCloseAction: showCloseAction,
        actions: actions,
        isScrollable: isScrollable,
        maxHeightFraction: maxHeightFraction,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final sheetRadius =
        Theme.of(context).extension<AppShapes>()?.sheetRadius ??
            AppShapes.standard.sheetRadius;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * maxHeightFraction,
        ),
        // Without this, the opaque square-cornered header Material painted
        // by the first sliver covers the decoration's rounded top corners
        // instead of being clipped to them.
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(sheetRadius)),
        ),
        child: CustomScrollView(
          shrinkWrap: true,
          physics: isScrollable
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                title: title,
                titleStyle: titleStyle,
                onClose: onClose,
                closeLabel: closeLabel,
                closeLabelStyle: closeLabelStyle,
                dividerColor: dividerColor,
                handleColor: handleColor,
                handleSize: handleSize,
                leading: leading,
                centerTitle: centerTitle,
                headerHeight: headerHeight,
                showCloseAction: showCloseAction,
              ),
            ),
            SliverToBoxAdapter(child: child),
            if (actions != null && actions!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      for (int i = 0; i < actions!.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.base),
                        Expanded(child: actions![i]),
                      ],
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? title;
  final TextStyle? titleStyle;
  final VoidCallback? onClose;
  final String? closeLabel;
  final TextStyle? closeLabelStyle;
  final Color? dividerColor;
  final Color? handleColor;
  final Size? handleSize;
  final Widget? leading;
  final bool centerTitle;
  final double? headerHeight;
  final bool showCloseAction;

  static const double _defaultHeight = 56;

  _HeaderDelegate({
    this.title,
    this.titleStyle,
    this.onClose,
    this.closeLabel,
    this.closeLabelStyle,
    this.dividerColor,
    this.handleColor,
    this.handleSize,
    this.leading,
    this.centerTitle = false,
    this.headerHeight,
    this.showCloseAction = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final cs = Theme.of(context).colorScheme;
    // The handle bar above already gives every sheet a drag affordance, so
    // an untitled sheet just leaves the title slot blank rather than
    // rendering a second handle here.
    final titleText = title != null
        ? Text(
            title!,
            style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          )
        : const SizedBox.shrink();
    final closeAction = onClose == null || !showCloseAction
        ? null
        : closeLabel != null
            ? TextButton(
                onPressed: onClose,
                style: TextButton.styleFrom(foregroundColor: cs.primary),
                child: Text(closeLabel!, style: closeLabelStyle),
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClose,
                color: cs.onSurfaceVariant,
              );

    return Material(
      elevation: overlapsContent ? 2 : 0,
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs2),
            child: Container(
              width: handleSize?.width ?? 44,
              height: handleSize?.height ?? 3,
              decoration: BoxDecoration(
                color: handleColor ?? cs.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: AppRadius.full,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              // A stack, not a row, when the title is centred: the title
              // centres against the sheet itself, so a lone leading disc
              // doesn't push it off-centre.
              child: centerTitle
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        titleText,
                        if (leading != null)
                          Align(alignment: Alignment.centerLeft, child: leading),
                        if (closeAction != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: closeAction,
                          ),
                      ],
                    )
                  : Row(
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: AppSpacing.base),
                        ],
                        Expanded(child: titleText),
                        ?closeAction,
                      ],
                    ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: overlapsContent
                ? Colors.transparent
                : (dividerColor ?? cs.outlineVariant.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => headerHeight ?? _defaultHeight;

  @override
  double get minExtent => headerHeight ?? _defaultHeight;

  @override
  bool shouldRebuild(covariant _HeaderDelegate old) =>
      title != old.title ||
      titleStyle != old.titleStyle ||
      onClose != old.onClose ||
      closeLabel != old.closeLabel ||
      closeLabelStyle != old.closeLabelStyle ||
      dividerColor != old.dividerColor ||
      handleColor != old.handleColor ||
      handleSize != old.handleSize ||
      leading != old.leading ||
      centerTitle != old.centerTitle ||
      headerHeight != old.headerHeight ||
      showCloseAction != old.showCloseAction;
}
