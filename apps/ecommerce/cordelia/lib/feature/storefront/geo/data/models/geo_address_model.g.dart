// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoAddressModel _$GeoAddressModelFromJson(Map<String, dynamic> json) =>
    _GeoAddressModel(
      formatted: json['formatted'] as String? ?? '',
      addressLine: json['address_line'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postal_code'] as String? ?? '',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GeoAddressModelToJson(_GeoAddressModel instance) =>
    <String, dynamic>{
      'formatted': instance.formatted,
      'address_line': instance.addressLine,
      'city': instance.city,
      'state': instance.state,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
