import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// The coloured header canvas for Product Details: glass back + favourite
/// controls flanking a white title — the pack's signature "coloured header
/// canvas" composition (docs/ai-rules/design.md), same as [HomeHeroHeader]/
/// [SearchHeroHeader]. Button actions and the title only — no photo; the
/// product image lives in the scrollable body like the rest of the content.
class ProductDetailHeroHeader extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onBack;
  final VoidCallback onFavouriteTap;

  const ProductDetailHeroHeader({
    super.key,
    required this.isFavourite,
    required this.onBack,
    required this.onFavouriteTap,
  });

  // Matches SearchHeroHeader's back button exactly (size + bottom padding)
  // so the glass circle sits in the identical spot on both screens — the
  // productDetails route fades rather than slides in (app.dart), and a
  // size/position mismatch would make that crossfade visibly "jump."
  static const double _iconContainerSize = 45;
  static const double _iconSize = 20;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;
    // Always white regardless of theme — this sits on the primary canvas,
    // so it must stay legible in both light and dark ColorSchemes rather
    // than following `onPrimary`, which can flip dark in dark mode (same
    // reasoning as the glass search field in CommonGlassSurface's showcase).
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topInset + AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      // No Center()-wrapped title: this Row sits directly in
      // CollapsingHeaderSheet's Stack, which gives non-positioned children
      // loose (unbounded) height — `Center` would then want to be as tall
      // as possible (Align with no heightFactor fills its incoming
      // constraints) and blow the header up to nearly the full screen,
      // pushing the whole body off-screen. A plain centered Text has no
      // such pull, so the Row just sizes to its 45px icon buttons, same as
      // SearchHeroHeader.
      child: Row(
        children: [
          AppIconButton(
            iconBuilder: (color, size) => AppSvgImage.asset(
              ImageConst.arrowLeft,
              color: color,
              width: size,
              height: size,
            ),
            containerSize: _iconContainerSize,
            iconSize: _iconSize,
            variant: AppIconButtonVariant.glass,
            onTap: onBack,
          ),
          Expanded(
            child: Text(
              ValueConst.productDetailsTitle,
              textAlign: TextAlign.center,
              style: TextStyleConst.textLgBold(tt).copyWith(color: onOverlay),
            ),
          ),
          AppIconButton(
            icon: isFavourite ? Icons.favorite : Icons.favorite_border,
            containerSize: _iconContainerSize,
            iconSize: _iconSize,
            variant: AppIconButtonVariant.glass,
            onTap: onFavouriteTap,
          ),
        ],
      ),
    );
  }
}
