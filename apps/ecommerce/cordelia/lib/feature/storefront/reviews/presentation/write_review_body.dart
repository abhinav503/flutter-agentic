import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/rating_stars.dart';

import 'package:cordelia/constants/value_const.dart';

/// The write-a-review sheet's body, shared by every template — prompt, the
/// star input, the pack's text field, then its CTA.
///
/// The counterpart to `WriteReviewForm`, which owns the rating, the
/// controller and the submit gate. A pack is left with one text style, its
/// star colour, its field and its button — no kit draws a review composer,
/// so there was never any per-pack structure here to keep.
class WriteReviewBody extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  /// The pack's own text field, already wired to the mixin's controller.
  final Widget field;

  /// The pack's submit control — a lone primary button, or a
  /// cancel/confirm pair.
  final Widget submit;

  final TextStyle promptStyle;

  /// Star tint; null keeps [RatingStarsField]'s own default.
  final Color? starColor;

  static const _defaultStars = RatingStars.defaultStarColor;

  /// The gate's complaint, or null while there is nothing to say — rendered
  /// just above the CTA that produced it, in `cs.error`.
  final String? errorMessage;

  /// True while the write is in the air. Taps on [submit] are absorbed
  /// rather than the control being restyled: each pack draws its own CTA,
  /// and a disabled look imposed from here would not be its own.
  final bool isSubmitting;

  /// Content inset. Zero for a pack whose sheet chrome already pads.
  final EdgeInsetsGeometry padding;

  const WriteReviewBody({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    required this.field,
    required this.submit,
    required this.promptStyle,
    this.starColor,
    this.errorMessage,
    this.isSubmitting = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ValueConst.reviewRatingPrompt, style: promptStyle),
        const SizedBox(height: AppSpacing.sm),
        RatingStarsField(
          value: rating,
          onChanged: onRatingChanged,
          color: starColor ?? _defaultStars,
        ),
        const SizedBox(height: AppSpacing.lg),
        field,
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
        AbsorbPointer(absorbing: isSubmitting, child: submit),
      ],
    ),
  );
}
