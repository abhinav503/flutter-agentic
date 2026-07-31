import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/payment_intent_entity.dart';

part 'payment_intent_model.freezed.dart';
part 'payment_intent_model.g.dart';

@freezed
abstract class PaymentIntentModel with _$PaymentIntentModel {
  const PaymentIntentModel._();

  const factory PaymentIntentModel({
    @JsonKey(name: 'razorpayOrderId') required String razorpayOrderId,
    @JsonKey(name: 'razorpayKeyId') required String razorpayKeyId,
    required int amount,
    required String currency,
    // Defaulted, not required: a server that predates this field simply omits
    // it, and checkout must keep working against that deployment.
    @JsonKey(name: 'storeName', defaultValue: '') required String storeName,
  }) = _PaymentIntentModel;

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentModelFromJson(json);

  factory PaymentIntentModel.fromEntity(PaymentIntentEntity e) =>
      PaymentIntentModel(
        razorpayOrderId: e.razorpayOrderId,
        razorpayKeyId: e.razorpayKeyId,
        amount: e.amount,
        currency: e.currency,
        storeName: e.storeName,
      );

  PaymentIntentEntity toEntity() => PaymentIntentEntity(
    razorpayOrderId: razorpayOrderId,
    razorpayKeyId: razorpayKeyId,
    amount: amount,
    currency: currency,
    storeName: storeName,
  );
}
