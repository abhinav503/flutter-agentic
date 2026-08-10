import 'package:cordelia/enums/payment_provider.dart';

import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import 'payment_gateway_data_source.dart';
import 'razorpay_gateway_data_source_impl.dart';
import 'stripe_gateway_data_source_impl.dart';

/// Opens whichever gateway the *store* configured, decided per payment from
/// [PaymentIntentEntity.provider] — which the server sets when it creates the
/// intent.
///
/// This is a data source, not a factory in DI, because the choice can't be
/// made at registration time: cordelia is one app in front of many stores, and
/// the shopper can move from a Razorpay store to a Stripe one without the app
/// restarting. Both delegates are `const` no-arg like every other data source
/// here, so holding both costs nothing.
class RoutingPaymentGatewayDataSourceImpl implements PaymentGatewayDataSource {
  final RazorpayGatewayDataSourceImpl _razorpay;
  final StripeGatewayDataSourceImpl _stripe;

  const RoutingPaymentGatewayDataSourceImpl({
    this._razorpay = const RazorpayGatewayDataSourceImpl(),
    this._stripe = const StripeGatewayDataSourceImpl(),
  });

  @override
  Future<PaymentResultEntity> processPayment(PaymentIntentEntity intent) =>
      switch (intent.provider) {
        PaymentProvider.razorpay => _razorpay.processPayment(intent),
        PaymentProvider.stripe => _stripe.processPayment(intent),
      };
}
