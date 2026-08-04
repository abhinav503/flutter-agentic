import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_text_style_const.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_action_pair.dart';
import 'package:cordelia/templates/gravia/widgets/gravia_form_field.dart';

import '../../../../domain/entities/review_entity.dart';
import '../../../write_review_form.dart';

/// Body of gravia's write/edit-review sheet — the pack's field and its
/// Cancel/confirm pair around the shared star input. The chrome (title +
/// "Cancel" close + hairline) comes from `showGraviaSheet`.
///
/// Same shape as the pack's Add to Cart sheet: local form state here, the
/// actual dispatch back on the screen through [onSubmit].
class GraviaWriteReviewSheetContent extends StatefulWidget {
  /// The shopper's current review when editing, null when writing a first.
  final ReviewEntity? existing;
  final void Function(int rating, String text) onSubmit;

  /// Surfaces the "pick a rating" message — a sheet has no screen state of
  /// its own to snackbar from.
  final ValueChanged<String> onMessage;

  const GraviaWriteReviewSheetContent({
    super.key,
    required this.existing,
    required this.onSubmit,
    required this.onMessage,
  });

  @override
  State<GraviaWriteReviewSheetContent> createState() =>
      _GraviaWriteReviewSheetContentState();
}

class _GraviaWriteReviewSheetContentState
    extends State<GraviaWriteReviewSheetContent>
    with WriteReviewForm {
  @override
  ReviewEntity? get existingReview => widget.existing;

  @override
  void Function(int rating, String text) get onSubmit => widget.onSubmit;

  @override
  String get missingRatingMessage => ValueConst.reviewMissingRatingMessage;

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
            ValueConst.reviewRatingPrompt,
            style: GraviaTextStyleConst.textSmRegular(
              tt,
            ).copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          RatingStarsField(value: rating, onChanged: selectRating),
          const SizedBox(height: AppSpacing.lg),
          GraviaFormField(
            label: ValueConst.reviewTextLabel,
            controller: reviewController,
            hint: ValueConst.reviewTextHint,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.xl2),
          GraviaActionPair(
            left: GraviaAction(
              label: GraviaValueConst.cancel,
              kind: GraviaActionKind.secondary,
              // Neutral black/white Cancel, matching the pack's other
              // sheets rather than a primary-tinted secondary.
              labelColor: cs.onSurface,
              onTap: () => Navigator.of(context).pop(),
            ),
            right: GraviaAction(
              label: ValueConst.reviewSubmitLabel,
              kind: GraviaActionKind.primary,
              onTap: submitReview,
            ),
          ),
        ],
      ),
    );
  }
}
