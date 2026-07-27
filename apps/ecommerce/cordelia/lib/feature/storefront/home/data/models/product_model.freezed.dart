// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 String get id; String get name; String get image; double get price;@JsonKey(name: 'original_price') double get originalPrice;@JsonKey(name: 'discount_percentage') double get discountPercentage;@JsonKey(name: 'unit_value') double get unitValue;// Raw wire string ('g' / 'ml' / 'pcs') — parsed to ProductUnitType only
// in toEntity(), per the data-layer-parses-wire-strings convention.
@JsonKey(name: 'unit_type') String get unitType;@JsonKey(name: 'prep_time') String get prepTime;@JsonKey(name: 'is_favourite') bool get isFavourite;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.prepTime, prepTime) || other.prepTime == prepTime)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,price,originalPrice,discountPercentage,unitValue,unitType,prepTime,isFavourite);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, image: $image, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, unitValue: $unitValue, unitType: $unitType, prepTime: $prepTime, isFavourite: $isFavourite)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String image, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage,@JsonKey(name: 'unit_value') double unitValue,@JsonKey(name: 'unit_type') String unitType,@JsonKey(name: 'prep_time') String prepTime,@JsonKey(name: 'is_favourite') bool isFavourite
});




}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,Object? unitValue = null,Object? unitType = null,Object? prepTime = null,Object? isFavourite = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,unitValue: null == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,prepTime: null == prepTime ? _self.prepTime : prepTime // ignore: cast_nullable_to_non_nullable
as String,isFavourite: null == isFavourite ? _self.isFavourite : isFavourite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String image,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'unit_value')  double unitValue, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'prep_time')  String prepTime, @JsonKey(name: 'is_favourite')  bool isFavourite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.price,_that.originalPrice,_that.discountPercentage,_that.unitValue,_that.unitType,_that.prepTime,_that.isFavourite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String image,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'unit_value')  double unitValue, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'prep_time')  String prepTime, @JsonKey(name: 'is_favourite')  bool isFavourite)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.image,_that.price,_that.originalPrice,_that.discountPercentage,_that.unitValue,_that.unitType,_that.prepTime,_that.isFavourite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String image,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'unit_value')  double unitValue, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'prep_time')  String prepTime, @JsonKey(name: 'is_favourite')  bool isFavourite)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.price,_that.originalPrice,_that.discountPercentage,_that.unitValue,_that.unitType,_that.prepTime,_that.isFavourite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel extends ProductModel {
  const _ProductModel({required this.id, required this.name, required this.image, required this.price, @JsonKey(name: 'original_price') required this.originalPrice, @JsonKey(name: 'discount_percentage') required this.discountPercentage, @JsonKey(name: 'unit_value') required this.unitValue, @JsonKey(name: 'unit_type') required this.unitType, @JsonKey(name: 'prep_time') required this.prepTime, @JsonKey(name: 'is_favourite') this.isFavourite = false}): super._();
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String image;
@override final  double price;
@override@JsonKey(name: 'original_price') final  double originalPrice;
@override@JsonKey(name: 'discount_percentage') final  double discountPercentage;
@override@JsonKey(name: 'unit_value') final  double unitValue;
// Raw wire string ('g' / 'ml' / 'pcs') — parsed to ProductUnitType only
// in toEntity(), per the data-layer-parses-wire-strings convention.
@override@JsonKey(name: 'unit_type') final  String unitType;
@override@JsonKey(name: 'prep_time') final  String prepTime;
@override@JsonKey(name: 'is_favourite') final  bool isFavourite;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.prepTime, prepTime) || other.prepTime == prepTime)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,price,originalPrice,discountPercentage,unitValue,unitType,prepTime,isFavourite);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, image: $image, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, unitValue: $unitValue, unitType: $unitType, prepTime: $prepTime, isFavourite: $isFavourite)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String image, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage,@JsonKey(name: 'unit_value') double unitValue,@JsonKey(name: 'unit_type') String unitType,@JsonKey(name: 'prep_time') String prepTime,@JsonKey(name: 'is_favourite') bool isFavourite
});




}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,Object? unitValue = null,Object? unitType = null,Object? prepTime = null,Object? isFavourite = null,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountPercentage: null == discountPercentage ? _self.discountPercentage : discountPercentage // ignore: cast_nullable_to_non_nullable
as double,unitValue: null == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double,unitType: null == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String,prepTime: null == prepTime ? _self.prepTime : prepTime // ignore: cast_nullable_to_non_nullable
as String,isFavourite: null == isFavourite ? _self.isFavourite : isFavourite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
