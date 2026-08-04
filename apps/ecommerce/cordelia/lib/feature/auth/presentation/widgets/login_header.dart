import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/value_const.dart';

/// Login screen's coloured header: title and subtitle on [HeaderCanvas].
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final onOverlay = context.appColors.onOverlay;

    return HeaderCanvas(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
