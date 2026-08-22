import 'package:flutter/material.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';
import 'package:cordelia/enums/review_report_reason.dart';
import '../../../report_review_body.dart';
import '../../../report_review_form.dart';

/// Body of Grofast's report-review sheet — the reason list, the "hide this
/// shopper too" toggle, and the pack's CTA. The chrome comes from
/// `showGrofastSheet`.
///
/// Composed from recipes the pack already owns: no kit draws a reporting
/// frame, because none of them drew reviews either.
class GrofastReportReviewSheetContent extends StatefulWidget {
  final Future<String?> Function(ReviewReportReason reason, bool block)
  onSubmit;

  const GrofastReportReviewSheetContent({super.key, required this.onSubmit});

  @override
  State<GrofastReportReviewSheetContent> createState() =>
      _GrofastReportReviewSheetContentState();
}

class _GrofastReportReviewSheetContentState
    extends State<GrofastReportReviewSheetContent>
    with ReportReviewForm {
  @override
  Future<String?> Function(ReviewReportReason reason, bool block)
  get onSubmit => widget.onSubmit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ReportReviewBody(
      reason: reason,
      onReasonSelected: selectReason,
      block: block,
      onBlockChanged: toggleBlock,
      errorMessage: formError,
      isSubmitting: submitting,
      promptStyle: GrofastTextStyleConst.bodySmall(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      optionLabelStyle: GrofastTextStyleConst.bodySmall(
        tt,
      ).copyWith(color: cs.onSurface),
      blockLabelStyle: GrofastTextStyleConst.bodySmall(
        tt,
      ).copyWith(color: cs.onSurface),
      submit: GrofastPrimaryButton(
        label: ValueConst.reportReviewSubmitLabel,
        onTap: submitReport,
      ),
    );
  }
}
