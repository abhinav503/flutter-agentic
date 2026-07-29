import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_glass_icon_button.dart';

/// Signup screen's coloured header: back button, title, and subtitle on
/// [HeaderCanvas].
class SignupHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SignupHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final onOverlay = context.appColors.onOverlay;

    return HeaderCanvas(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GraviaGlassIconButton(asset: ImageConst.arrowLeft, onTap: onBack),
          const SizedBox(height: AppSpacing.base),
          Text(
            ValueConst.signupTitle,
            style: GraviaTextStyleConst.textXlBold(tt).copyWith(color: onOverlay),
          ),
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.signupSubtitle,
            style: GraviaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: onOverlay.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
