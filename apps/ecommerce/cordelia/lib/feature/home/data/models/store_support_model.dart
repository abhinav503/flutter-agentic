import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/store_support_entity.dart';

part 'store_support_model.freezed.dart';
part 'store_support_model.g.dart';

/// The `support` object on admin's `serializeStore()`.
///
/// Every field is defaulted rather than required, same reasoning as
/// [StoreDeliveryModel]: the object is absent from an older API build, and
/// from a store whose owner never opened the support settings. Both read
/// back as [StoreSupportEntity.none] — no store contact, platform fallback
/// only, which is what those stores actually offer.
@freezed
abstract class StoreSupportModel with _$StoreSupportModel {
  const StoreSupportModel._();

  const factory StoreSupportModel({
    @Default('') String email,
    @Default('') String phone,
    @Default('') String hours,
  }) = _StoreSupportModel;

  factory StoreSupportModel.fromJson(Map<String, dynamic> json) =>
      _$StoreSupportModelFromJson(json);

  factory StoreSupportModel.fromEntity(StoreSupportEntity e) =>
      StoreSupportModel(email: e.email, phone: e.phone, hours: e.hours);

  StoreSupportEntity toEntity() =>
      StoreSupportEntity(email: email, phone: phone, hours: hours);
}
