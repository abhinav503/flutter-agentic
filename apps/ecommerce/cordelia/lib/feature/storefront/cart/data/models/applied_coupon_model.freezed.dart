// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applied_coupon_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppliedCouponModel {

 String get code; double get discount;
/// Create a copy of AppliedCouponModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppliedCouponModelCopyWith<AppliedCouponModel> get copyWith => _$AppliedCouponModelCopyWithImpl<AppliedCouponModel>(this as AppliedCouponModel, _$identity);

  /// Serializes this AppliedCouponModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppliedCouponModel&&(identical(other.code, code) || other.code == code)&&(identical(other.discount, discount) || other.discount == discount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,discount);

@override
String toString() {
  return 'AppliedCouponModel(code: $code, discount: $discount)';
}


}

/// @nodoc
abstract mixin class $AppliedCouponModelCopyWith<$Res>  {
  factory $AppliedCouponModelCopyWith(AppliedCouponModel value, $Res Function(AppliedCouponModel) _then) = _$AppliedCouponModelCopyWithImpl;
@useResult
$Res call({
 String code, double discount
});




}
/// @nodoc
class _$AppliedCouponModelCopyWithImpl<$Res>
    implements $AppliedCouponModelCopyWith<$Res> {
  _$AppliedCouponModelCopyWithImpl(this._self, this._then);

  final AppliedCouponModel _self;
  final $Res Function(AppliedCouponModel) _then;

/// Create a copy of AppliedCouponModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? discount = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppliedCouponModel].
extension AppliedCouponModelPatterns on AppliedCouponModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppliedCouponModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppliedCouponModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppliedCouponModel value)  $default,){
final _that = this;
switch (_that) {
case _AppliedCouponModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppliedCouponModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppliedCouponModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  double discount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppliedCouponModel() when $default != null:
return $default(_that.code,_that.discount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  double discount)  $default,) {final _that = this;
switch (_that) {
case _AppliedCouponModel():
return $default(_that.code,_that.discount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  double discount)?  $default,) {final _that = this;
switch (_that) {
case _AppliedCouponModel() when $default != null:
return $default(_that.code,_that.discount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppliedCouponModel extends AppliedCouponModel {
  const _AppliedCouponModel({required this.code, required this.discount}): super._();
  factory _AppliedCouponModel.fromJson(Map<String, dynamic> json) => _$AppliedCouponModelFromJson(json);

@override final  String code;
@override final  double discount;

/// Create a copy of AppliedCouponModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppliedCouponModelCopyWith<_AppliedCouponModel> get copyWith => __$AppliedCouponModelCopyWithImpl<_AppliedCouponModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppliedCouponModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppliedCouponModel&&(identical(other.code, code) || other.code == code)&&(identical(other.discount, discount) || other.discount == discount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,discount);

@override
String toString() {
  return 'AppliedCouponModel(code: $code, discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$AppliedCouponModelCopyWith<$Res> implements $AppliedCouponModelCopyWith<$Res> {
  factory _$AppliedCouponModelCopyWith(_AppliedCouponModel value, $Res Function(_AppliedCouponModel) _then) = __$AppliedCouponModelCopyWithImpl;
@override @useResult
$Res call({
 String code, double discount
});




}
/// @nodoc
class __$AppliedCouponModelCopyWithImpl<$Res>
    implements _$AppliedCouponModelCopyWith<$Res> {
  __$AppliedCouponModelCopyWithImpl(this._self, this._then);

  final _AppliedCouponModel _self;
  final $Res Function(_AppliedCouponModel) _then;

/// Create a copy of AppliedCouponModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? discount = null,}) {
  return _then(_AppliedCouponModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
