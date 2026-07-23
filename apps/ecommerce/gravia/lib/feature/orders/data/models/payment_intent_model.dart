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
  }) = _PaymentIntentModel;

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentModelFromJson(json);

  factory PaymentIntentModel.fromEntity(PaymentIntentEntity e) =>
      PaymentIntentModel(
        razorpayOrderId: e.razorpayOrderId,
        razorpayKeyId: e.razorpayKeyId,
        amount: e.amount,
        currency: e.currency,
      );

  PaymentIntentEntity toEntity() => PaymentIntentEntity(
    razorpayOrderId: razorpayOrderId,
    razorpayKeyId: razorpayKeyId,
    amount: amount,
    currency: currency,
  );
}
