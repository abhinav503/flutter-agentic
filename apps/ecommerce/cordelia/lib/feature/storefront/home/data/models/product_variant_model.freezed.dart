// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_variant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductVariantModel {

 String get id; List<String> get options; double get price;@JsonKey(name: 'original_price') double get originalPrice;@JsonKey(name: 'discount_percentage') double get discountPercentage; int? get stock;@JsonKey(name: 'sell_when_out_of_stock') bool get sellWhenOutOfStock; String get image;@JsonKey(name: 'pack_size') double get packSize;
/// Create a copy of ProductVariantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductVariantModelCopyWith<ProductVariantModel> get copyWith => _$ProductVariantModelCopyWithImpl<ProductVariantModel>(this as ProductVariantModel, _$identity);

  /// Serializes this ProductVariantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductVariantModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sellWhenOutOfStock, sellWhenOutOfStock) || other.sellWhenOutOfStock == sellWhenOutOfStock)&&(identical(other.image, image) || other.image == image)&&(identical(other.packSize, packSize) || other.packSize == packSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(options),price,originalPrice,discountPercentage,stock,sellWhenOutOfStock,image,packSize);

@override
String toString() {
  return 'ProductVariantModel(id: $id, options: $options, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, stock: $stock, sellWhenOutOfStock: $sellWhenOutOfStock, image: $image, packSize: $packSize)';
}


}

/// @nodoc
abstract mixin class $ProductVariantModelCopyWith<$Res>  {
  factory $ProductVariantModelCopyWith(ProductVariantModel value, $Res Function(ProductVariantModel) _then) = _$ProductVariantModelCopyWithImpl;
@useResult
$Res call({
 String id, List<String> options, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage, int? stock,@JsonKey(name: 'sell_when_out_of_stock') bool sellWhenOutOfStock, String image,@JsonKey(name: 'pack_size') double packSize
});




}
/// @nodoc
class _$ProductVariantModelCopyWithImpl<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  _$ProductVariantModelCopyWithImpl(this._self, this._then);

  final ProductVariantModel _self;
  final $Res Function(ProductVariantModel) _then;

/// Create a copy of ProductVariantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? options = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,Object? stock = freezed,Object? sellWhenOutOfStock = null,Object? image = null,Object? packSize = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,sellWhenOutOfStock: null == sellWhenOutOfStock ? _self.sellWhenOutOfStock : sellWhenOutOfStock // ignore: cast_nullable_to_non_nullable
as bool,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,packSize: null == packSize ? _self.packSize : packSize // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductVariantModel].
extension ProductVariantModelPatterns on ProductVariantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductVariantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductVariantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductVariantModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductVariantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductVariantModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductVariantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<String> options,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage,  int? stock, @JsonKey(name: 'sell_when_out_of_stock')  bool sellWhenOutOfStock,  String image, @JsonKey(name: 'pack_size')  double packSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductVariantModel() when $default != null:
return $default(_that.id,_that.options,_that.price,_that.originalPrice,_that.discountPercentage,_that.stock,_that.sellWhenOutOfStock,_that.image,_that.packSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<String> options,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage,  int? stock, @JsonKey(name: 'sell_when_out_of_stock')  bool sellWhenOutOfStock,  String image, @JsonKey(name: 'pack_size')  double packSize)  $default,) {final _that = this;
switch (_that) {
case _ProductVariantModel():
return $default(_that.id,_that.options,_that.price,_that.originalPrice,_that.discountPercentage,_that.stock,_that.sellWhenOutOfStock,_that.image,_that.packSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<String> options,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage,  int? stock, @JsonKey(name: 'sell_when_out_of_stock')  bool sellWhenOutOfStock,  String image, @JsonKey(name: 'pack_size')  double packSize)?  $default,) {final _that = this;
switch (_that) {
case _ProductVariantModel() when $default != null:
return $default(_that.id,_that.options,_that.price,_that.originalPrice,_that.discountPercentage,_that.stock,_that.sellWhenOutOfStock,_that.image,_that.packSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductVariantModel extends ProductVariantModel {
  const _ProductVariantModel({required this.id, final  List<String> options = const <String>[], required this.price, @JsonKey(name: 'original_price') required this.originalPrice, @JsonKey(name: 'discount_percentage') this.discountPercentage = 0.0, this.stock, @JsonKey(name: 'sell_when_out_of_stock') this.sellWhenOutOfStock = false, this.image = '', @JsonKey(name: 'pack_size') this.packSize = 0.0}): _options = options,super._();
  factory _ProductVariantModel.fromJson(Map<String, dynamic> json) => _$ProductVariantModelFromJson(json);

@override final  String id;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  double price;
@override@JsonKey(name: 'original_price') final  double originalPrice;
@override@JsonKey(name: 'discount_percentage') final  double discountPercentage;
@override final  int? stock;
@override@JsonKey(name: 'sell_when_out_of_stock') final  bool sellWhenOutOfStock;
@override@JsonKey() final  String image;
@override@JsonKey(name: 'pack_size') final  double packSize;

/// Create a copy of ProductVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductVariantModelCopyWith<_ProductVariantModel> get copyWith => __$ProductVariantModelCopyWithImpl<_ProductVariantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductVariantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductVariantModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.sellWhenOutOfStock, sellWhenOutOfStock) || other.sellWhenOutOfStock == sellWhenOutOfStock)&&(identical(other.image, image) || other.image == image)&&(identical(other.packSize, packSize) || other.packSize == packSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_options),price,originalPrice,discountPercentage,stock,sellWhenOutOfStock,image,packSize);

@override
String toString() {
  return 'ProductVariantModel(id: $id, options: $options, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, stock: $stock, sellWhenOutOfStock: $sellWhenOutOfStock, image: $image, packSize: $packSize)';
}


}

/// @nodoc
abstract mixin class _$ProductVariantModelCopyWith<$Res> implements $ProductVariantModelCopyWith<$Res> {
  factory _$ProductVariantModelCopyWith(_ProductVariantModel value, $Res Function(_ProductVariantModel) _then) = __$ProductVariantModelCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> options, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage, int? stock,@JsonKey(name: 'sell_when_out_of_stock') bool sellWhenOutOfStock, String image,@JsonKey(name: 'pack_size') double packSize
});




}
/// @nodoc
class __$ProductVariantModelCopyWithImpl<$Res>
    implements _$ProductVariantModelCopyWith<$Res> {
  __$ProductVariantModelCopyWithImpl(this._self, this._then);

  final _ProductVariantModel _self;
  final $Res Function(_ProductVariantModel) _then;

/// Create a copy of ProductVariantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? options = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,Object? stock = freezed,Object? sellWhenOutOfStock = null,Object? image = null,Object? packSize = null,}) {
  return _then(_ProductVariantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,sellWhenOutOfStock: null == sellWhenOutOfStock ? _self.sellWhenOutOfStock : sellWhenOutOfStock // ignore: cast_nullable_to_non_nullable
as bool,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,packSize: null == packSize ? _self.packSize : packSize // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
