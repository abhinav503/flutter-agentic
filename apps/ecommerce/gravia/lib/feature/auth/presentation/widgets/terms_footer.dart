import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gravia/constants/app_routes.dart';
import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// "By continuing, you agree to our Terms of Service & Privacy Policy" —
/// the bold second line links to the Terms & Conditions page.
class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          ValueConst.byContinuingAgree,
          textAlign: TextAlign.center,
          style: TextStyleConst.textSmRegular(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        GestureDetector(
          onTap: () => context.push(AppRoutes.termsAndConditions),
          child: Text(
            ValueConst.termsOfServiceAndPrivacyPolicy,
            textAlign: TextAlign.center,
            style: TextStyleConst.textSmBold(tt).copyWith(color: cs.onSurface),
          ),
        ),
      ],
    );
  }
}
