import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/store_delivery_entity.dart';

part 'store_delivery_model.freezed.dart';
part 'store_delivery_model.g.dart';

/// The `delivery` object on admin's `serializeStore()`.
///
/// Every field is defaulted rather than required: the object is absent from
/// the still-deployed older API build, and a store that never opened the
/// Delivery settings has no map on its doc either. Both read back as free
/// delivery everywhere — which is what those stores actually do.
@freezed
abstract class StoreDeliveryModel with _$StoreDeliveryModel {
  const StoreDeliveryModel._();

  const factory StoreDeliveryModel({
    @Default(0.0) double fee,
    @JsonKey(name: 'free_above') @Default(0.0) double freeAbove,
    @Default(<String>[]) List<String> areas,
  }) = _StoreDeliveryModel;

  factory StoreDeliveryModel.fromJson(Map<String, dynamic> json) =>
      _$StoreDeliveryModelFromJson(json);

  factory StoreDeliveryModel.fromEntity(StoreDeliveryEntity e) =>
      StoreDeliveryModel(fee: e.fee, freeAbove: e.freeAbove, areas: e.areas);

  StoreDeliveryEntity toEntity() =>
      StoreDeliveryEntity(fee: fee, freeAbove: freeAbove, areas: areas);
}
