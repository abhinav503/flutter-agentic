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
@JsonKey(name: 'unit_type') String get unitType;@JsonKey(name: 'prep_time') String get prepTime;@JsonKey(name: 'is_favourite') bool get isFavourite;// Defaulted, not required: a store whose products predate reviews (or a
// mock fixture) answers without these keys, and an unrated product is
// exactly what zeros mean.
@JsonKey(name: 'rating_average') double get ratingAverage;@JsonKey(name: 'review_count') int get reviewCount;// Nullable rather than defaulted: 0 is a real answer ("sold out") and an
// absent key is a different one ("this backend doesn't say"). Defaulting
// the missing case to 0 would render an entire catalog sold out against
// an older API, so unknown stays unknown and sells — see
// ProductEntityStockX.
 int? get stock;// Defaulted, not required: a backend (or mock fixture) that predates
// variants answers without these, which is a simple product.
@JsonKey(name: 'option_names') List<String> get optionNames; List<ProductVariantModel> get variants; Map<String, String> get attributes;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.prepTime, prepTime) || other.prepTime == prepTime)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other.optionNames, optionNames)&&const DeepCollectionEquality().equals(other.variants, variants)&&const DeepCollectionEquality().equals(other.attributes, attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,price,originalPrice,discountPercentage,unitValue,unitType,prepTime,isFavourite,ratingAverage,reviewCount,stock,const DeepCollectionEquality().hash(optionNames),const DeepCollectionEquality().hash(variants),const DeepCollectionEquality().hash(attributes));

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, image: $image, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, unitValue: $unitValue, unitType: $unitType, prepTime: $prepTime, isFavourite: $isFavourite, ratingAverage: $ratingAverage, reviewCount: $reviewCount, stock: $stock, optionNames: $optionNames, variants: $variants, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String image, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage,@JsonKey(name: 'unit_value') double unitValue,@JsonKey(name: 'unit_type') String unitType,@JsonKey(name: 'prep_time') String prepTime,@JsonKey(name: 'is_favourite') bool isFavourite,@JsonKey(name: 'rating_average') double ratingAverage,@JsonKey(name: 'review_count') int reviewCount, int? stock,@JsonKey(name: 'option_names') List<String> optionNames, List<ProductVariantModel> variants, Map<String, String> attributes
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,Object? unitValue = null,Object? unitType = null,Object? prepTime = null,Object? isFavourite = null,Object? ratingAverage = null,Object? reviewCount = null,Object? stock = freezed,Object? optionNames = null,Object? variants = null,Object? attributes = null,}) {
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
as bool,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,optionNames: null == optionNames ? _self.optionNames : optionNames // ignore: cast_nullable_to_non_nullable
as List<String>,variants: null == variants ? _self.variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariantModel>,attributes: null == attributes ? _self.attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String image,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'unit_value')  double unitValue, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'prep_time')  String prepTime, @JsonKey(name: 'is_favourite')  bool isFavourite, @JsonKey(name: 'rating_average')  double ratingAverage, @JsonKey(name: 'review_count')  int reviewCount,  int? stock, @JsonKey(name: 'option_names')  List<String> optionNames,  List<ProductVariantModel> variants,  Map<String, String> attributes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.price,_that.originalPrice,_that.discountPercentage,_that.unitValue,_that.unitType,_that.prepTime,_that.isFavourite,_that.ratingAverage,_that.reviewCount,_that.stock,_that.optionNames,_that.variants,_that.attributes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String image,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'unit_value')  double unitValue, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'prep_time')  String prepTime, @JsonKey(name: 'is_favourite')  bool isFavourite, @JsonKey(name: 'rating_average')  double ratingAverage, @JsonKey(name: 'review_count')  int reviewCount,  int? stock, @JsonKey(name: 'option_names')  List<String> optionNames,  List<ProductVariantModel> variants,  Map<String, String> attributes)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.image,_that.price,_that.originalPrice,_that.discountPercentage,_that.unitValue,_that.unitType,_that.prepTime,_that.isFavourite,_that.ratingAverage,_that.reviewCount,_that.stock,_that.optionNames,_that.variants,_that.attributes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String image,  double price, @JsonKey(name: 'original_price')  double originalPrice, @JsonKey(name: 'discount_percentage')  double discountPercentage, @JsonKey(name: 'unit_value')  double unitValue, @JsonKey(name: 'unit_type')  String unitType, @JsonKey(name: 'prep_time')  String prepTime, @JsonKey(name: 'is_favourite')  bool isFavourite, @JsonKey(name: 'rating_average')  double ratingAverage, @JsonKey(name: 'review_count')  int reviewCount,  int? stock, @JsonKey(name: 'option_names')  List<String> optionNames,  List<ProductVariantModel> variants,  Map<String, String> attributes)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.price,_that.originalPrice,_that.discountPercentage,_that.unitValue,_that.unitType,_that.prepTime,_that.isFavourite,_that.ratingAverage,_that.reviewCount,_that.stock,_that.optionNames,_that.variants,_that.attributes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductModel extends ProductModel {
  const _ProductModel({required this.id, required this.name, required this.image, required this.price, @JsonKey(name: 'original_price') required this.originalPrice, @JsonKey(name: 'discount_percentage') required this.discountPercentage, @JsonKey(name: 'unit_value') required this.unitValue, @JsonKey(name: 'unit_type') required this.unitType, @JsonKey(name: 'prep_time') required this.prepTime, @JsonKey(name: 'is_favourite') this.isFavourite = false, @JsonKey(name: 'rating_average') this.ratingAverage = 0.0, @JsonKey(name: 'review_count') this.reviewCount = 0, this.stock, @JsonKey(name: 'option_names') final  List<String> optionNames = const <String>[], final  List<ProductVariantModel> variants = const <ProductVariantModel>[], final  Map<String, String> attributes = const <String, String>{}}): _optionNames = optionNames,_variants = variants,_attributes = attributes,super._();
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
// Defaulted, not required: a store whose products predate reviews (or a
// mock fixture) answers without these keys, and an unrated product is
// exactly what zeros mean.
@override@JsonKey(name: 'rating_average') final  double ratingAverage;
@override@JsonKey(name: 'review_count') final  int reviewCount;
// Nullable rather than defaulted: 0 is a real answer ("sold out") and an
// absent key is a different one ("this backend doesn't say"). Defaulting
// the missing case to 0 would render an entire catalog sold out against
// an older API, so unknown stays unknown and sells — see
// ProductEntityStockX.
@override final  int? stock;
// Defaulted, not required: a backend (or mock fixture) that predates
// variants answers without these, which is a simple product.
 final  List<String> _optionNames;
// Defaulted, not required: a backend (or mock fixture) that predates
// variants answers without these, which is a simple product.
@override@JsonKey(name: 'option_names') List<String> get optionNames {
  if (_optionNames is EqualUnmodifiableListView) return _optionNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_optionNames);
}

 final  List<ProductVariantModel> _variants;
@override@JsonKey() List<ProductVariantModel> get variants {
  if (_variants is EqualUnmodifiableListView) return _variants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variants);
}

 final  Map<String, String> _attributes;
@override@JsonKey() Map<String, String> get attributes {
  if (_attributes is EqualUnmodifiableMapView) return _attributes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_attributes);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountPercentage, discountPercentage) || other.discountPercentage == discountPercentage)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.prepTime, prepTime) || other.prepTime == prepTime)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.stock, stock) || other.stock == stock)&&const DeepCollectionEquality().equals(other._optionNames, _optionNames)&&const DeepCollectionEquality().equals(other._variants, _variants)&&const DeepCollectionEquality().equals(other._attributes, _attributes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,price,originalPrice,discountPercentage,unitValue,unitType,prepTime,isFavourite,ratingAverage,reviewCount,stock,const DeepCollectionEquality().hash(_optionNames),const DeepCollectionEquality().hash(_variants),const DeepCollectionEquality().hash(_attributes));

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, image: $image, price: $price, originalPrice: $originalPrice, discountPercentage: $discountPercentage, unitValue: $unitValue, unitType: $unitType, prepTime: $prepTime, isFavourite: $isFavourite, ratingAverage: $ratingAverage, reviewCount: $reviewCount, stock: $stock, optionNames: $optionNames, variants: $variants, attributes: $attributes)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String image, double price,@JsonKey(name: 'original_price') double originalPrice,@JsonKey(name: 'discount_percentage') double discountPercentage,@JsonKey(name: 'unit_value') double unitValue,@JsonKey(name: 'unit_type') String unitType,@JsonKey(name: 'prep_time') String prepTime,@JsonKey(name: 'is_favourite') bool isFavourite,@JsonKey(name: 'rating_average') double ratingAverage,@JsonKey(name: 'review_count') int reviewCount, int? stock,@JsonKey(name: 'option_names') List<String> optionNames, List<ProductVariantModel> variants, Map<String, String> attributes
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,Object? price = null,Object? originalPrice = null,Object? discountPercentage = null,Object? unitValue = null,Object? unitType = null,Object? prepTime = null,Object? isFavourite = null,Object? ratingAverage = null,Object? reviewCount = null,Object? stock = freezed,Object? optionNames = null,Object? variants = null,Object? attributes = null,}) {
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
as bool,ratingAverage: null == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as int?,optionNames: null == optionNames ? _self._optionNames : optionNames // ignore: cast_nullable_to_non_nullable
as List<String>,variants: null == variants ? _self._variants : variants // ignore: cast_nullable_to_non_nullable
as List<ProductVariantModel>,attributes: null == attributes ? _self._attributes : attributes // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
