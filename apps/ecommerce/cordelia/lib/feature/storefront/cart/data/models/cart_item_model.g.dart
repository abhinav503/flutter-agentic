// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      sizeValue: (json['size_value'] as num?)?.toDouble(),
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      originalUnitPrice: (json['original_unit_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
    <String, dynamic>{
      'product': instance.product,
      'quantity': instance.quantity,
      'size_value': instance.sizeValue,
      'unit_price': instance.unitPrice,
      'original_unit_price': instance.originalUnitPrice,
    };
