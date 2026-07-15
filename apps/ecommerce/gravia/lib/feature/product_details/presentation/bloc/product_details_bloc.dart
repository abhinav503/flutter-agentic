import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../../domain/usecase/get_product_details_usecase.dart';

part 'product_details_bloc.freezed.dart';
part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetails;

  ProductDetailsBloc({required GetProductDetailsUseCase getProductDetailsUseCase})
      : _getProductDetails = getProductDetailsUseCase,
        super(const ProductDetailsState.loading()) {
    on<ProductDetailsStarted>(_onStarted);
    on<ProductDetailsFavouriteToggled>(_onFavouriteToggled);
  }

  Future<void> _onStarted(
    ProductDetailsStarted event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final result = await _getProductDetails(
      GetProductDetailsParams(productId: event.productId),
    );
    result.fold(
      (failure) => emit(
        ProductDetailsState.error(message: failure.message, productId: event.productId),
      ),
      (detail) => emit(ProductDetailsState.loaded(detail: detail)),
    );
  }

  void _onFavouriteToggled(
    ProductDetailsFavouriteToggled event,
    Emitter<ProductDetailsState> emit,
  ) {
    switch (state) {
      case ProductDetailsLoaded(:final detail):
        final isFavourite = !detail.product.isFavourite;
        emit(ProductDetailsState.loaded(detail: detail.copyWith(isFavourite: isFavourite)));
      case ProductDetailsLoading():
      case ProductDetailsError():
        break;
    }
  }
}
