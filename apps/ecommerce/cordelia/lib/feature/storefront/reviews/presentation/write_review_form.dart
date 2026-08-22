import 'package:flutter/widgets.dart';

/// Everything a rating sheet does that isn't pack chrome — the chosen star
/// count, the text controller seeded from what was written before, the
/// "pick a rating first" gate, and the submit.
///
/// Serves **both** things a shopper rates: a product (its reviews section)
/// and a delivered order (My Orders / Track Order). They differ only in
/// where the initial values come from and what the submit dispatches, so
/// each template needs one sheet body, not two.
///
/// Each template renders its own body over this, so the form's behaviour
/// can't drift between packs (same shape as [EditProfileForm] and
/// `QuantitySelection`).
///
/// The sheet never touches a bloc: it calls [onSubmit] and the screen that
/// opened it dispatches, the same callback split every pack's add-to-cart
/// and confirm sheet already uses.
mixin WriteReviewForm<T extends StatefulWidget> on State<T> {
  /// What was rated before — 0 and '' when nothing was.
  int get initialRating;
  String get initialText;

  /// Performs the write and resolves to the failure message, or null once
  /// it landed. A `Future` rather than fire-and-forget so the sheet can stay
  /// open when it fails: the shopper's words are in this widget, and popping
  /// first threw them away and then told them it hadn't worked.
  Future<String?> Function(int rating, String text) get onSubmit;

  /// Shown when submit is tapped with no star picked.
  String get missingRatingMessage;

  /// The gate's complaint, or null while there is nothing to say.
  ///
  /// Held here and rendered *inside* the sheet rather than sent to the host
  /// screen's `showSnackBar`: a snack bar belongs to the Scaffold underneath,
  /// so a modal sheet covers it completely — the shopper tapped submit and
  /// nothing appeared to happen. Cleared the moment they act on it.
  String? formError;

  late final reviewController = TextEditingController(text: initialText);

  /// 0 until a star is tapped, which is what keeps submit gated on a first
  /// write. Editing starts on the existing rating.
  late int rating = initialRating;

  bool get hasRating => rating > 0;

  /// True while the write is in the air — the body absorbs taps on the CTA
  /// so a slow network can't post the same review twice.
  bool submitting = false;

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  void selectRating(int value) => setState(() {
    rating = value;
    formError = null;
  });

  /// Validates, hands the review to the host, and closes the sheet. The text
  /// is optional — a star-only review is a real review — but the rating
  /// isn't: without it there is nothing to average.
  Future<void> submitReview() async {
    if (!hasRating) {
      setState(() => formError = missingRatingMessage);
      return;
    }
    setState(() {
      submitting = true;
      formError = null;
    });

    final failure = await onSubmit(rating, reviewController.text.trim());
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
