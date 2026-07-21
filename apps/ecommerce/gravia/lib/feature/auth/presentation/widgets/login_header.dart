import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/blocks/header_canvas.dart';

import 'package:gravia/constants/image_const.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// Login screen's coloured header: the Gravia wordmark, title, and subtitle
/// on [HeaderCanvas].
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final onOverlay = Theme.of(
      context,
    ).extension<AppColorsExtension>()!.onOverlay;

    // Same lockup as SplashPage's wordmark, but tinted onOverlay (white) —
    // the brand icon's own fill is a fixed primary green (see
    // gravia_brand_icon.svg), which reads fine on splash's white/near-black
    // surface but would vanish against this header's primary-green canvas.
    final wordmarkStyle = tt.displaySmall!.copyWith(
      color: onOverlay,
      fontWeight: FontWeight.w800,
      letterSpacing: 1,
    );

    return HeaderCanvas(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // No Center/Expanded here — HeaderCanvas's child gets loose
          // (unbounded) height inside CollapsingHeaderSheet's Stack, and an
          // alignment widget would expand to fill it, blowing the header up
          // to nearly the full screen (see the canvas's own doc).
          Text.rich(
            TextSpan(
              style: wordmarkStyle,
              children: [
                const TextSpan(text: ValueConst.splashWordmarkLeft),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs4,
                    ),
                    child: SvgPicture.asset(
                      ImageConst.graviaBrandIcon,
                      height: wordmarkStyle.fontSize! * 0.72,
                      colorFilter: ColorFilter.mode(onOverlay, BlendMode.srcIn),
                    ),
                  ),
                ),
                const TextSpan(text: ValueConst.splashWordmarkRight),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            ValueConst.loginTitle,
            style: TextStyleConst.displayXsBold(tt).copyWith(color: onOverlay),
          ),
          const SizedBox(height: AppSpacing.xs2),
          Text(
            ValueConst.loginSubtitle,
            style: TextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: onOverlay.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
