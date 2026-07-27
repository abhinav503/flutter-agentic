// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_line_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderLineItemModel {

@JsonKey(name: 'product_name') String get productName; String get weight; String get image; double get price; int get quantity;
/// Create a copy of OrderLineItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineItemModelCopyWith<OrderLineItemModel> get copyWith => _$OrderLineItemModelCopyWithImpl<OrderLineItemModel>(this as OrderLineItemModel, _$identity);

  /// Serializes this OrderLineItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineItemModel&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,weight,image,price,quantity);

@override
String toString() {
  return 'OrderLineItemModel(productName: $productName, weight: $weight, image: $image, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $OrderLineItemModelCopyWith<$Res>  {
  factory $OrderLineItemModelCopyWith(OrderLineItemModel value, $Res Function(OrderLineItemModel) _then) = _$OrderLineItemModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_name') String productName, String weight, String image, double price, int quantity
});




}
/// @nodoc
class _$OrderLineItemModelCopyWithImpl<$Res>
    implements $OrderLineItemModelCopyWith<$Res> {
  _$OrderLineItemModelCopyWithImpl(this._self, this._then);

  final OrderLineItemModel _self;
  final $Res Function(OrderLineItemModel) _then;

/// Create a copy of OrderLineItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productName = null,Object? weight = null,Object? image = null,Object? price = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLineItemModel].
extension OrderLineItemModelPatterns on OrderLineItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLineItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLineItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLineItemModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderLineItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLineItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLineItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_name')  String productName,  String weight,  String image,  double price,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineItemModel() when $default != null:
return $default(_that.productName,_that.weight,_that.image,_that.price,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_name')  String productName,  String weight,  String image,  double price,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _OrderLineItemModel():
return $default(_that.productName,_that.weight,_that.image,_that.price,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_name')  String productName,  String weight,  String image,  double price,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineItemModel() when $default != null:
return $default(_that.productName,_that.weight,_that.image,_that.price,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderLineItemModel extends OrderLineItemModel {
  const _OrderLineItemModel({@JsonKey(name: 'product_name') required this.productName, required this.weight, required this.image, required this.price, required this.quantity}): super._();
  factory _OrderLineItemModel.fromJson(Map<String, dynamic> json) => _$OrderLineItemModelFromJson(json);

@override@JsonKey(name: 'product_name') final  String productName;
@override final  String weight;
@override final  String image;
@override final  double price;
@override final  int quantity;

/// Create a copy of OrderLineItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineItemModelCopyWith<_OrderLineItemModel> get copyWith => __$OrderLineItemModelCopyWithImpl<_OrderLineItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderLineItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineItemModel&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productName,weight,image,price,quantity);

@override
String toString() {
  return 'OrderLineItemModel(productName: $productName, weight: $weight, image: $image, price: $price, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$OrderLineItemModelCopyWith<$Res> implements $OrderLineItemModelCopyWith<$Res> {
  factory _$OrderLineItemModelCopyWith(_OrderLineItemModel value, $Res Function(_OrderLineItemModel) _then) = __$OrderLineItemModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_name') String productName, String weight, String image, double price, int quantity
});




}
/// @nodoc
class __$OrderLineItemModelCopyWithImpl<$Res>
    implements _$OrderLineItemModelCopyWith<$Res> {
  __$OrderLineItemModelCopyWithImpl(this._self, this._then);

  final _OrderLineItemModel _self;
  final $Res Function(_OrderLineItemModel) _then;

/// Create a copy of OrderLineItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productName = null,Object? weight = null,Object? image = null,Object? price = null,Object? quantity = null,}) {
  return _then(_OrderLineItemModel(
productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
