import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// One entry of an [AppActionSheetBody] — a label (with optional leading
/// glyph) that pops the sheet with [value].
class AppSheetAction<T> {
  final String label;
  final T value;
  final Widget? leading;

  const AppSheetAction({
    required this.label,
    required this.value,
    this.leading,
  });
}

/// An **action list** sheet body (not a selection list — no radio state):
/// each row pops the enclosing sheet with its action's value, so the caller
/// awaits `showAppBottomSheet<T>` and switches on the result. The
/// pop-with-value plumbing lives here once; packs pass typography and
/// row insets.
///
/// ```dart
/// final source = await showAppBottomSheet<AvatarSource>(
///   title: 'Profile photo',
///   child: AppActionSheetBody(actions: [
///     AppSheetAction(label: 'Take photo', value: AvatarSource.camera),
///     AppSheetAction(label: 'Choose from gallery', value: AvatarSource.gallery),
///   ]),
/// );
/// ```
class AppActionSheetBody<T> extends StatelessWidget {
  final List<AppSheetAction<T>> actions;
  final TextStyle? labelStyle;

  /// Outer inset around the list.
  final EdgeInsetsGeometry padding;

  /// Vertical inset of each row.
  final EdgeInsetsGeometry rowPadding;

  /// Gap between a row's leading glyph and its label.
  final double leadingGap;

  const AppActionSheetBody({
    super.key,
    required this.actions,
    this.labelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    this.rowPadding = const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    this.leadingGap = AppSpacing.base,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final action in actions)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(action.value),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: rowPadding,
                child: Row(
                  children: [
                    if (action.leading != null) ...[
                      action.leading!,
                      SizedBox(width: leadingGap),
                    ],
                    Expanded(
                      child: Text(
                        action.label,
                        style:
                            labelStyle ??
                            tt.bodyLarge!.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
