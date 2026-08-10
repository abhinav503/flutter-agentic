// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentIntentModel _$PaymentIntentModelFromJson(Map<String, dynamic> json) =>
    _PaymentIntentModel(
      provider: json['provider'] as String? ?? 'razorpay',
      paymentOrderId: json['paymentOrderId'] as String,
      publishableKey: json['publishableKey'] as String,
      clientSecret: json['clientSecret'] as String? ?? '',
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      storeName: json['storeName'] as String? ?? '',
    );

Map<String, dynamic> _$PaymentIntentModelToJson(_PaymentIntentModel instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'paymentOrderId': instance.paymentOrderId,
      'publishableKey': instance.publishableKey,
      'clientSecret': instance.clientSecret,
      'amount': instance.amount,
      'currency': instance.currency,
      'storeName': instance.storeName,
    };
