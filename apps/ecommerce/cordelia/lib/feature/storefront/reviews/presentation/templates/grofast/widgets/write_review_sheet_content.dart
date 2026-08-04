import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_color_const.dart';
import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_form_field.dart';
import 'package:cordelia/templates/grofast/widgets/grofast_primary_button.dart';

import '../../../../domain/entities/review_entity.dart';
import '../../../write_review_form.dart';

/// Body of grofast's write/edit-review sheet — the pack's field and gradient
/// CTA around the shared star input. The dome chrome and the start-aligned
/// title come from `showGrofastSheet`.
///
/// Composed from recipes the pack already owns: the kit ships no
/// write-review frame.
class GrofastWriteReviewSheetContent extends StatefulWidget {
  /// The shopper's current review when editing, null when writing a first.
  final ReviewEntity? existing;
  final void Function(int rating, String text) onSubmit;

  /// Surfaces the "pick a rating" message — a sheet has no screen state of
  /// its own to snackbar from.
  final ValueChanged<String> onMessage;

  const GrofastWriteReviewSheetContent({
    super.key,
    required this.existing,
    required this.onSubmit,
    required this.onMessage,
  });

  @override
  State<GrofastWriteReviewSheetContent> createState() =>
      _GrofastWriteReviewSheetContentState();
}

class _GrofastWriteReviewSheetContentState
    extends State<GrofastWriteReviewSheetContent>
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ValueConst.reviewRatingPrompt,
          style: GrofastTextStyleConst.bodySmall(
            tt,
          ).copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sm),
        RatingStarsField(
          value: rating,
          onChanged: selectRating,
          color: GrofastColorConst.ratingStar,
        ),
        const SizedBox(height: AppSpacing.lg),
        GrofastFormField(
          label: ValueConst.reviewTextLabel,
          controller: reviewController,
          hint: ValueConst.reviewTextHint,
          keyboardType: TextInputType.multiline,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.xl2),
        GrofastPrimaryButton(
          label: ValueConst.reviewSubmitLabel,
          onTap: submitReview,
        ),
      ],
    );
  }
}
