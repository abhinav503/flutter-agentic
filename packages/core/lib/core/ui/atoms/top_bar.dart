import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// General-purpose app bar. Implements [PreferredSizeWidget] so it drops
/// directly into [Scaffold.appBar] or [BasePage.buildAppBar].
///
/// ## Named constructors (recommended)
///
/// ```dart
/// // Home / section screens — title only, no back button
/// AppTopBar.primary(title: 'Home', actions: [...])
///
/// // Detail / inner screens — back button + title
/// AppTopBar.secondary(title: 'Settings', onBackTap: () => context.pop())
/// ```
///
/// ## Custom leading
///
/// Pass [leading] to replace the back button with any widget (e.g. a hamburger
/// menu or a branded icon). Pass [titleWidget] to replace the text title with
/// an arbitrary widget (e.g. a logo or a search field).
///
/// ## Bottom slot
///
/// Pass [bottom] for a tab bar, search bar, or any [PreferredSizeWidget] that
/// sits below the toolbar. [preferredSize] accounts for its height automatically.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool centerTitle;
  final double toolbarHeight;

  /// Hairline divider on the toolbar's bottom edge, separating it from the
  /// screen content below — omit (default) for no divider. Colour is a
  /// caller concern (e.g. an app's raw kit swatch), not something `core`
  /// should assume.
  final Color? bottomBorderColor;
  final double bottomBorderWidth;

  /// Fully configurable constructor — use named constructors for common cases.
  const AppTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.onBackTap,
    this.leading,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.centerTitle = false,
    this.toolbarHeight = kToolbarHeight,
    this.bottomBorderColor,
    this.bottomBorderWidth = 0.5,
  });

  /// Home / section screens — no back button.
  const AppTopBar.primary({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.centerTitle = false,
    this.toolbarHeight = kToolbarHeight,
    this.bottomBorderColor,
    this.bottomBorderWidth = 0.5,
  })  : showBackButton = false,
        onBackTap = null,
        leading = null;

  /// Detail / inner screens — back button on the left.
  const AppTopBar.secondary({
    super.key,
    this.title,
    this.titleWidget,
    this.onBackTap,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.centerTitle = false,
    this.toolbarHeight = kToolbarHeight,
    this.bottomBorderColor,
    this.bottomBorderWidth = 0.5,
  })  : showBackButton = true,
        leading = null;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bg = backgroundColor ?? cs.surface;
    final isDark = cs.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: bg,
      // Prevent M3 container-colour tint on the AppBar surface.
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: centerTitle,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      // Keep status-bar icons readable against the AppBar background.
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            isDark ? Brightness.dark : Brightness.light,
      ),
      leading: _buildLeading(context, cs, bg),
      leadingWidth: showBackButton ? 48 : null,
      title: _buildTitle(tt, cs, bg),
      actions: actions,
      bottom: bottom,
      shape: bottomBorderColor != null
          ? Border(bottom: BorderSide(color: bottomBorderColor!, width: bottomBorderWidth))
          : null,
    );
  }

  Widget? _buildLeading(BuildContext context, ColorScheme cs, Color effectiveBg) {
    if (leading != null) return leading;
    if (!showBackButton) return null;
    final iconColor = ThemeData.estimateBrightnessForColor(effectiveBg) == Brightness.dark
        ? cs.onInverseSurface
        : cs.onSurface;
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new, size: 18, color: iconColor),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
    );
  }

  Widget? _buildTitle(TextTheme tt, ColorScheme cs, Color effectiveBg) {
    if (titleWidget != null) return titleWidget;
    if (title == null || title!.isEmpty) return null;
    // Pick the foreground colour that M3 guarantees readable on effectiveBg.
    final fg = ThemeData.estimateBrightnessForColor(effectiveBg) == Brightness.dark
        ? cs.onInverseSurface
        : cs.onSurface;
    return Text(title!, style: tt.titleLarge!.copyWith(color: fg));
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}
