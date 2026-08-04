import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_screen.dart';

import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/services/firebase_auth_service.dart';

import '../../product_details/presentation/bloc/product_details_bloc.dart';
import '../domain/entities/product_reviews_entity.dart';
import '../domain/entities/review_entity.dart';
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

  /// The signed-in shopper's uid, or null — what tells their own review
  /// apart from everyone else's in a loaded list.
  String? get currentUid => FirebaseAuthService.instance.currentUser?.uid;

  /// The write CTA's entry point. A signed-out shopper is told to sign in
  /// rather than shown a sheet whose submit would 401 — the reviews *list*
  /// stays readable either way, since reading needs no account.
  Future<void> writeReview(ReviewEntity? existing) async {
    if (currentUid == null) {
      showSnackBar(ValueConst.reviewSignedOutMessage);
      return;
    }
    await showWriteReviewSheet(existing);
  }

  void submitReview(int rating, String text) => context
      .read<ProductReviewsBloc>()
      .add(ProductReviewsEvent.submitted(rating: rating, text: text));

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
      case ProductReviewsError(:final message):
        showSnackBar(message);
      case ProductReviewsLoaded(:final afterWrite) when afterWrite:
        _refreshProduct();
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
