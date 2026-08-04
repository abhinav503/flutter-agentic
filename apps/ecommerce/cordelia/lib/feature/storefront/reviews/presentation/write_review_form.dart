import 'package:flutter/widgets.dart';

import '../domain/entities/review_entity.dart';

/// Everything a write-review sheet does that isn't pack chrome — the chosen
/// star count, the text controller seeded from an existing review, the
/// "pick a rating first" gate, and the submit.
///
/// Each template renders its own sheet body over this, so the form's
/// behaviour can't drift between packs (same shape as [EditProfileForm] and
/// `QuantitySelection`).
///
/// The sheet never touches a bloc: it calls [onSubmit] and the screen that
/// opened it dispatches, the same callback split every pack's add-to-cart
/// and confirm sheet already uses.
mixin WriteReviewForm<T extends StatefulWidget> on State<T> {
  /// The shopper's current review when they're editing one, null when
  /// writing their first — implemented by the sheet as `widget.existing`.
  ReviewEntity? get existingReview;

  void Function(int rating, String text) get onSubmit;

  /// Shown when submit is tapped with no star picked.
  String get missingRatingMessage;

  /// The pack's own way of surfacing that message (a snackbar on the host
  /// screen, usually) — a sheet has no `BaseScreenState` of its own.
  void showFormMessage(String message);

  late final reviewController = TextEditingController(
    text: existingReview?.text ?? '',
  );

  /// 0 until a star is tapped, which is what keeps submit gated on a first
  /// write. Editing starts on the review's existing rating.
  late int rating = existingReview?.rating ?? 0;

  bool get hasRating => rating > 0;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  void selectRating(int value) => setState(() => rating = value);

  /// Validates, hands the review to the host, and closes the sheet. The text
  /// is optional — a star-only review is a real review — but the rating
  /// isn't: without it there is nothing to average.
  void submitReview() {
    if (!hasRating) {
      showFormMessage(missingRatingMessage);
      return;
    }
    onSubmit(rating, reviewController.text.trim());
    Navigator.of(context).pop();
  }
}
