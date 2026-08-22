part of 'product_reviews_bloc.dart';

@freezed
sealed class ProductReviewsEvent with _$ProductReviewsEvent {
  /// Paints the section from what the product-details payload already
  /// carried, instead of fetching the same page a second time.
  const factory ProductReviewsEvent.seeded({
    required ProductReviewsEntity reviews,
  }) = ProductReviewsSeeded;

  /// Re-fetches from the reviews endpoint — the retry path, and how a
  /// screen picks up reviews written since it opened.
  const factory ProductReviewsEvent.refreshed() = ProductReviewsRefreshed;

  /// Writes (or replaces) the signed-in shopper's review.
  const factory ProductReviewsEvent.submitted({
    required int rating,
    required String text,
  }) = ProductReviewsSubmitted;

  const factory ProductReviewsEvent.mineDeleted() = ProductReviewsMineDeleted;

  /// Flags someone else's review for the store owner. [block] also hides
  /// that author's reviews from this shopper, which is why this reloads the
  /// list rather than just firing and forgetting.
  const factory ProductReviewsEvent.reported({
    required String reviewUid,
    required ReviewReportReason reason,
    required bool block,
  }) = ProductReviewsReported;
}
