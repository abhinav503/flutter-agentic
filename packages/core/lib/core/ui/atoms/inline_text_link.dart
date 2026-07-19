import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A centered line of plain text with a tappable, accent-coloured link
/// suffix — "Don't have an account? Signup", "Already have an account?
/// Login", and similar auth-screen prompts. Colours/text styles come from
/// the theme by default; pass [textStyle]/[linkStyle] for a style-pack-
/// specific look, the same override pattern `AppLabeledDivider` uses.
///
/// ```dart
/// AppInlineTextLink(
///   text: "Don't have an account? ",
///   linkText: 'Signup',
///   onTap: () => context.push('/signup'),
/// )
/// ```
class AppInlineTextLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  const AppInlineTextLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
    this.textStyle,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Text.rich(
        TextSpan(
          style:
              textStyle ?? tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
          children: [
            TextSpan(text: text),
            TextSpan(
              text: linkText,
              style:
                  linkStyle ??
                  tt.bodyMedium!.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
