import 'package:flutter/foundation.dart' show debugPrint;
import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:cordelia/services/razorpay/razorpay_service.dart';

import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import 'payment_gateway_data_source.dart';

/// Razorpay-backed [PaymentGatewayDataSource]. The only file in the app that
/// knows the provider is Razorpay — reaches the SDK via the
/// [RazorpayService] singleton and translates its outcome into
/// provider-neutral types ([PaymentResultEntity] / [PaymentGatewayException]).
/// Swapping providers means writing a sibling impl and re-pointing DI; no
/// caller changes.
class RazorpayGatewayDataSourceImpl implements PaymentGatewayDataSource {
  const RazorpayGatewayDataSourceImpl();

  @override
  Future<PaymentResultEntity> processPayment(PaymentIntentEntity intent) async {
    try {
      return await RazorpayService.instance.open(
        intent,
        // The store the shopper is buying from — its Razorpay account is the
        // one being paid, so its name is what the sheet must show. Falls back
        // to the app name only when the server sent none.
        name: intent.storeName.isNotEmpty
            ? intent.storeName
            : ValueConst.appTitle,
        email: FirebaseAuthService.instance.currentUser?.email,
      );
    } on RazorpayFailure catch (e) {
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
