import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/checkbox.dart';
import 'package:core/core/ui/molecules/radio_group.dart';

import 'package:cordelia/constants/value_const.dart';

import '../domain/entities/review_report_reason.dart';
import 'report_review_form.dart';

/// The report sheet's body, shared by every template — prompt, the reason
/// list, the "hide this shopper too" tick, then the pack's own CTA.
///
/// The counterpart to [ReportReviewForm]: that mixin owns the state and the
/// submit, this owns the arrangement, and a pack is left with three text
/// styles, its padding and its button. No kit draws a reporting frame (none
/// of them drew reviews either), so there is no per-pack structure to keep —
/// which is exactly why three copies of it had already drifted apart only in
/// typography.
class ReportReviewBody extends StatelessWidget {
  final ReviewReportReason? reason;
  final ValueChanged<ReviewReportReason> onReasonSelected;

  final bool block;
  final ValueChanged<bool> onBlockChanged;

  /// The pack's submit control — a lone primary button, or a
  /// cancel/confirm pair.
  final Widget submit;

  final TextStyle promptStyle;
  final TextStyle optionLabelStyle;
  final TextStyle blockLabelStyle;

  /// The gate's complaint, or null while there is nothing to say — rendered
  /// just above the CTA that produced it, in `cs.error`.
  final String? errorMessage;

  /// Content inset. Zero for a pack whose sheet chrome already pads.
  final EdgeInsetsGeometry padding;

  const ReportReviewBody({
    super.key,
    required this.reason,
    required this.onReasonSelected,
    required this.block,
    required this.onBlockChanged,
    required this.submit,
    required this.promptStyle,
    required this.optionLabelStyle,
    required this.blockLabelStyle,
    this.errorMessage,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ValueConst.reportReviewPrompt, style: promptStyle),
        const SizedBox(height: AppSpacing.sm),
        for (final value in ReviewReportReason.values)
          AppRadioRow(
            label: value.label,
            selected: reason == value,
            onTap: () => onReasonSelected(value),
            labelStyle: optionLabelStyle,
          ),
        const SizedBox(height: AppSpacing.base),
        // A checkbox rather than a switch: it sits under a list of choices
        // and reads as one more thing being ticked, not as a setting.
        GestureDetector(
          onTap: () => onBlockChanged(!block),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              AppCheckbox(value: block, shape: AppCheckboxShape.square),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Text(
                  ValueConst.reportReviewBlockLabel,
                  style: blockLabelStyle,
                ),
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: AppSpacing.base),
          Text(
            errorMessage!,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl2),
        submit,
      ],
    ),
  );
}
