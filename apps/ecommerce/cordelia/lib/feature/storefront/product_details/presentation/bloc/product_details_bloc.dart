import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../../domain/usecase/get_product_details_usecase.dart';

part 'product_details_bloc.freezed.dart';
part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetails;

  ProductDetailsBloc({
    required GetProductDetailsUseCase getProductDetailsUseCase,
  }) : _getProductDetails = getProductDetailsUseCase,
       super(const ProductDetailsState.loading()) {
    on<ProductDetailsStarted>(_onStarted);
    on<ProductDetailsRefreshed>(_onRefreshed);
  }

  Future<void> _onStarted(
    ProductDetailsStarted event,
    Emitter<ProductDetailsState> emit,
  ) => _load(event.storeId, event.productId, emit);

  Future<void> _onRefreshed(
    ProductDetailsRefreshed event,
    Emitter<ProductDetailsState> emit,
  ) => _load(event.storeId, event.productId, emit, silent: true);

  /// Shared by the first load and the silent refresh — a private method
  /// rather than one handler re-dispatching the other's event.
  ///
  /// [silent] is what makes a background refresh invisible: the screen is
  /// already showing a good page, so a failure leaves it alone instead of
  /// replacing it with an error view, and success repaints in place. The
  /// bloc never emits `loading` here, which is what keeps the skeleton from
  /// flashing over a page the shopper is already reading.
  Future<void> _load(
    String storeId,
    String productId,
    Emitter<ProductDetailsState> emit, {
    bool silent = false,
  }) async {
    final result = await _getProductDetails(
      GetProductDetailsParams(storeId: storeId, productId: productId),
    );
    result.fold(
      (failure) {
        if (silent) return;
        emit(
          ProductDetailsState.error(
            message: failure.message,
            storeId: storeId,
            productId: productId,
          ),
        );
      },
      (detail) => emit(ProductDetailsState.loaded(detail: detail)),
    );
  }
}
