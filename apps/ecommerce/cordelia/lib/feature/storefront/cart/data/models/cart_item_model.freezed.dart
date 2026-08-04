// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemModel {

 ProductModel get product; int get quantity;// All three absent for a base-pack line (and on every pre-variant
// response) — the entity falls back to the product's own price/size.
@JsonKey(name: 'size_value') double? get sizeValue;@JsonKey(name: 'unit_price') double? get unitPrice;@JsonKey(name: 'original_unit_price') double? get originalUnitPrice;
/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemModelCopyWith<CartItemModel> get copyWith => _$CartItemModelCopyWithImpl<CartItemModel>(this as CartItemModel, _$identity);

  /// Serializes this CartItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemModel&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.sizeValue, sizeValue) || other.sizeValue == sizeValue)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.originalUnitPrice, originalUnitPrice) || other.originalUnitPrice == originalUnitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,quantity,sizeValue,unitPrice,originalUnitPrice);

@override
String toString() {
  return 'CartItemModel(product: $product, quantity: $quantity, sizeValue: $sizeValue, unitPrice: $unitPrice, originalUnitPrice: $originalUnitPrice)';
}


}

/// @nodoc
abstract mixin class $CartItemModelCopyWith<$Res>  {
  factory $CartItemModelCopyWith(CartItemModel value, $Res Function(CartItemModel) _then) = _$CartItemModelCopyWithImpl;
@useResult
$Res call({
 ProductModel product, int quantity,@JsonKey(name: 'size_value') double? sizeValue,@JsonKey(name: 'unit_price') double? unitPrice,@JsonKey(name: 'original_unit_price') double? originalUnitPrice
});


$ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class _$CartItemModelCopyWithImpl<$Res>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._self, this._then);

  final CartItemModel _self;
  final $Res Function(CartItemModel) _then;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? quantity = null,Object? sizeValue = freezed,Object? unitPrice = freezed,Object? originalUnitPrice = freezed,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,sizeValue: freezed == sizeValue ? _self.sizeValue : sizeValue // ignore: cast_nullable_to_non_nullable
as double?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,originalUnitPrice: freezed == originalUnitPrice ? _self.originalUnitPrice : originalUnitPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [CartItemModel].
extension CartItemModelPatterns on CartItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemModel value)  $default,){
final _that = this;
switch (_that) {
case _CartItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductModel product,  int quantity, @JsonKey(name: 'size_value')  double? sizeValue, @JsonKey(name: 'unit_price')  double? unitPrice, @JsonKey(name: 'original_unit_price')  double? originalUnitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that.product,_that.quantity,_that.sizeValue,_that.unitPrice,_that.originalUnitPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductModel product,  int quantity, @JsonKey(name: 'size_value')  double? sizeValue, @JsonKey(name: 'unit_price')  double? unitPrice, @JsonKey(name: 'original_unit_price')  double? originalUnitPrice)  $default,) {final _that = this;
switch (_that) {
case _CartItemModel():
return $default(_that.product,_that.quantity,_that.sizeValue,_that.unitPrice,_that.originalUnitPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductModel product,  int quantity, @JsonKey(name: 'size_value')  double? sizeValue, @JsonKey(name: 'unit_price')  double? unitPrice, @JsonKey(name: 'original_unit_price')  double? originalUnitPrice)?  $default,) {final _that = this;
switch (_that) {
case _CartItemModel() when $default != null:
return $default(_that.product,_that.quantity,_that.sizeValue,_that.unitPrice,_that.originalUnitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartItemModel extends CartItemModel {
  const _CartItemModel({required this.product, required this.quantity, @JsonKey(name: 'size_value') this.sizeValue, @JsonKey(name: 'unit_price') this.unitPrice, @JsonKey(name: 'original_unit_price') this.originalUnitPrice}): super._();
  factory _CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

@override final  ProductModel product;
@override final  int quantity;
// All three absent for a base-pack line (and on every pre-variant
// response) — the entity falls back to the product's own price/size.
@override@JsonKey(name: 'size_value') final  double? sizeValue;
@override@JsonKey(name: 'unit_price') final  double? unitPrice;
@override@JsonKey(name: 'original_unit_price') final  double? originalUnitPrice;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemModelCopyWith<_CartItemModel> get copyWith => __$CartItemModelCopyWithImpl<_CartItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemModel&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.sizeValue, sizeValue) || other.sizeValue == sizeValue)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.originalUnitPrice, originalUnitPrice) || other.originalUnitPrice == originalUnitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,quantity,sizeValue,unitPrice,originalUnitPrice);

@override
String toString() {
  return 'CartItemModel(product: $product, quantity: $quantity, sizeValue: $sizeValue, unitPrice: $unitPrice, originalUnitPrice: $originalUnitPrice)';
}


}

/// @nodoc
abstract mixin class _$CartItemModelCopyWith<$Res> implements $CartItemModelCopyWith<$Res> {
  factory _$CartItemModelCopyWith(_CartItemModel value, $Res Function(_CartItemModel) _then) = __$CartItemModelCopyWithImpl;
@override @useResult
$Res call({
 ProductModel product, int quantity,@JsonKey(name: 'size_value') double? sizeValue,@JsonKey(name: 'unit_price') double? unitPrice,@JsonKey(name: 'original_unit_price') double? originalUnitPrice
});


@override $ProductModelCopyWith<$Res> get product;

}
/// @nodoc
class __$CartItemModelCopyWithImpl<$Res>
    implements _$CartItemModelCopyWith<$Res> {
  __$CartItemModelCopyWithImpl(this._self, this._then);

  final _CartItemModel _self;
  final $Res Function(_CartItemModel) _then;

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? quantity = null,Object? sizeValue = freezed,Object? unitPrice = freezed,Object? originalUnitPrice = freezed,}) {
  return _then(_CartItemModel(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,sizeValue: freezed == sizeValue ? _self.sizeValue : sizeValue // ignore: cast_nullable_to_non_nullable
as double?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double?,originalUnitPrice: freezed == originalUnitPrice ? _self.originalUnitPrice : originalUnitPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of CartItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
