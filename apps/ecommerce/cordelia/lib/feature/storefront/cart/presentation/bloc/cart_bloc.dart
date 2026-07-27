import 'package:cordelia/feature/storefront/home/domain/entities/product_entity.dart';
import 'package:cordelia/feature/storefront/home/domain/usecase/get_home_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'cart_bloc.freezed.dart';
part 'cart_event.dart';
part 'cart_state.dart';

/// Loads only the "Before you Checkout" upsell rail — the cart's own items
/// come synchronously from the shared `CartCubit`, so this bloc never gates
/// the rest of the screen. Reuses the already-registered [GetHomeUseCase]
/// (its `popularProducts`) rather than a new mock data source.
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetHomeUseCase _getHome;
  final String storeId;

  CartBloc({required GetHomeUseCase getHomeUseCase, required this.storeId})
    : _getHome = getHomeUseCase,
      super(const CartState.loading()) {
    on<CartStarted>(_onStarted);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    final result = await _getHome(GetHomeParams(storeId: storeId));
    result.fold(
      (failure) => emit(CartState.error(message: failure.message)),
      (home) => emit(CartState.loaded(suggestions: home.popularProducts)),
    );
  }
}
