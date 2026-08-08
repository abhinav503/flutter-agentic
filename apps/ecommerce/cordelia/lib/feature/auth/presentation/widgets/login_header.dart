import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:cordelia/constants/cordelia_color_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/widgets/cordelia_brand_mark.dart';

/// Login screen's coloured header: the brand lockup over title and subtitle
/// on [HeaderCanvas].
///
/// Login is the first screen an installed app shows to anyone not already
/// signed in, and it was the only entry point that never identified the
/// product — the mark had been reaching users on the splash alone, which is
/// gone in under a second.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

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
          const CordeliaBrandMark(),
          const SizedBox(height: AppSpacing.xl2),
          Text(
            ValueConst.loginTitle,
            style: CordeliaTextStyleConst.displayXsBold(
              tt,
            ).copyWith(color: onOverlay),
          ),
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.loginSubtitle,
            style: CordeliaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: onOverlay.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
