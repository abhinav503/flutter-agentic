import 'package:flutter/foundation.dart' show debugPrint;
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/services/stripe/stripe_service.dart';

import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import 'payment_gateway_data_source.dart';

/// Stripe-backed [PaymentGatewayDataSource], the sibling of
/// [RazorpayGatewayDataSourceImpl]. One of only two files in the app that know
/// Stripe exists (the other being [StripeService]) — it translates the SDK's
/// outcome into provider-neutral types, so nothing above the data layer
/// changes when a store switches provider.
class StripeGatewayDataSourceImpl implements PaymentGatewayDataSource {
  const StripeGatewayDataSourceImpl();

  @override
  Future<PaymentResultEntity> processPayment(PaymentIntentEntity intent) async {
    try {
      return await StripeService.instance.open(
        intent,
        // The store the shopper is buying from — its Stripe account is the one
        // being paid, so its name is what the sheet must show. Falls back to
        // the app name only when the server sent none.
        name: intent.storeName.isNotEmpty
            ? intent.storeName
            : ValueConst.appTitle,
      );
    } on StripeFailure catch (e) {
      // `e.message` is the provider's own wording — English whatever the
      // storefront's language, and written for a developer. It goes to the
      // log; the shopper gets this app's sentence.
      debugPrint('payment failed: ${e.message}');
      throw PaymentGatewayException(
        message: e.isCancelled
            ? ValueConst.paymentCancelledMessage
            : ValueConst.paymentFailedMessage,
        cancelled: e.isCancelled,
      );
    }
  }
}
