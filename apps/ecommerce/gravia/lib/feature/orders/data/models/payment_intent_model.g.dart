// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentIntentModel _$PaymentIntentModelFromJson(Map<String, dynamic> json) =>
    _PaymentIntentModel(
      razorpayOrderId: json['razorpayOrderId'] as String,
      razorpayKeyId: json['razorpayKeyId'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PaymentIntentModelToJson(_PaymentIntentModel instance) =>
    <String, dynamic>{
      'razorpayOrderId': instance.razorpayOrderId,
      'razorpayKeyId': instance.razorpayKeyId,
      'amount': instance.amount,
      'currency': instance.currency,
    };
