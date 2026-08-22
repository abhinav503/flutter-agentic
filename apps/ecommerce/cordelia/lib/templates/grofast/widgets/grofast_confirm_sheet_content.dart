import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/molecules/confirm_sheet_body.dart';

import 'package:cordelia/templates/grofast/constants/grofast_dimen_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_value_const.dart';

import 'grofast_dome.dart';
import 'grofast_primary_button.dart';

/// The body of [showGrofastConfirmSheet] — centred title + message over a
/// stacked confirm/cancel pair (spec sheet §9).
///
/// The destructive action is the **outlined** button and the safe one is the
/// gradient: in this pack the gradient means "affirmative", so painting a
/// deletion with it would read as encouragement.
class GrofastConfirmSheetContent extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback onConfirm;

  const GrofastConfirmSheetContent({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ConfirmSheetBody(
      title: title,
      message: message,
      titleStyle: GrofastTextStyleConst.subheadBold(tt),
      messageStyle: GrofastTextStyleConst.bodyMedium(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      padding: const EdgeInsets.fromLTRB(
        GrofastDimenConst.screenGutter,
        GrofastSheetMetrics.contentTop,
        GrofastDimenConst.screenGutter,
        AppSpacing.lg,
      ),
      // Stacked, not a pair: the destructive action is the **outlined**
      // button and the safe one is the gradient, because in this pack the
      // gradient means "affirmative" and would read as encouragement on a
      // deletion.
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: confirmLabel,
            variant: AppButtonVariant.secondary,
            size: AppButtonSize.large,
            fullWidth: true,
            height: GrofastDimenConst.controlHeight,
            borderRadius: AppRadius.full,
            borderColor: cs.error,
            labelStyle: GrofastTextStyleConst.labelSemibold(
              tt,
            ).copyWith(color: cs.error),
            onTap: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
          const SizedBox(height: AppSpacing.base),
          GrofastPrimaryButton(
            label: cancelLabel ?? GrofastValueConst.cancelLabel,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
