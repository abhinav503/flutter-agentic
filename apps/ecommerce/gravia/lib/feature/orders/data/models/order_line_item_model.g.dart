// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_line_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderLineItemModel _$OrderLineItemModelFromJson(Map<String, dynamic> json) =>
    _OrderLineItemModel(
      productName: json['product_name'] as String,
      weight: json['weight'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$OrderLineItemModelToJson(_OrderLineItemModel instance) =>
    <String, dynamic>{
      'product_name': instance.productName,
      'weight': instance.weight,
      'image': instance.image,
      'price': instance.price,
      'quantity': instance.quantity,
    };
