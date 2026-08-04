// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductDetailModel {

 ProductModel get product; List<String> get images; String get description;// The pre-variant wire field (values only, price implied linear) — kept
// so responses from a backend that predates size_variants still parse;
// the repository upgrades it to priced variants on load.
@JsonKey(name: 'size_options') List<double> get sizeOptions;// Defaulted, not required: a backend that predates per-size pricing
// answers without the key.
@JsonKey(name: 'size_variants') List<SizeVariantModel> get sizeVariants;@JsonKey(name: 'similar_products') List<ProductModel> get similarProducts;// Nullable, not required: a product need not belong to a category, and
// stores created before this field shipped answer without the key.
 CategoryModel? get category;// Nullable like category — unbranded products (and pre-brand backends)
// answer without the key.
 BrandModel? get brand;
/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailModelCopyWith<ProductDetailModel> get copyWith => _$ProductDetailModelCopyWithImpl<ProductDetailModel>(this as ProductDetailModel, _$identity);

  /// Serializes this ProductDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailModel&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.sizeOptions, sizeOptions)&&const DeepCollectionEquality().equals(other.sizeVariants, sizeVariants)&&const DeepCollectionEquality().equals(other.similarProducts, similarProducts)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(images),description,const DeepCollectionEquality().hash(sizeOptions),const DeepCollectionEquality().hash(sizeVariants),const DeepCollectionEquality().hash(similarProducts),category,brand);

@override
String toString() {
  return 'ProductDetailModel(product: $product, images: $images, description: $description, sizeOptions: $sizeOptions, sizeVariants: $sizeVariants, similarProducts: $similarProducts, category: $category, brand: $brand)';
}


}

/// @nodoc
abstract mixin class $ProductDetailModelCopyWith<$Res>  {
  factory $ProductDetailModelCopyWith(ProductDetailModel value, $Res Function(ProductDetailModel) _then) = _$ProductDetailModelCopyWithImpl;
@useResult
$Res call({
 ProductModel product, List<String> images, String description,@JsonKey(name: 'size_options') List<double> sizeOptions,@JsonKey(name: 'size_variants') List<SizeVariantModel> sizeVariants,@JsonKey(name: 'similar_products') List<ProductModel> similarProducts, CategoryModel? category, BrandModel? brand
});


$ProductModelCopyWith<$Res> get product;$CategoryModelCopyWith<$Res>? get category;$BrandModelCopyWith<$Res>? get brand;

}
/// @nodoc
class _$ProductDetailModelCopyWithImpl<$Res>
    implements $ProductDetailModelCopyWith<$Res> {
  _$ProductDetailModelCopyWithImpl(this._self, this._then);

  final ProductDetailModel _self;
  final $Res Function(ProductDetailModel) _then;

/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? product = null,Object? images = null,Object? description = null,Object? sizeOptions = null,Object? sizeVariants = null,Object? similarProducts = null,Object? category = freezed,Object? brand = freezed,}) {
  return _then(_self.copyWith(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sizeOptions: null == sizeOptions ? _self.sizeOptions : sizeOptions // ignore: cast_nullable_to_non_nullable
as List<double>,sizeVariants: null == sizeVariants ? _self.sizeVariants : sizeVariants // ignore: cast_nullable_to_non_nullable
as List<SizeVariantModel>,similarProducts: null == similarProducts ? _self.similarProducts : similarProducts // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandModel?,
  ));
}
/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandModelCopyWith<$Res>? get brand {
    if (_self.brand == null) {
    return null;
  }

  return $BrandModelCopyWith<$Res>(_self.brand!, (value) {
    return _then(_self.copyWith(brand: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetailModel].
extension ProductDetailModelPatterns on ProductDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductModel product,  List<String> images,  String description, @JsonKey(name: 'size_options')  List<double> sizeOptions, @JsonKey(name: 'size_variants')  List<SizeVariantModel> sizeVariants, @JsonKey(name: 'similar_products')  List<ProductModel> similarProducts,  CategoryModel? category,  BrandModel? brand)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetailModel() when $default != null:
return $default(_that.product,_that.images,_that.description,_that.sizeOptions,_that.sizeVariants,_that.similarProducts,_that.category,_that.brand);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductModel product,  List<String> images,  String description, @JsonKey(name: 'size_options')  List<double> sizeOptions, @JsonKey(name: 'size_variants')  List<SizeVariantModel> sizeVariants, @JsonKey(name: 'similar_products')  List<ProductModel> similarProducts,  CategoryModel? category,  BrandModel? brand)  $default,) {final _that = this;
switch (_that) {
case _ProductDetailModel():
return $default(_that.product,_that.images,_that.description,_that.sizeOptions,_that.sizeVariants,_that.similarProducts,_that.category,_that.brand);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductModel product,  List<String> images,  String description, @JsonKey(name: 'size_options')  List<double> sizeOptions, @JsonKey(name: 'size_variants')  List<SizeVariantModel> sizeVariants, @JsonKey(name: 'similar_products')  List<ProductModel> similarProducts,  CategoryModel? category,  BrandModel? brand)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetailModel() when $default != null:
return $default(_that.product,_that.images,_that.description,_that.sizeOptions,_that.sizeVariants,_that.similarProducts,_that.category,_that.brand);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDetailModel extends ProductDetailModel {
  const _ProductDetailModel({required this.product, required final  List<String> images, required this.description, @JsonKey(name: 'size_options') required final  List<double> sizeOptions, @JsonKey(name: 'size_variants') final  List<SizeVariantModel> sizeVariants = const <SizeVariantModel>[], @JsonKey(name: 'similar_products') required final  List<ProductModel> similarProducts, this.category, this.brand}): _images = images,_sizeOptions = sizeOptions,_sizeVariants = sizeVariants,_similarProducts = similarProducts,super._();
  factory _ProductDetailModel.fromJson(Map<String, dynamic> json) => _$ProductDetailModelFromJson(json);

@override final  ProductModel product;
 final  List<String> _images;
@override List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  String description;
// The pre-variant wire field (values only, price implied linear) — kept
// so responses from a backend that predates size_variants still parse;
// the repository upgrades it to priced variants on load.
 final  List<double> _sizeOptions;
// The pre-variant wire field (values only, price implied linear) — kept
// so responses from a backend that predates size_variants still parse;
// the repository upgrades it to priced variants on load.
@override@JsonKey(name: 'size_options') List<double> get sizeOptions {
  if (_sizeOptions is EqualUnmodifiableListView) return _sizeOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizeOptions);
}

// Defaulted, not required: a backend that predates per-size pricing
// answers without the key.
 final  List<SizeVariantModel> _sizeVariants;
// Defaulted, not required: a backend that predates per-size pricing
// answers without the key.
@override@JsonKey(name: 'size_variants') List<SizeVariantModel> get sizeVariants {
  if (_sizeVariants is EqualUnmodifiableListView) return _sizeVariants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sizeVariants);
}

 final  List<ProductModel> _similarProducts;
@override@JsonKey(name: 'similar_products') List<ProductModel> get similarProducts {
  if (_similarProducts is EqualUnmodifiableListView) return _similarProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_similarProducts);
}

// Nullable, not required: a product need not belong to a category, and
// stores created before this field shipped answer without the key.
@override final  CategoryModel? category;
// Nullable like category — unbranded products (and pre-brand backends)
// answer without the key.
@override final  BrandModel? brand;

/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailModelCopyWith<_ProductDetailModel> get copyWith => __$ProductDetailModelCopyWithImpl<_ProductDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetailModel&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._sizeOptions, _sizeOptions)&&const DeepCollectionEquality().equals(other._sizeVariants, _sizeVariants)&&const DeepCollectionEquality().equals(other._similarProducts, _similarProducts)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_images),description,const DeepCollectionEquality().hash(_sizeOptions),const DeepCollectionEquality().hash(_sizeVariants),const DeepCollectionEquality().hash(_similarProducts),category,brand);

@override
String toString() {
  return 'ProductDetailModel(product: $product, images: $images, description: $description, sizeOptions: $sizeOptions, sizeVariants: $sizeVariants, similarProducts: $similarProducts, category: $category, brand: $brand)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailModelCopyWith<$Res> implements $ProductDetailModelCopyWith<$Res> {
  factory _$ProductDetailModelCopyWith(_ProductDetailModel value, $Res Function(_ProductDetailModel) _then) = __$ProductDetailModelCopyWithImpl;
@override @useResult
$Res call({
 ProductModel product, List<String> images, String description,@JsonKey(name: 'size_options') List<double> sizeOptions,@JsonKey(name: 'size_variants') List<SizeVariantModel> sizeVariants,@JsonKey(name: 'similar_products') List<ProductModel> similarProducts, CategoryModel? category, BrandModel? brand
});


@override $ProductModelCopyWith<$Res> get product;@override $CategoryModelCopyWith<$Res>? get category;@override $BrandModelCopyWith<$Res>? get brand;

}
/// @nodoc
class __$ProductDetailModelCopyWithImpl<$Res>
    implements _$ProductDetailModelCopyWith<$Res> {
  __$ProductDetailModelCopyWithImpl(this._self, this._then);

  final _ProductDetailModel _self;
  final $Res Function(_ProductDetailModel) _then;

/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? product = null,Object? images = null,Object? description = null,Object? sizeOptions = null,Object? sizeVariants = null,Object? similarProducts = null,Object? category = freezed,Object? brand = freezed,}) {
  return _then(_ProductDetailModel(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as ProductModel,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sizeOptions: null == sizeOptions ? _self._sizeOptions : sizeOptions // ignore: cast_nullable_to_non_nullable
as List<double>,sizeVariants: null == sizeVariants ? _self._sizeVariants : sizeVariants // ignore: cast_nullable_to_non_nullable
as List<SizeVariantModel>,similarProducts: null == similarProducts ? _self._similarProducts : similarProducts // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as CategoryModel?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as BrandModel?,
  ));
}

/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductModelCopyWith<$Res> get product {
  
  return $ProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryModelCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $CategoryModelCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of ProductDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandModelCopyWith<$Res>? get brand {
    if (_self.brand == null) {
    return null;
  }

  return $BrandModelCopyWith<$Res>(_self.brand!, (value) {
    return _then(_self.copyWith(brand: value));
  });
}
}

// dart format on
