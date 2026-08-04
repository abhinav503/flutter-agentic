import 'package:flutter/material.dart';

import 'package:core/core/theme/app_colors_extension.dart';
import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';

/// The delivery OTP as a row of tinted discs, one per digit — the pack's one
/// "code to read out loud" shape.
///
/// Started private inside `OrderCard`; Track Order needs the identical row,
/// which is what moved it here rather than leaving the two to drift.
class GraviaOtpDigits extends StatelessWidget {
  final String otp;

  const GraviaOtpDigits({super.key, required this.otp});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 0; i < otp.length; i++) ...[
        if (i > 0) const SizedBox(width: AppSpacing.xs2),
        _OtpDigitBox(digit: otp[i]),
      ],
    ],
  );
}

class _OtpDigitBox extends StatelessWidget {
  final String digit;

  const _OtpDigitBox({required this.digit});

  static const double _size = 32;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.appColors.tintedPrimaryFill,
        border: Border.all(color: cs.primary),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: GraviaTextStyleConst.textMdBold(
          tt,
        ).copyWith(color: cs.onSurface),
      ),
    );
  }
}
