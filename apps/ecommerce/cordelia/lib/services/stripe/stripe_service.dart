import 'package:cordelia/feature/storefront/orders/domain/entities/payment_intent_entity.dart';
import 'package:cordelia/feature/storefront/orders/domain/entities/payment_result_entity.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// A Stripe checkout that ended without a captured payment. [isCancelled]
/// separates the shopper dismissing the sheet from a genuine failure, matching
/// [RazorpayFailure] so the gateway data sources translate identically.
class StripeFailure implements Exception {
  final String message;
  final bool isCancelled;

  const StripeFailure({required this.message, this.isCancelled = false});
}

/// Owns the Stripe SDK, as a static singleton like every other infrastructure
/// service here (never registered in GetIt).
///
/// Unlike [RazorpayService], which is handed the key on every call, Stripe's
/// publishable key is *global mutable SDK state* — so it has to be re-applied
/// per payment. That is deliberate and load-bearing in a multi-tenant app:
/// consecutive checkouts can be against two different stores with two
/// different Stripe accounts, and a key left over from the previous store
/// would fail to confirm this store's intent.
class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  /// Avoids re-applying settings (a platform channel round trip) when the
  /// shopper pays twice in a row at the same store.
  String? _appliedKey;

  Future<PaymentResultEntity> open(
    PaymentIntentEntity intent, {
    required String name,
  }) async {
    if (intent.clientSecret.isEmpty) {
      // The server said Stripe but sent no client secret — the sheet cannot
      // be opened, and failing here is clearer than a confusing SDK error.
      throw const StripeFailure(message: 'Payment could not be started');
    }

    try {
      if (_appliedKey != intent.publishableKey) {
        Stripe.publishableKey = intent.publishableKey;
        await Stripe.instance.applySettings();
        _appliedKey = intent.publishableKey;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intent.clientSecret,
          merchantDisplayName: name,
        ),
      );
      // Returns normally only once the payment is confirmed; a dismissal or a
      // decline throws StripeException.
      await Stripe.instance.presentPaymentSheet();

      // Stripe gives the client no separate charge reference, and the server
      // re-fetches this intent to verify it anyway — so the id it already
      // issued is the whole receipt. No signature: see PaymentResultEntity.
      return PaymentResultEntity(
        paymentOrderId: intent.paymentOrderId,
        paymentId: intent.paymentOrderId,
      );
    } on StripeException catch (e) {
      throw StripeFailure(
        message: e.error.localizedMessage ?? e.error.message ?? '',
        isCancelled: e.error.code == FailureCode.Canceled,
      );
    }
  }
}
