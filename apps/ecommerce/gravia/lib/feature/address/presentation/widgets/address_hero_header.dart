import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/icon_button.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// The coloured header canvas for Select Address: a glass back button and a
/// centered title — the pack's signature "coloured header canvas"
/// composition (docs/ai-rules/design.md), same shape as
/// [ProductDetailHeroHeader]/[CategoryDetailsHeroHeader] but with no trailing
/// action, so a same-size invisible spacer keeps the title centered against
/// the back button's width instead of drifting toward it.
class AddressHeroHeader extends StatelessWidget {
  final VoidCallback onBack;

  const AddressHeroHeader({super.key, required this.onBack});

  static const _iconContainerSize = 45.0;
  static const _iconSize = 20.0;

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
              ValueConst.selectAddressTitle,
              textAlign: TextAlign.center,
              style: TextStyleConst.textLgBold(tt).copyWith(color: onOverlay),
            ),
          ),
          const SizedBox(width: _iconContainerSize),
        ],
      ),
    );
  }
}
