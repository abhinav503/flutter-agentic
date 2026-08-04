import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/applied_coupon_entity.dart';

part 'applied_coupon_model.freezed.dart';
part 'applied_coupon_model.g.dart';

/// Wire shape of POST .../coupons/validate's success response — the route
/// also returns type/value/eligible_subtotal, which nothing here renders,
/// so only what the UI shows is parsed.
@freezed
abstract class AppliedCouponModel with _$AppliedCouponModel {
  const AppliedCouponModel._();

  const factory AppliedCouponModel({
    required String code,
    required double discount,
  }) = _AppliedCouponModel;

  factory AppliedCouponModel.fromJson(Map<String, dynamic> json) =>
      _$AppliedCouponModelFromJson(json);

  factory AppliedCouponModel.fromEntity(AppliedCouponEntity e) =>
      AppliedCouponModel(code: e.code, discount: e.discount);

  AppliedCouponEntity toEntity() =>
      AppliedCouponEntity(code: code, discount: discount);
}
