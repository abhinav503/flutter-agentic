import 'package:flutter/material.dart';

import '../../theme/app_colors_extension.dart';
import '../../theme/app_spacing.dart';
import 'header_canvas.dart';

/// Title hero header on a [HeaderCanvas] — the two title compositions a
/// screen-top uses:
///
/// - default: [leading] control (usually a glass back button) + centered
///   title (+ optional [trailing] action). With no [trailing], an invisible
///   [leadingBalanceWidth]-wide spacer keeps the title centered instead of
///   drifting toward the leading control.
/// - [HeroHeader.page]: left-aligned page title (+ optional [trailing]) for
///   tab roots that aren't pushed routes — no leading control.
///
/// [bottom] adds a second content row on the same canvas below the title row
/// (filter chips, an identity row). Styling is injectable — a style pack's
/// app-level preset bakes in its title styles and glass controls (gravia's
/// `GraviaHeroHeader` is the reference example); [titleStyle] falls back to
/// the theme's `titleMedium`/`titleLarge` in [AppColorsExtension.onOverlay].
class HeroHeader extends StatelessWidget {
  final String title;

  /// Defaults to `titleMedium` (default) / `titleLarge` (`.page`) coloured
  /// [AppColorsExtension.onOverlay] — packs pass their own scale instead.
  final TextStyle? titleStyle;

  /// The header's left control (back button). Required in the default
  /// constructor; absent in [HeroHeader.page].
  final Widget? leading;

  /// Width of the invisible spacer mirrored opposite [leading] when
  /// [trailing] is null, so the centered title doesn't drift. Pass the
  /// leading control's width; null renders no spacer.
  final double? leadingBalanceWidth;

  final Widget? trailing;
  final Widget? bottom;

  /// Gap between the title row and [bottom].
  final double bottomGap;

  /// Forwarded to [HeaderCanvas.bottomPadding].
  final double canvasBottomPadding;

  final bool _pageTitle;

  const HeroHeader({
    super.key,
    required this.title,
    required Widget this.leading,
    this.titleStyle,
    this.leadingBalanceWidth,
    this.trailing,
    this.bottom,
    this.bottomGap = AppSpacing.base,
    this.canvasBottomPadding = AppSpacing.xl2,
  }) : _pageTitle = false;

  const HeroHeader.page({
    super.key,
    required this.title,
    this.titleStyle,
    this.trailing,
    this.bottom,
    this.bottomGap = AppSpacing.base,
    this.canvasBottomPadding = AppSpacing.xl2,
  })  : leading = null,
        leadingBalanceWidth = null,
        _pageTitle = true;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    // onOverlay, not `onPrimary` — the canvas stays a brand-coloured surface
    // in both modes, so the title must stay legible rather than follow a
    // role that can flip dark in dark mode.
    final onOverlay =
        Theme.of(context).extension<AppColorsExtension>()?.onOverlay ??
            Colors.white;

    final style = titleStyle ??
        (_pageTitle ? tt.titleLarge : tt.titleMedium)!
            .copyWith(color: onOverlay);

    final titleRow = Row(
      children: [
        ?leading,
        Expanded(
          child: Text(
            title,
            textAlign: _pageTitle ? TextAlign.start : TextAlign.center,
            style: style,
          ),
        ),
        if (trailing != null)
          trailing!
        else if (!_pageTitle && leadingBalanceWidth != null)
          SizedBox(width: leadingBalanceWidth),
      ],
    );

    return HeaderCanvas(
      bottomPadding: canvasBottomPadding,
      child: bottom == null
          ? titleRow
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                titleRow,
                SizedBox(height: bottomGap),
                bottom!,
              ],
            ),
    );
  }
}
