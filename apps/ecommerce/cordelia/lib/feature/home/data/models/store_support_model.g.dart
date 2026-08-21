// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_support_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreSupportModel _$StoreSupportModelFromJson(Map<String, dynamic> json) =>
    _StoreSupportModel(
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      hours: json['hours'] as String? ?? '',
    );

Map<String, dynamic> _$StoreSupportModelToJson(_StoreSupportModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'hours': instance.hours,
    };
