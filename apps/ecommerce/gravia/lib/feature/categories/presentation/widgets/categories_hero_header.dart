import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// The coloured header canvas for Categories: a bold page title + a glass
/// search trigger — the pack's signature "coloured header canvas"
/// composition (docs/ai-rules/design.md), same as [HomeHeroHeader]/
/// [ProductDetailHeroHeader]. Unlike Home's search field, this is a plain
/// icon button — it opens the dedicated Search screen rather than
/// Hero-morphing a field, since there's no field on this canvas to glide.
class CategoriesHeroHeader extends StatelessWidget {
  final VoidCallback onSearchTap;

  const CategoriesHeroHeader({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final topInset = MediaQuery.paddingOf(context).top;
    final onOverlay = Theme.of(context).extension<AppColorsExtension>()!.onOverlay;

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topInset + AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xl2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              ValueConst.categoriesPageTitle,
              style: TextStyleConst.textXlBold(tt).copyWith(color: onOverlay),
            ),
          ),
          AppIconButton(
            iconBuilder: (color, size) => AppSvgImage.asset(
              ImageConst.search,
              color: color,
              width: size,
              height: size,
            ),
            containerSize: 45,
            iconSize: 20,
            variant: AppIconButtonVariant.glass,
            onTap: onSearchTap,
          ),
        ],
      ),
    );
  }
}
