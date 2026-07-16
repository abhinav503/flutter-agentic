import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/usecase/usecase.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../../home/domain/usecase/get_home_usecase.dart';

part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

/// Loads only the "Before you Checkout" upsell rail — the cart's own items
/// come synchronously from the shared `CartCubit`, so this bloc never gates
/// the rest of the screen. Reuses the already-registered [GetHomeUseCase]
/// (its `popularProducts`) rather than a new mock data source.
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetHomeUseCase _getHome;

  CartBloc({required GetHomeUseCase getHomeUseCase})
    : _getHome = getHomeUseCase,
      super(const CartState.loading()) {
    on<CartStarted>(_onStarted);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    final result = await _getHome(const NoParams());
    result.fold(
      (failure) => emit(CartState.error(message: failure.message)),
      (home) => emit(CartState.loaded(suggestions: home.popularProducts)),
    );
  }
}
