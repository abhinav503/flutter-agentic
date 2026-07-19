import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/feature/orders/domain/entities/order_entity.dart';
import 'package:gravia/feature/orders/domain/usecase/create_order_usecase.dart';

import '../../domain/entities/cart_item_entity.dart';

part 'checkout_bloc.freezed.dart';
part 'checkout_event.dart';
part 'checkout_state.dart';

/// Places the order the Cart screen's "Proceed to Checkout" CTA submits —
/// deliberately separate from [CartBloc] (which only loads the "Before you
/// Checkout" suggestions rail): submitting an order is a distinct
/// request/response concern with its own loading/success/failure states,
/// not something that fits [CartBloc]'s existing 3-state shape without
/// conflating the two.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreateOrderUseCase _createOrder;

  CheckoutBloc({required CreateOrderUseCase createOrderUseCase})
    : _createOrder = createOrderUseCase,
      super(const CheckoutState.idle()) {
    on<CheckoutSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutState.submitting());
    final result = await _createOrder(event.items);
    result.fold(
      (failure) => emit(
        CheckoutState.failure(message: failure.message, items: event.items),
      ),
      (order) => emit(CheckoutState.success(order: order)),
    );
  }
}
