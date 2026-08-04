import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// The confirm-sheet content silhouette packs share: a centred title over a
/// centred message, with the pack's own action controls docked below. Pass
/// `title: null` for a message-only sheet.
///
/// Only the copy/typography and the [actions] widget vary per pack — the
/// column, centring, and gaps live here once. Host it in a chromeless
/// `AppBottomSheet` (`showHeader: false`); the sheet pays the device inset,
/// so [padding] covers content insets only.
class ConfirmSheetBody extends StatelessWidget {
  final String? title;
  final String message;

  /// The pack's action controls — a side-by-side pair, a stacked
  /// outline-over-primary column, a single destructive CTA.
  final Widget actions;

  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  final EdgeInsetsGeometry padding;

  /// Gap between title and message.
  final double titleGap;

  /// Gap between the text block and [actions].
  final double actionsGap;

  const ConfirmSheetBody({
    super.key,
    this.title,
    required this.message,
    required this.actions,
    this.titleStyle,
    this.messageStyle,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg,
    ),
    this.titleGap = AppSpacing.xs,
    this.actionsGap = AppSpacing.xl4,
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
          if (title != null) ...[
            Text(
              title!,
              textAlign: TextAlign.center,
              style:
                  titleStyle ?? tt.titleMedium!.copyWith(color: cs.onSurface),
            ),
            SizedBox(height: titleGap),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style:
                messageStyle ??
                tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
          ),
          SizedBox(height: actionsGap),
          actions,
        ],
      ),
    );
  }
}
