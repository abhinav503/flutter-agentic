// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_delivery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreDeliveryModel _$StoreDeliveryModelFromJson(Map<String, dynamic> json) =>
    _StoreDeliveryModel(
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      freeAbove: (json['free_above'] as num?)?.toDouble() ?? 0.0,
      areas:
          (json['areas'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    );

Map<String, dynamic> _$StoreDeliveryModelToJson(_StoreDeliveryModel instance) =>
    <String, dynamic>{
      'fee': instance.fee,
      'free_above': instance.freeAbove,
      'areas': instance.areas,
    };
