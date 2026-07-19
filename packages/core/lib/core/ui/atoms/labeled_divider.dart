import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// A horizontal divider split by a centered label — "Or continue with",
/// "Or sign in with", and similar auth-screen dividers. Colour/text style
/// come from the theme by default; pass [textStyle]/[dividerColor] for a
/// style-pack-specific look, the same override pattern `SectionHeader` uses
/// for `titleStyle`/`actionStyle`.
///
/// ```dart
/// AppLabeledDivider(label: 'Or Login with')
/// ```
class AppLabeledDivider extends StatelessWidget {
  final String label;
  final TextStyle? textStyle;
  final Color? dividerColor;

  const AppLabeledDivider({
    super.key,
    required this.label,
    this.textStyle,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = dividerColor ?? cs.outlineVariant;

    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            label,
            style:
                textStyle ??
                Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
