// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applied_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppliedCouponModel _$AppliedCouponModelFromJson(Map<String, dynamic> json) =>
    _AppliedCouponModel(
      code: json['code'] as String,
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$AppliedCouponModelToJson(_AppliedCouponModel instance) =>
    <String, dynamic>{'code': instance.code, 'discount': instance.discount};
