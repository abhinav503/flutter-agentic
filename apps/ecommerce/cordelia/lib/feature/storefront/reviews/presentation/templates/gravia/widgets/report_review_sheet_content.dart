import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/molecules/radio_group.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_action_pair.dart';
import '../../../../domain/entities/review_report_reason.dart';
import '../../../report_review_form.dart';

/// Body of Gravia's report-review sheet — the reason list, the "hide this
/// shopper too" toggle, and the pack's CTA. The chrome comes from
/// `showGraviaSheet`.
///
/// Composed from recipes the pack already owns: no kit draws a reporting
/// frame, because none of them drew reviews either.
class GraviaReportReviewSheetContent extends StatefulWidget {
  final void Function(ReviewReportReason reason, bool block) onSubmit;

  /// Surfaces the "pick a reason" message — a sheet has no screen state of
  /// its own to snackbar from.
  final ValueChanged<String> onMessage;

  const GraviaReportReviewSheetContent({
    super.key,
    required this.onSubmit,
    required this.onMessage,
  });

  @override
  State<GraviaReportReviewSheetContent> createState() =>
      _GraviaReportReviewSheetContentState();
}

class _GraviaReportReviewSheetContentState
    extends State<GraviaReportReviewSheetContent>
    with ReportReviewForm {
  @override
  void Function(ReviewReportReason reason, bool block) get onSubmit =>
      widget.onSubmit;

  @override
  void showFormMessage(String message) => widget.onMessage(message);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ValueConst.reportReviewPrompt,
            style: GraviaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final value in ReviewReportReason.values)
            AppRadioRow(
              label: value.label,
              selected: reason == value,
              onTap: () => selectReason(value),
              labelStyle: GraviaTextStyleConst.textSmRegular(
                tt,
              ).copyWith(color: cs.onSurface),
            ),
          const SizedBox(height: AppSpacing.base),
          // A checkbox rather than a switch: it sits under a list of choices
          // and reads as one more thing being ticked, not as a setting.
          GestureDetector(
            onTap: () => toggleBlock(!block),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                AppCheckbox(value: block, shape: AppCheckboxShape.square),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Text(
                    ValueConst.reportReviewBlockLabel,
                    style: GraviaTextStyleConst.textSmRegular(
                      tt,
                    ).copyWith(color: cs.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl2),
          GraviaActionPair(
            left: GraviaAction(
              label: GraviaValueConst.cancel,
              kind: GraviaActionKind.secondary,
              labelColor: cs.onSurface,
              onTap: () => Navigator.of(context).pop(),
            ),
            right: GraviaAction(
              label: ValueConst.reportReviewSubmitLabel,
              kind: GraviaActionKind.primary,
              onTap: submitReport,
            ),
          ),
        ],
      ),
    );
  }
}
