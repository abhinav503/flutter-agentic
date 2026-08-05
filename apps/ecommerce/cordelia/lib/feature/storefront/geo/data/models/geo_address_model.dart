import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/geo_address_entity.dart';

part 'geo_address_model.freezed.dart';
part 'geo_address_model.g.dart';

@freezed
abstract class GeoAddressModel with _$GeoAddressModel {
  const GeoAddressModel._();

  const factory GeoAddressModel({
    @Default('') String formatted,
    @JsonKey(name: 'address_line') @Default('') String addressLine,
    @Default('') String city,
    @Default('') String state,
    @JsonKey(name: 'postal_code') @Default('') String postalCode,
    @Default('') String country,
    double? latitude,
    double? longitude,
  }) = _GeoAddressModel;

  factory GeoAddressModel.fromJson(Map<String, dynamic> json) =>
      _$GeoAddressModelFromJson(json);

  factory GeoAddressModel.fromEntity(GeoAddressEntity e) => GeoAddressModel(
    formatted: e.formatted,
    addressLine: e.addressLine,
    city: e.city,
    state: e.state,
    postalCode: e.postalCode,
    country: e.country,
    latitude: e.latitude,
    longitude: e.longitude,
  );

  GeoAddressEntity toEntity() => GeoAddressEntity(
    formatted: formatted,
    addressLine: addressLine,
    city: city,
    state: state,
    postalCode: postalCode,
    country: country,
    latitude: latitude,
    longitude: longitude,
  );
}
