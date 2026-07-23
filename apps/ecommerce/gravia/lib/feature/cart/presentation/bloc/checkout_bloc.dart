import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gravia/feature/orders/domain/entities/order_entity.dart';
import 'package:gravia/feature/orders/domain/entities/payment_result_entity.dart';
import 'package:gravia/feature/orders/domain/usecase/create_order_usecase.dart';
import 'package:gravia/feature/orders/domain/usecase/create_payment_usecase.dart';
import 'package:gravia/feature/orders/domain/usecase/process_payment_usecase.dart';

import '../../domain/entities/cart_item_entity.dart';

part 'checkout_bloc.freezed.dart';
part 'checkout_event.dart';
part 'checkout_state.dart';

/// Drives the Cart screen's "Proceed to Checkout" CTA — deliberately separate
/// from [CartBloc] (which only loads the "Before you Checkout" suggestions
/// rail): checkout is a distinct request/response concern with its own
/// states, not something that fits [CartBloc]'s 3-state shape.
///
/// On **mobile** it's the full secure flow, orchestrated end to end here:
/// create a payment intent → run it through the payment provider
/// ([ProcessPaymentUseCase]) → place the order with the verified result. The
/// provider is never named at this layer — it's just a use case. On **web**
/// there's no native checkout SDK, so it places a test-mode order directly
/// (the server allows a payment-less order only for a test-key store), keeping
/// the whole checkout flow exercisable in the web preview.
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreatePaymentUseCase _createPayment;
  final ProcessPaymentUseCase _processPayment;
  final CreateOrderUseCase _createOrder;

  CheckoutBloc({
    required CreatePaymentUseCase createPaymentUseCase,
    required ProcessPaymentUseCase processPaymentUseCase,
    required CreateOrderUseCase createOrderUseCase,
  }) : _createPayment = createPaymentUseCase,
       _processPayment = processPaymentUseCase,
       _createOrder = createOrderUseCase,
       super(const CheckoutState.idle()) {
    on<CheckoutSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutState.submitting());

    // Web preview: no native checkout SDK — place the order straight away.
    if (kIsWeb) {
      await _placeOrder(event.items, event.addressId, null, emit);
      return;
    }

    final intentResult = await _createPayment(
      CreatePaymentParams(items: event.items, addressId: event.addressId),
    );
    await intentResult.fold(
      (failure) async => _emitFailure(emit, failure.message, event),
      (intent) async {
        final paymentResult = await _processPayment(
          ProcessPaymentParams(intent: intent),
        );
        await paymentResult.fold(
          (failure) async => _emitFailure(emit, failure.message, event),
          (payment) async =>
              _placeOrder(event.items, event.addressId, payment, emit),
        );
      },
    );
  }

  Future<void> _placeOrder(
    List<CartItemEntity> items,
    String addressId,
    PaymentResultEntity? payment,
    Emitter<CheckoutState> emit,
  ) async {
    final result = await _createOrder(
      CreateOrderParams(items: items, addressId: addressId, payment: payment),
    );
    result.fold(
      (failure) => emit(
        CheckoutState.failure(
          message: failure.message,
          items: items,
          addressId: addressId,
        ),
      ),
      (order) => emit(CheckoutState.success(order: order)),
    );
  }

  void _emitFailure(
    Emitter<CheckoutState> emit,
    String message,
    CheckoutSubmitted event,
  ) => emit(
    CheckoutState.failure(
      message: message,
      items: event.items,
      addressId: event.addressId,
    ),
  );
}
