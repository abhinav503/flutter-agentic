import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/address_entity.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
abstract class AddressModel with _$AddressModel {
  const AddressModel._();

  const factory AddressModel({
    required String id,
    required String name,
    required String phone,
    @JsonKey(name: 'address_line1') required String addressLine1,
    @JsonKey(name: 'address_line2') @Default('') String addressLine2,
    @Default('') String landmark,
    required String city,
    required String country,
    @JsonKey(name: 'postal_code') required String postalCode,
    required String tag,
    @JsonKey(name: 'is_default') required bool isDefault,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  factory AddressModel.fromEntity(AddressEntity e) => AddressModel(
    id: e.id,
    name: e.name,
    phone: e.phone,
    addressLine1: e.addressLine1,
    addressLine2: e.addressLine2,
    landmark: e.landmark,
    city: e.city,
    country: e.country,
    postalCode: e.postalCode,
    tag: e.tag,
    isDefault: e.isDefault,
  );

  AddressEntity toEntity() => AddressEntity(
    id: id,
    name: name,
    phone: phone,
    addressLine1: addressLine1,
    addressLine2: addressLine2,
    landmark: landmark,
    city: city,
    country: country,
    postalCode: postalCode,
    tag: tag,
    isDefault: isDefault,
  );
}
