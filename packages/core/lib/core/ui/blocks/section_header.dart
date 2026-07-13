import 'package:flutter/material.dart';

/// Section title with an optional trailing action ("See All").
/// Opens every content section on list/home screens so section rhythm is
/// consistent across features and apps.
///
/// Defaults to the theme's `titleLarge`/`labelLarge` roles; pass [titleStyle]
/// / [actionStyle] when a style pack's real screens use different metrics
/// for section headers specifically (not a change to titleLarge/labelLarge
/// app-wide — those still apply everywhere else that reads them).
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final TextStyle? titleStyle;
  final TextStyle? actionStyle;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.titleStyle,
    this.actionStyle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                tt.titleLarge!.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: actionStyle ?? tt.labelLarge!.copyWith(color: cs.primary),
            ),
          ),
      ],
    );
  }
}
