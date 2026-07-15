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
      addressLine: json['address_line'] as String,
      tag: json['tag'] as String,
      isDefault: json['is_default'] as bool,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address_line': instance.addressLine,
      'tag': instance.tag,
      'is_default': instance.isDefault,
    };
