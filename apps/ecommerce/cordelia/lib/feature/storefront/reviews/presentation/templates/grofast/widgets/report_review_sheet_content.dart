import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/molecules/radio_group.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import '../../../../domain/entities/review_report_reason.dart';
import '../../../report_review_form.dart';

/// Body of Grofast's report-review sheet — the reason list, the "hide this
/// shopper too" toggle, and the pack's CTA. The chrome comes from
/// `showGrofastSheet`.
///
/// Composed from recipes the pack already owns: no kit draws a reporting
/// frame, because none of them drew reviews either.
class GrofastReportReviewSheetContent extends StatefulWidget {
  final void Function(ReviewReportReason reason, bool block) onSubmit;

  /// Surfaces the "pick a reason" message — a sheet has no screen state of
  /// its own to snackbar from.
  final ValueChanged<String> onMessage;

  const GrofastReportReviewSheetContent({
    super.key,
    required this.onSubmit,
    required this.onMessage,
  });

  @override
  State<GrofastReportReviewSheetContent> createState() =>
      _GrofastReportReviewSheetContentState();
}

class _GrofastReportReviewSheetContentState
    extends State<GrofastReportReviewSheetContent>
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ValueConst.reportReviewPrompt,
          style: GrofastTextStyleConst.bodySmall(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final value in ReviewReportReason.values)
          AppRadioRow(
            label: value.label,
            selected: reason == value,
            onTap: () => selectReason(value),
            labelStyle: GrofastTextStyleConst.bodySmall(
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
                  style: GrofastTextStyleConst.bodySmall(
                    tt,
                  ).copyWith(color: cs.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl2),
        GrofastPrimaryButton(
          label: ValueConst.reportReviewSubmitLabel,
          onTap: submitReport,
        ),
      ],
    );
  }
}
