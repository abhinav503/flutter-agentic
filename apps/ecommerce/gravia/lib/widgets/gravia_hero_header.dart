import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/hero_header.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';

import 'gravia_glass_icon_button.dart';

/// Gravia's title styling on core's [HeroHeader] — the pack's specific
/// leading control ([GraviaGlassIconButton]) and title text styles
/// (`TextStyleConst.textLgBold`/`textXlBold`) baked in, so screens never
/// re-supply them. The layout/centering/canvas mechanics (invisible spacer,
/// `bottom` row, `HeaderCanvas` padding) live in core and are shared by any
/// pack with a hero-header treatment.
///
/// - default: glass back button + centered title (+ optional [trailing]
///   glass action).
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

  /// Forwarded to [HeroHeader.canvasBottomPadding].
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

    return _pageTitle
        ? HeroHeader.page(
            title: title,
            titleStyle: TextStyleConst.textXlBold(tt).copyWith(color: onOverlay),
            trailing: trailing,
            bottom: bottom,
            bottomGap: bottomGap,
            canvasBottomPadding: canvasBottomPadding,
          )
        : HeroHeader(
            title: title,
            titleStyle: TextStyleConst.textLgBold(tt).copyWith(color: onOverlay),
            leading: GraviaGlassIconButton(
              asset: ImageConst.arrowLeft,
              onTap: onBack,
            ),
            leadingBalanceWidth: GraviaGlassIconButton.containerSize,
            trailing: trailing,
            bottom: bottom,
            bottomGap: bottomGap,
            canvasBottomPadding: canvasBottomPadding,
          );
  }
}
