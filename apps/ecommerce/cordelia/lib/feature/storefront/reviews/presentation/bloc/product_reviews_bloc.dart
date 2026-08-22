import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_reviews_entity.dart';
import '../../domain/entities/review_report_reason.dart';
import '../../domain/usecase/delete_my_review_usecase.dart';
import '../../domain/usecase/get_product_reviews_usecase.dart';
import '../../domain/usecase/report_review_usecase.dart';
import '../../domain/usecase/submit_product_review_usecase.dart';

part 'product_reviews_bloc.freezed.dart';
part 'product_reviews_event.dart';
part 'product_reviews_state.dart';

/// Owns one product's reviews: the list, the summary above it, and the
/// signed-in shopper's write/edit/delete.
///
/// Seeded rather than fetched on open — the product-details payload already
/// carries the first page and the summary, so [ProductReviewsSeeded] paints
/// the section with zero extra calls. Every *write* then reloads from the
/// reviews endpoint instead of patching the seed: a new review changes the
/// list's order and the histogram, and re-deriving those client-side is how
/// a screen ends up disagreeing with the backend.
class ProductReviewsBloc
    extends Bloc<ProductReviewsEvent, ProductReviewsState> {
  final GetProductReviewsUseCase _getProductReviews;
  final SubmitProductReviewUseCase _submitReview;
  final DeleteMyReviewUseCase _deleteMyReview;
  final ReportReviewUseCase _reportReview;

  /// The product this bloc reviews, held here so no state has to carry it
  /// for a retry (same shape as CartBloc/CheckoutBloc's storeId).
  final String storeId;
  final String productId;

  ProductReviewsBloc({
    required GetProductReviewsUseCase getProductReviewsUseCase,
    required SubmitProductReviewUseCase submitProductReviewUseCase,
    required DeleteMyReviewUseCase deleteMyReviewUseCase,
    required ReportReviewUseCase reportReviewUseCase,
    required this.storeId,
    required this.productId,
  }) : _getProductReviews = getProductReviewsUseCase,
       _submitReview = submitProductReviewUseCase,
       _deleteMyReview = deleteMyReviewUseCase,
       _reportReview = reportReviewUseCase,
       super(const ProductReviewsState.loading()) {
    on<ProductReviewsSeeded>(_onSeeded);
    on<ProductReviewsRefreshed>(_onRefreshed);
    on<ProductReviewsSubmitted>(_onSubmitted);
    on<ProductReviewsMineDeleted>(_onMineDeleted);
    on<ProductReviewsReported>(_onReported);
  }

  void _onSeeded(
    ProductReviewsSeeded event,
    Emitter<ProductReviewsState> emit,
  ) {
    // Seeding is first paint, not a reset. A silent product refresh re-emits
    // the details payload, whose review list is only the first page — by
    // then this bloc may hold a longer, fresher one it just reloaded, and
    // re-seeding would truncate it.
    if (state.reviewsOrNull != null) return;
    emit(ProductReviewsState.loaded(reviews: event.reviews));
  }

  Future<void> _onRefreshed(
    ProductReviewsRefreshed event,
    Emitter<ProductReviewsState> emit,
  ) async {
    emit(const ProductReviewsState.loading());
    await _reload(emit);
  }

  Future<void> _onSubmitted(
    ProductReviewsSubmitted event,
    Emitter<ProductReviewsState> emit,
  ) async {
    // Keeps the current list on screen behind the submitting flag — the
    // shopper is looking at the reviews they just added to, and blanking
    // them to a skeleton mid-write reads as data loss.
    emit(ProductReviewsState.submitting(reviews: state.reviewsOrNull));

    final result = await _submitReview(
      SubmitProductReviewParams(
        storeId: storeId,
        productId: productId,
        rating: event.rating,
        text: event.text,
      ),
    );
    await result.fold(
      (failure) async => emit(
        ProductReviewsState.error(
          message: failure.message,
          reviews: state.reviewsOrNull,
        ),
      ),
      (_) => _reload(emit, afterWrite: true),
    );
  }

  Future<void> _onMineDeleted(
    ProductReviewsMineDeleted event,
    Emitter<ProductReviewsState> emit,
  ) async {
    emit(ProductReviewsState.submitting(reviews: state.reviewsOrNull));

    final result = await _deleteMyReview(
      DeleteMyReviewParams(storeId: storeId, productId: productId),
    );
    await result.fold(
      (failure) async => emit(
        ProductReviewsState.error(
          message: failure.message,
          reviews: state.reviewsOrNull,
        ),
      ),
      (_) => _reload(emit, afterWrite: true),
    );
  }

  Future<void> _onReported(
    ProductReviewsReported event,
    Emitter<ProductReviewsState> emit,
  ) async {
    emit(ProductReviewsState.submitting(reviews: state.reviewsOrNull));

    final result = await _reportReview(
      ReportReviewParams(
        storeId: storeId,
        productId: productId,
        reviewUid: event.reviewUid,
        reason: event.reason,
        block: event.block,
      ),
    );
    await result.fold(
      (failure) async => emit(
        ProductReviewsState.error(
          message: failure.message,
          reviews: state.reviewsOrNull,
        ),
      ),
      // Reloaded rather than left alone: a report that also blocked the
      // author has to take their reviews off the screen, and the server is
      // what decides which those are.
      (_) => _reload(emit, afterReport: true),
    );
  }

  // Shared by every path that needs the canonical list back — a private
  // method rather than a re-dispatched event, per the BLoC conventions.
  Future<void> _reload(
    Emitter<ProductReviewsState> emit, {
    bool afterWrite = false,
    bool afterReport = false,
  }) async {
    final result = await _getProductReviews(
      GetProductReviewsParams(storeId: storeId, productId: productId),
    );
    result.fold(
      (failure) => emit(
        ProductReviewsState.error(
          message: failure.message,
          reviews: state.reviewsOrNull,
        ),
      ),
      (reviews) => emit(
        ProductReviewsState.loaded(
          reviews: reviews,
          afterWrite: afterWrite,
          afterReport: afterReport,
        ),
      ),
    );
  }
}
