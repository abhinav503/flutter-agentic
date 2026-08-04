// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'size_variant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SizeVariantModel {

 double get value; double get price;@JsonKey(name: 'original_price') double get originalPrice;@JsonKey(name: 'discount_percentage') double get discountPercentage;
/// Create a copy of SizeVariantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SizeVariantModelCopyWith<SizeVariantModel> get copyWith => _$SizeVariantModelCopyWithImpl<SizeVariantModel>(this as SizeVariantModel, _$identity);

  /// Serializes this SizeVariantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SizeVariantModel&&(identical(other.value, value) || other.value == value)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,price,originalPrice,discountPercentage);

@override
String toString() {
  return 'SizeVariantModel(value: $value, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage)';
}


}

/// @nodoc
abstract mixin class $SizeVariantModelCopyWith<$Res>  {
  factory $SizeVariantModelCopyWith(SizeVariantModel value, $Res Function(SizeVariantModel) _then) = _$SizeVariantModelCopyWithImpl;
@useResult
$Res call({
 double value, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage
});




}
/// @nodoc
class _$SizeVariantModelCopyWithImpl<$Res>
    implements $SizeVariantModelCopyWith<$Res> {
  _$SizeVariantModelCopyWithImpl(this._self, this._then);

  final SizeVariantModel _self;
  final $Res Function(SizeVariantModel) _then;

/// Create a copy of SizeVariantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SizeVariantModel].
extension SizeVariantModelPatterns on SizeVariantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SizeVariantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SizeVariantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SizeVariantModel value)  $default,){
final _that = this;
switch (_that) {
case _SizeVariantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SizeVariantModel value)?  $default,){
final _that = this;
switch (_that) {
case _SizeVariantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SizeVariantModel() when $default != null:
return $default(_that.value,_that.price,_that.originalPrice,_that.discountPercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage)  $default,) {final _that = this;
switch (_that) {
case _SizeVariantModel():
return $default(_that.value,_that.price,_that.originalPrice,_that.discountPercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage)?  $default,) {final _that = this;
switch (_that) {
case _SizeVariantModel() when $default != null:
return $default(_that.value,_that.price,_that.originalPrice,_that.discountPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SizeVariantModel extends SizeVariantModel {
  const _SizeVariantModel({required this.value, required this.price, @JsonKey(name: 'original_price') required this.originalPrice, @JsonKey(name: 'discount_percentage') required this.discountPercentage}): super._();
  factory _SizeVariantModel.fromJson(Map<String, dynamic> json) => _$SizeVariantModelFromJson(json);

@override final  double value;
@override final  double price;
@override@JsonKey(name: 'original_price') final  double originalPrice;
@override@JsonKey(name: 'discount_percentage') final  double discountPercentage;

/// Create a copy of SizeVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SizeVariantModelCopyWith<_SizeVariantModel> get copyWith => __$SizeVariantModelCopyWithImpl<_SizeVariantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SizeVariantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SizeVariantModel&&(identical(other.value, value) || other.value == value)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,price,originalPrice,discountPercentage);

@override
String toString() {
  return 'SizeVariantModel(value: $value, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage)';
}


}

/// @nodoc
abstract mixin class _$SizeVariantModelCopyWith<$Res> implements $SizeVariantModelCopyWith<$Res> {
  factory _$SizeVariantModelCopyWith(_SizeVariantModel value, $Res Function(_SizeVariantModel) _then) = __$SizeVariantModelCopyWithImpl;
@override @useResult
$Res call({
 double value, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage
});




}
/// @nodoc
class __$SizeVariantModelCopyWithImpl<$Res>
    implements _$SizeVariantModelCopyWith<$Res> {
  __$SizeVariantModelCopyWithImpl(this._self, this._then);

  final _SizeVariantModel _self;
  final $Res Function(_SizeVariantModel) _then;

/// Create a copy of SizeVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,}) {
  return _then(_SizeVariantModel(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
