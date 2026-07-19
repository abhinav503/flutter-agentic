import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';
import 'package:gravia/widgets/gravia_glass_icon_button.dart';
import 'package:gravia/widgets/gravia_header_canvas.dart';

/// Signup screen's coloured header: back button, title, and subtitle on
/// [GraviaHeaderCanvas].
class SignupHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SignupHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    return GraviaHeaderCanvas(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GraviaGlassIconButton(asset: ImageConst.arrowLeft, onTap: onBack),
          const SizedBox(height: AppSpacing.base),
          Text(
            ValueConst.signupTitle,
            style: TextStyleConst.textXlBold(tt).copyWith(color: onOverlay),
          ),
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.signupSubtitle,
            style: TextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: onOverlay.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
