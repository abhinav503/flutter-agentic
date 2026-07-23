import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';

/// Thrown by a gateway data source when checkout ends without a successful
/// charge. Provider-neutral (no Razorpay/Stripe types leak out); [cancelled]
/// separates the shopper backing out from a genuine error. The repository
/// maps it to a [Failure]; nothing above the data layer sees this type.
class PaymentGatewayException implements Exception {
  final String message;
  final bool cancelled;

  const PaymentGatewayException({required this.message, this.cancelled = false});
}

/// Drives one payment provider's checkout for a server-created [intent].
/// Concrete impls (`RazorpayGatewayDataSourceImpl`, a future
/// `StripeGatewayDataSourceImpl`, …) are `const` no-arg and reach their SDK
/// through a static-singleton service, like every other data source here.
abstract interface class PaymentGatewayDataSource {
  Future<PaymentResultEntity> processPayment(PaymentIntentEntity intent);
}
