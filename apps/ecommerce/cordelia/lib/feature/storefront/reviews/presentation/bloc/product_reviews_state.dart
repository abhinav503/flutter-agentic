part of 'product_reviews_bloc.dart';

@freezed
sealed class ProductReviewsState with _$ProductReviewsState {
  const factory ProductReviewsState.loading() = ProductReviewsLoading;

  /// [afterWrite] marks the reload that followed the shopper's own write —
  /// the screen uses it to refresh the product silently, since the rating
  /// beside its name lives on the product doc, not in this list. It rides on
  /// the state (rather than the screen remembering a write was in flight)
  /// so the bloc stays the one thing that knows what just happened.
  /// [afterReport] marks the reload that followed a report. Separate from
  /// [afterWrite] because the two ask for different things: a write changes
  /// the product's rating and needs it refreshed, a report changes neither
  /// and only needs the shopper thanked.
  const factory ProductReviewsState.loaded({
    required ProductReviewsEntity reviews,
    @Default(false) bool afterWrite,
    @Default(false) bool afterReport,
  }) = ProductReviewsLoaded;

  /// A write is in flight. Carries the list that was on screen when it
  /// started (null only if the write began before anything loaded) so the
  /// section stays readable behind the busy CTA.
  const factory ProductReviewsState.submitting({
    ProductReviewsEntity? reviews,
  }) = ProductReviewsSubmitting;

  /// Carries the last-known list too: a failed write must not blank out the
  /// reviews the shopper was reading. The bloc holds storeId/productId
  /// itself, so retrying needs nothing from the state.
  ///
  /// [shownInSheet] means a still-open sheet is already printing [message]
  /// inline, so the screen must not snackbar it as well — a snackbar under
  /// a modal barrier is invisible while it matters and stale by the time it
  /// isn't. True for a failed write or report, false for anything the
  /// shopper is watching the screen for.
  const factory ProductReviewsState.error({
    required String message,
    ProductReviewsEntity? reviews,
    @Default(false) bool shownInSheet,
  }) = ProductReviewsError;
}

extension ProductReviewsStateX on ProductReviewsState {
  /// The list to render in any state that has one — what lets a screen show
  /// reviews while a write is in flight, or after one failed.
  ProductReviewsEntity? get reviewsOrNull => switch (this) {
    ProductReviewsLoading() => null,
    ProductReviewsLoaded(:final reviews) => reviews,
    ProductReviewsSubmitting(:final reviews) => reviews,
    ProductReviewsError(:final reviews) => reviews,
  };

  bool get isSubmitting => this is ProductReviewsSubmitting;
}
