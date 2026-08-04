// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: json['id'] as String,
  status: json['status'] as String,
  refundStatus: json['refund_status'] as String? ?? 'NONE',
  placedAt: json['placed_at'] as String,
  statusHistory:
      (json['status_history'] as List<dynamic>?)
          ?.map(
            (e) => OrderStatusChangeModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <OrderStatusChangeModel>[],
  deliveryOtp: json['delivery_otp'] as String,
  paymentId: json['payment_id'] as String? ?? '',
  couponCode: json['coupon_code'] as String? ?? '',
  couponDiscount: (json['coupon_discount'] as num?)?.toDouble() ?? 0,
  rating: (json['rating'] as num?)?.toInt() ?? 0,
  reviewText: json['review_text'] as String? ?? '',
  reviewedAt: json['reviewed_at'] as String? ?? '',
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderLineItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  deliveryAddress: json['delivery_address'] == null
      ? null
      : AddressModel.fromJson(json['delivery_address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'refund_status': instance.refundStatus,
      'placed_at': instance.placedAt,
      'status_history': instance.statusHistory,
      'delivery_otp': instance.deliveryOtp,
      'payment_id': instance.paymentId,
      'coupon_code': instance.couponCode,
      'coupon_discount': instance.couponDiscount,
      'rating': instance.rating,
      'review_text': instance.reviewText,
      'reviewed_at': instance.reviewedAt,
      'items': instance.items,
      'delivery_address': instance.deliveryAddress,
    };
