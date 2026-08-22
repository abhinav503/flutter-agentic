import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';
import 'package:cordelia/enums/review_report_reason.dart';
import '../../../report_review_body.dart';
import '../../../report_review_form.dart';

/// Body of DailyMart's report-review sheet — the reason list, the "hide this
/// shopper too" toggle, and the pack's CTA. The chrome comes from
/// `showDailyMartSheet`.
///
/// Composed from recipes the pack already owns: no kit draws a reporting
/// frame, because none of them drew reviews either.
class DailyMartReportReviewSheetContent extends StatefulWidget {
  final Future<String?> Function(ReviewReportReason reason, bool block)
  onSubmit;

  const DailyMartReportReviewSheetContent({super.key, required this.onSubmit});

  @override
  State<DailyMartReportReviewSheetContent> createState() =>
      _DailyMartReportReviewSheetContentState();
}

class _DailyMartReportReviewSheetContentState
    extends State<DailyMartReportReviewSheetContent>
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.base,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      promptStyle: DailyMartTextStyleConst.bodySmMedium(
        tt,
      ).copyWith(color: cs.onSurface),
      optionLabelStyle: DailyMartTextStyleConst.bodySmRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      blockLabelStyle: DailyMartTextStyleConst.bodySmRegular(
        tt,
      ).copyWith(color: cs.onSurface),
      submit: DailyMartPrimaryButton(
        label: ValueConst.reportReviewSubmitLabel,
        onTap: submitReport,
      ),
    );
  }
}
