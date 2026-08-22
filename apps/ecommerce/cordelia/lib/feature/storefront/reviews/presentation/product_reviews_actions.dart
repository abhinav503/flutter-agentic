import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/feature/auth/presentation/sign_in_gate.dart';
import 'package:core/core/auth/auth_session.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../product_details/presentation/bloc/product_details_bloc.dart';
import '../domain/entities/product_reviews_entity.dart';
import '../domain/entities/review_entity.dart';
import 'package:cordelia/enums/review_report_reason.dart';
import 'bloc/product_reviews_bloc.dart';

/// The reviews behaviour every template's Product Details repeats
/// identically — seeding the section from the details payload, the
/// signed-in gate on writing, the submit/delete dispatches, and the
/// success/error feedback. Only the sheet chrome and the section layout
/// differ per pack, so those stay as the two overrides below.
///
/// Sits beside `ProductDetailsActions`, which it mirrors: hosts declare
/// `with QuantitySelection, ProductDetailsActions, ProductReviewsActions`.
mixin ProductReviewsActions<T extends BaseScreen> on BaseScreenState<T> {
  /// The pack's own write-review sheet, showing [existing] when the shopper
  /// is editing. Implementations hand [submitReview] to their sheet body.
  Future<void> showWriteReviewSheet(ReviewEntity? existing);

  /// The pack's own confirm sheet for removing the shopper's own review.
  Future<void> showDeleteReviewSheet({required VoidCallback onConfirm});

  /// The pack's own report sheet for someone *else's* review.
  /// Implementations hand [submitReport] to their sheet body.
  Future<void> showReportReviewSheet(ReviewEntity review);

  /// The signed-in shopper's uid, or null — what tells their own review
  /// apart from everyone else's in a loaded list.
  String? get currentUid => sl<AuthSession>().currentUid;

  /// The write CTA's entry point. A guest meets Login first and comes back
  /// to this product — the reviews *list* stays readable either way, since
  /// reading needs no account.
  Future<void> writeReview(ReviewEntity? existing) async {
    if (!await context.requireSignIn() || !mounted) return;
    await showWriteReviewSheet(existing);
  }

  /// The report CTA's entry point, the mirror of [writeReview]: reporting
  /// is a write, so a guest meets the same gate.
  Future<void> reportReview(ReviewEntity review) async {
    if (!await context.requireSignIn() || !mounted) return;
    await showReportReviewSheet(review);
  }

  Future<String?> submitReport(
    String reviewUid,
    ReviewReportReason reason,
    bool block,
  ) => _dispatchAndAwait(
    ProductReviewsEvent.reported(
      reviewUid: reviewUid,
      reason: reason,
      block: block,
    ),
  );

  Future<String?> submitReview(int rating, String text) => _dispatchAndAwait(
    ProductReviewsEvent.submitted(rating: rating, text: text),
  );

  /// Dispatches a write and resolves to its failure message, or null once it
  /// landed — the contract the sheets need to decide whether to close.
  ///
  /// Subscribing *before* dispatching, not after: `add` is synchronous and
  /// the handler's first `emit` can land in the same turn, which a later
  /// listener would miss and then wait forever for.
  ///
  /// Both write handlers always settle — `submitting` first, then `loaded`
  /// or `error` — so this can't hang. A handler that could decline to emit
  /// would need a different signal (see `OrderReviewActions`, whose bloc
  /// can).
  Future<String?> _dispatchAndAwait(ProductReviewsEvent event) async {
    final bloc = context.read<ProductReviewsBloc>();
    final settled = bloc.stream.firstWhere(
      (state) => state is! ProductReviewsSubmitting,
    );
    bloc.add(event);
    final state = await settled;
    return state is ProductReviewsError ? state.message : null;
  }

  Future<void> confirmDeleteReview() => showDeleteReviewSheet(
    onConfirm: () => context.read<ProductReviewsBloc>().add(
      const ProductReviewsEvent.mineDeleted(),
    ),
  );

  /// Paints the section from the reviews the product-details payload already
  /// carried, instead of fetching that same first page again.
  void seedReviews(ProductReviewsEntity reviews) => context
      .read<ProductReviewsBloc>()
      .add(ProductReviewsEvent.seeded(reviews: reviews));

  /// The reviews `BlocListener` body — a write's outcome is a side effect,
  /// never a rebuild, so it lives here rather than in a builder.
  ///
  /// A completed write also refreshes the *product*: the rating shown beside
  /// its name (dailymart's pill, grofast's badge) reads the product doc's
  /// aggregates, which this bloc's own reload can't touch. The refresh is
  /// silent — no `loading`, so no skeleton flashes over the page the shopper
  /// is reading; the pill just updates in place when the response lands.
  void handleReviewsState(ProductReviewsState state) {
    switch (state) {
      // A sheet that is still open prints its own failure inline, keeping
      // what the shopper typed. Snackbarring it too would put a duplicate
      // under the modal barrier — unseen while it matters, and stale by the
      // time the sheet closes.
      case ProductReviewsError(:final message, :final shownInSheet)
          when !shownInSheet:
        showSnackBar(message);
      case ProductReviewsError():
        break;
      case ProductReviewsLoaded(:final afterWrite) when afterWrite:
        _refreshProduct();
      // Nothing to refresh — a report changes no rating. The shopper is
      // told their complaint landed, because the review stays on screen
      // until the owner acts and silence would read as a failure.
      case ProductReviewsLoaded(:final afterReport) when afterReport:
        showSnackBar(ValueConst.reportReviewSuccessMessage);
      case ProductReviewsLoading():
      case ProductReviewsSubmitting():
      case ProductReviewsLoaded():
        break;
    }
  }

  // The reviews bloc is the only thing here holding both ids — the details
  // screen itself is constructed with just the storeId.
  void _refreshProduct() {
    final reviews = context.read<ProductReviewsBloc>();
    context.read<ProductDetailsBloc>().add(
      ProductDetailsEvent.refreshed(
        storeId: reviews.storeId,
        productId: reviews.productId,
      ),
    );
  }
}
