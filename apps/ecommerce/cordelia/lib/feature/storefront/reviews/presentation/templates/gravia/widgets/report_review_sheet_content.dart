import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_action_pair.dart';
import '../../../../domain/entities/review_report_reason.dart';
import '../../../report_review_body.dart';
import '../../../report_review_form.dart';

/// Body of Gravia's report-review sheet — the reason list, the "hide this
/// shopper too" toggle, and the pack's CTA. The chrome comes from
/// `showGraviaSheet`.
///
/// Composed from recipes the pack already owns: no kit draws a reporting
/// frame, because none of them drew reviews either.
class GraviaReportReviewSheetContent extends StatefulWidget {
  final void Function(ReviewReportReason reason, bool block) onSubmit;

  const GraviaReportReviewSheetContent({super.key, required this.onSubmit});

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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ReportReviewBody(
      reason: reason,
      onReasonSelected: selectReason,
      block: block,
      onBlockChanged: toggleBlock,
      errorMessage: formError,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      promptStyle: GraviaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.onSurfaceVariant),
      optionLabelStyle: GraviaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      blockLabelStyle: GraviaTextStyleConst.textSmRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      submit: GraviaActionPair(
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
    );
  }
}
