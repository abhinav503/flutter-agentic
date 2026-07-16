import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';

import 'gravia_glass_icon_button.dart';
import 'gravia_header_canvas.dart';

/// Gravia's title hero header on the [GraviaHeaderCanvas] — the two title
/// compositions every screen-top uses:
///
/// - default: glass back button + centered title (+ optional [trailing]
///   glass action). With no [trailing], an invisible back-button-sized
///   spacer keeps the title centered instead of drifting toward the button
///   (Cart/Address shipped this trick hand-copied; it lives here now).
/// - [GraviaHeroHeader.page]: left-aligned XL page title (+ optional
///   [trailing]) for tab roots that aren't pushed routes (Categories,
///   Profile) — no back button.
///
/// [bottom] adds a second content row on the same canvas below the title row
/// (Category Details' filter chips, Profile's identity row).
///
/// ```dart
/// GraviaHeroHeader(title: ValueConst.myCartTitle, onBack: () => context.pop())
/// GraviaHeroHeader.page(
///   title: ValueConst.categoriesPageTitle,
///   trailing: GraviaGlassIconButton(asset: ImageConst.search, onTap: ...),
/// )
/// ```
class GraviaHeroHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final Widget? bottom;

  /// Gap between the title row and [bottom].
  final double bottomGap;

  /// Forwarded to [GraviaHeaderCanvas.bottomPadding].
  final double canvasBottomPadding;

  final bool _pageTitle;

  const GraviaHeroHeader({
    super.key,
    required this.title,
    required VoidCallback this.onBack,
    this.trailing,
    this.bottom,
    this.bottomGap = AppSpacing.base,
    this.canvasBottomPadding = AppSpacing.xl2,
  }) : _pageTitle = false;

  const GraviaHeroHeader.page({
    super.key,
    required this.title,
    this.trailing,
    this.bottom,
    this.bottomGap = AppSpacing.base,
    this.canvasBottomPadding = AppSpacing.xl2,
  }) : onBack = null,
       _pageTitle = true;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    // Always white regardless of theme — this sits on the primary canvas, so
    // it must stay legible in both modes rather than following `onPrimary`,
    // which can flip dark in dark mode.
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    final titleRow = Row(
      children: [
        if (!_pageTitle)
          GraviaGlassIconButton(asset: ImageConst.arrowLeft, onTap: onBack),
        Expanded(
          child: Text(
            title,
            textAlign: _pageTitle ? TextAlign.start : TextAlign.center,
            style:
                (_pageTitle
                        ? TextStyleConst.textXlBold(tt)
                        : TextStyleConst.textLgBold(tt))
                    .copyWith(color: onOverlay),
          ),
        ),
        if (trailing != null)
          trailing!
        else if (!_pageTitle)
          const SizedBox(width: GraviaGlassIconButton.containerSize),
      ],
    );

    return GraviaHeaderCanvas(
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
