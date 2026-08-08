import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:cordelia/constants/cordelia_color_const.dart';
import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/widgets/cordelia_brand_mark.dart';
import 'package:cordelia/widgets/cordelia_glass_icon_button.dart';

/// Signup screen's coloured header: back button and brand mark, then title
/// and subtitle on [HeaderCanvas].
///
/// The mark is name-less here — the back disc already owns the row's left
/// end, and the title states what the screen is; repeating the product name
/// a line above "Create your account" would just crowd it.
class SignupHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SignupHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final onOverlay = context.appColors.onOverlay;

    return HeaderCanvas(
      gradient: CordeliaColorConst.brandHeaderGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CordeliaGlassIconButton(
                asset: ImageConst.arrowLeft,
                onTap: onBack,
              ),
              const Spacer(),
              const CordeliaBrandMark(showName: false),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            ValueConst.signupTitle,
            style: CordeliaTextStyleConst.textXlBold(
              tt,
            ).copyWith(color: onOverlay),
          ),
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.signupSubtitle,
            style: CordeliaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: onOverlay.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
