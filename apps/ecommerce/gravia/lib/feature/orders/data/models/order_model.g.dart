// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: json['id'] as String,
  status: json['status'] as String,
  placedAt: json['placed_at'] as String,
  deliveryOtp: json['delivery_otp'] as String,
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
      'placed_at': instance.placedAt,
      'delivery_otp': instance.deliveryOtp,
      'items': instance.items,
      'delivery_address': instance.deliveryAddress,
    };
