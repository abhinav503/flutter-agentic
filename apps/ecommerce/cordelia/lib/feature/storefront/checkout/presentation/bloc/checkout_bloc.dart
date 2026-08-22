import 'package:core/core/error/failure.dart';

import 'package:cordelia/enums/checkout_refusal_code.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/order_entity.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/payment_result_entity.dart';
import 'package:cordelia/feature/storefront/orders/domain/usecase/create_order_usecase.dart';
import 'package:cordelia/feature/storefront/orders/domain/usecase/create_payment_usecase.dart';
import 'package:cordelia/feature/storefront/orders/domain/usecase/process_payment_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/feature/storefront/cart/domain/entities/cart_item_entity.dart';

part 'checkout_bloc.freezed.dart';
part 'checkout_event.dart';
part 'checkout_state.dart';

/// Places the order. Its own feature rather than part of `cart/`: checkout is
/// a distinct request/response concern with its own states, it now has its own
/// screen and route in the `dailymart` template, and one BLoC per feature is
/// the rule. The domain/data it drives stay in `orders/` — this is
/// presentation only.
///
/// Hosted two ways, because the templates differ: `dailymart` scopes it to its
/// pushed Checkout route, while `gravia` (which has no checkout screen yet)
/// still provides it above its Cart screen and runs the flow inline.
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
  final String storeId;

  CheckoutBloc({
    required CreatePaymentUseCase createPaymentUseCase,
    required ProcessPaymentUseCase processPaymentUseCase,
    required CreateOrderUseCase createOrderUseCase,
    required this.storeId,
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
      await _placeOrder(event, null, emit);
      return;
    }

    final intentResult = await _createPayment(
      CreatePaymentParams(
        storeId: storeId,
        items: event.items,
        addressId: event.addressId,
        couponCode: event.couponCode,
      ),
    );
    await intentResult.fold(
      (failure) async => _emitFailure(emit, failure, event),
      (intent) async {
        final paymentResult = await _processPayment(
          ProcessPaymentParams(intent: intent),
        );
        await paymentResult.fold(
          (failure) async => _emitFailure(emit, failure, event),
          (payment) async => _placeOrder(event, payment, emit),
        );
      },
    );
  }

  Future<void> _placeOrder(
    CheckoutSubmitted event,
    PaymentResultEntity? payment,
    Emitter<CheckoutState> emit,
  ) async {
    final result = await _createOrder(
      CreateOrderParams(
        storeId: storeId,
        items: event.items,
        addressId: event.addressId,
        payment: payment,
        couponCode: event.couponCode,
      ),
    );
    result.fold(
      (failure) => _emitFailure(emit, failure, event),
      (order) => emit(CheckoutState.success(order: order)),
    );
  }

  /// The one place a [Failure] becomes a screen-facing state. A refusal the
  /// server named keeps that name here, parsed once, so no screen re-reads
  /// a wire string.
  void _emitFailure(
    Emitter<CheckoutState> emit,
    Failure failure,
    CheckoutSubmitted event,
  ) => emit(
    CheckoutState.failure(
      message: failure.message,
      code: switch (failure) {
        RefusedFailure(:final code) => code.toCheckoutRefusalCode(),
        _ => CheckoutRefusalCode.other,
      },
      items: event.items,
      addressId: event.addressId,
      couponCode: event.couponCode,
    ),
  );
}
