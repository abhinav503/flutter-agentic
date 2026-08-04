import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'product_reviews_bloc.dart';

/// The canonical [ProductReviewsBloc] construction, shared by every
/// template's Product Details page so the wiring can't drift per pack.
///
/// Wraps the whole screen rather than just the reviews section: the write
/// sheet is opened from the screen's own `BaseScreenState`, which has to be
/// under the provider to dispatch.
///
/// No `started` dispatch — the bloc opens in `loading` and the screen seeds
/// it from the product-details payload it is already loading
/// (`ProductReviewsEvent.seeded`), so the first page of reviews costs no
/// second request.
BlocProvider<ProductReviewsBloc> productReviewsBlocProvider({
  required String storeId,
  required String productId,
  required Widget child,
}) => BlocProvider(
  create: (_) => ProductReviewsBloc(
    getProductReviewsUseCase: sl(),
    submitProductReviewUseCase: sl(),
    deleteMyReviewUseCase: sl(),
    storeId: storeId,
    productId: productId,
  ),
  child: child,
);
