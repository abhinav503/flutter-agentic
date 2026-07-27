// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String? ?? '',
      landmark: json['landmark'] as String? ?? '',
      city: json['city'] as String,
      country: json['country'] as String,
      postalCode: json['postal_code'] as String,
      tag: json['tag'] as String,
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address_line1': instance.addressLine1,
      'address_line2': instance.addressLine2,
      'landmark': instance.landmark,
      'city': instance.city,
      'country': instance.country,
      'postal_code': instance.postalCode,
      'tag': instance.tag,
      'is_default': instance.isDefault,
    };
