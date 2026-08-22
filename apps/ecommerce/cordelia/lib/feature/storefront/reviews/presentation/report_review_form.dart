import 'package:flutter/widgets.dart';

import 'package:cordelia/constants/value_const.dart';

import 'package:cordelia/enums/review_report_reason.dart';

/// Everything a report sheet does that isn't pack chrome — which reason is
/// picked, whether to hide the author too, the "pick a reason" gate, and
/// the submit.
///
/// Mirrors [WriteReviewForm]: the sheet never touches a bloc, it calls
/// [onSubmit] and the screen that opened it dispatches. Each template
/// renders its own body over this, so the behaviour can't drift per pack.
mixin ReportReviewForm<T extends StatefulWidget> on State<T> {
  /// Files the report and resolves to the failure message, or null once it
  /// landed — same contract as `WriteReviewForm.onSubmit`, so a failure
  /// leaves the sheet up with the reason still picked.
  Future<String?> Function(ReviewReportReason reason, bool block) get onSubmit;

  /// The gate's complaint, or null while there is nothing to say.
  ///
  /// Held here and rendered *inside* the sheet rather than sent to the host
  /// screen's `showSnackBar`: a snack bar belongs to the Scaffold underneath,
  /// so a modal sheet covers it completely — the shopper tapped Report and
  /// nothing appeared to happen. Cleared the moment they pick a reason.
  String? formError;

  /// Null until one is picked, which is what gates the submit. There is no
  /// sensible default: guessing "offensive" would file the harshest
  /// complaint on behalf of someone who never chose it.
  ReviewReportReason? reason;

  /// On by default. A shopper reporting a review usually does not want to
  /// keep reading that person, and the toggle is right there to say
  /// otherwise — the opposite default makes the common case two taps.
  bool block = true;

  /// True while the report is in the air; the body absorbs taps on the CTA.
  bool submitting = false;

  void selectReason(ReviewReportReason value) => setState(() {
    reason = value;
    formError = null;
  });

  void toggleBlock(bool value) => setState(() => block = value);

  Future<void> submitReport() async {
    final picked = reason;
    if (picked == null) {
      setState(() => formError = ValueConst.reportReviewMissingReasonMessage);
      return;
    }
    setState(() {
      submitting = true;
      formError = null;
    });

    final failure = await onSubmit(picked, block);
    if (!mounted) return;
    if (failure != null) {
      setState(() {
        submitting = false;
        formError = failure;
      });
      return;
    }
    Navigator.of(context).pop();
  }
}

extension ReviewReportReasonLabelX on ReviewReportReason {
  /// The shopper-facing wording. In presentation rather than beside the
  /// enum: the domain value is what the server is told, this is what a
  /// person reads, and only one of the two is translated.
  String get label => switch (this) {
    ReviewReportReason.offensive => ValueConst.reportReasonOffensive,
    ReviewReportReason.spam => ValueConst.reportReasonSpam,
    ReviewReportReason.irrelevant => ValueConst.reportReasonIrrelevant,
    ReviewReportReason.personalInfo => ValueConst.reportReasonPersonalInfo,
  };
}
