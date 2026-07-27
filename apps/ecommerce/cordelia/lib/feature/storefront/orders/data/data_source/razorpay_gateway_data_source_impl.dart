import 'package:cordelia/constants/value_const.dart';
import 'package:cordelia/services/firebase_auth_service.dart';
import 'package:cordelia/services/razorpay/razorpay_service.dart';
import 'package:cordelia/templates/gravia/constants/gravia_value_const.dart';

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
        name: ValueConst.appTitle,
        email: FirebaseAuthService.instance.currentUser?.email,
      );
    } on RazorpayFailure catch (e) {
      throw PaymentGatewayException(
        message: e.isCancelled
            ? GraviaValueConst.paymentCancelledMessage
            : (e.message.isNotEmpty ? e.message : GraviaValueConst.paymentFailedMessage),
        cancelled: e.isCancelled,
      );
    }
  }
}
