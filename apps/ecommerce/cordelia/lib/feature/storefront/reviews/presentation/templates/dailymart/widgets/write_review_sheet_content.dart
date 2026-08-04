import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_color_const.dart';
import 'package:cordelia/templates/dailymart/constants/dailymart_text_style_const.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_form_field.dart';
import 'package:cordelia/templates/dailymart/widgets/dailymart_primary_button.dart';

import '../../../write_review_form.dart';

/// Body of the write/edit-review sheet — the pack's field and CTA around the
/// shared star input. The chrome (title + close disc + handle) comes from
/// `showDailyMartSheet`.
///
/// Composed from recipes the pack already owns: the kit ships no
/// write-review frame, since its Reviews tab is a static display.
class DailyMartWriteReviewSheetContent extends StatefulWidget {
  /// What the shopper rated this before — 0 / '' when they haven't. Both
  /// callers fill these: a product's own review, or a delivered order's
  /// rating.
  final int initialRating;
  final String initialText;

  /// The text field's label and hint. Defaulted to the product-review
  /// wording; the order-rating caller passes its own, since it is asking
  /// about a delivery rather than a product.
  final String textLabel;
  final String textHint;

  final void Function(int rating, String text) onSubmit;

  /// Surfaces the "pick a rating" message — a sheet has no screen state of
  /// its own to snackbar from.
  final ValueChanged<String> onMessage;

  const DailyMartWriteReviewSheetContent({
    super.key,
    this.initialRating = 0,
    this.initialText = '',
    this.textLabel = ValueConst.reviewTextLabel,
    this.textHint = ValueConst.reviewTextHint,
    required this.onSubmit,
    required this.onMessage,
  });

  @override
  State<DailyMartWriteReviewSheetContent> createState() =>
      _DailyMartWriteReviewSheetContentState();
}

class _DailyMartWriteReviewSheetContentState
    extends State<DailyMartWriteReviewSheetContent>
    with WriteReviewForm {
  @override
  int get initialRating => widget.initialRating;

  @override
  String get initialText => widget.initialText;

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
            style: DailyMartTextStyleConst.bodySmMedium(
              tt,
            ).copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          RatingStarsField(
            value: rating,
            onChanged: selectRating,
            color: DailyMartColorConst.ratingStar,
          ),
          const SizedBox(height: AppSpacing.lg),
          DailyMartFormField(
            label: widget.textLabel,
            controller: reviewController,
            hint: widget.textHint,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.xl2),
          DailyMartPrimaryButton(
            label: ValueConst.reviewSubmitLabel,
            onTap: submitReview,
          ),
        ],
      ),
    );
  }
}
