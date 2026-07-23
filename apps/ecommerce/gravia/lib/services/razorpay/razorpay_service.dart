import 'dart:async';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:gravia/feature/orders/domain/entities/payment_intent_entity.dart';
import 'package:gravia/feature/orders/domain/entities/payment_result_entity.dart';

class RazorpayFailure implements Exception {
  final int code;
  final String message;

  const RazorpayFailure({required this.code, required this.message});

  bool get isCancelled => code == Razorpay.PAYMENT_CANCELLED;
}

class RazorpayService {
  RazorpayService._();
  static final RazorpayService instance = RazorpayService._();
  Future<PaymentResultEntity> open(
    PaymentIntentEntity intent, {
    required String name,
    String? email,
    String? contact,
  }) {
    final razorpay = Razorpay();
    final completer = Completer<PaymentResultEntity>();

    void disposeLater() => scheduleMicrotask(razorpay.clear);

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse r) {
      disposeLater();
      if (completer.isCompleted) return;
      completer.complete(
        PaymentResultEntity(
          razorpayOrderId: r.orderId ?? intent.razorpayOrderId,
          razorpayPaymentId: r.paymentId ?? '',
          razorpaySignature: r.signature ?? '',
        ),
      );
    });

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse r) {
      disposeLater();
      if (completer.isCompleted) return;
      completer.completeError(
        RazorpayFailure(
          code: r.code ?? Razorpay.UNKNOWN_ERROR,
          message: r.message ?? 'Payment failed',
        ),
      );
    });

    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});

    final prefill = <String, dynamic>{
      if (email != null && email.isNotEmpty) 'email': email,
      if (contact != null && contact.isNotEmpty) 'contact': contact,
    };

    razorpay.open({
      'key': intent.razorpayKeyId,
      'order_id': intent.razorpayOrderId,
      'amount': intent.amount,
      'currency': intent.currency,
      'name': name,
      if (prefill.isNotEmpty) 'prefill': prefill,
    });

    return completer.future;
  }
}
