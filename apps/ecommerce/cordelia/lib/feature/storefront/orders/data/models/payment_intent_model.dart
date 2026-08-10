import 'package:cordelia/enums/payment_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_intent_entity.dart';

part 'payment_intent_model.freezed.dart';
part 'payment_intent_model.g.dart';

@freezed
abstract class PaymentIntentModel with _$PaymentIntentModel {
  const PaymentIntentModel._();

  const factory PaymentIntentModel({
    // Every field below the first two is defaulted rather than required: a
    // server deployment predating the Razorpay/Stripe split omits `provider`
    // and `clientSecret` entirely, and checkout must keep working against it.
    // An absent provider parses to Razorpay, which is what such a server is.
    @JsonKey(name: 'provider', defaultValue: 'razorpay') required String provider,
    @JsonKey(name: 'paymentOrderId') required String paymentOrderId,
    @JsonKey(name: 'publishableKey') required String publishableKey,
    @JsonKey(name: 'clientSecret', defaultValue: '') required String clientSecret,
    required int amount,
    required String currency,
    @JsonKey(name: 'storeName', defaultValue: '') required String storeName,
  }) = _PaymentIntentModel;

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentModelFromJson(json);

  factory PaymentIntentModel.fromEntity(PaymentIntentEntity e) =>
      PaymentIntentModel(
        provider: e.provider.name,
        paymentOrderId: e.paymentOrderId,
        publishableKey: e.publishableKey,
        clientSecret: e.clientSecret,
        amount: e.amount,
        currency: e.currency,
        storeName: e.storeName,
      );

  PaymentIntentEntity toEntity() => PaymentIntentEntity(
    provider: provider.toPaymentProvider(),
    paymentOrderId: paymentOrderId,
    publishableKey: publishableKey,
    clientSecret: clientSecret,
    amount: amount,
    currency: currency,
    storeName: storeName,
  );
}
