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
    @JsonKey(name: 'address_line') required String addressLine,
    required String tag,
    @JsonKey(name: 'is_default') required bool isDefault,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  factory AddressModel.fromEntity(AddressEntity e) => AddressModel(
    id: e.id,
    name: e.name,
    phone: e.phone,
    addressLine: e.addressLine,
    tag: e.tag,
    isDefault: e.isDefault,
  );

  AddressEntity toEntity() => AddressEntity(
    id: id,
    name: name,
    phone: phone,
    addressLine: addressLine,
    tag: tag,
    isDefault: isDefault,
  );
}
