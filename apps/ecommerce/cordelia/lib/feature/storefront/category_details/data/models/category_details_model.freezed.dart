// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryDetailsModel {

 List<ProductModel> get products;
/// Create a copy of CategoryDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailsModelCopyWith<CategoryDetailsModel> get copyWith => _$CategoryDetailsModelCopyWithImpl<CategoryDetailsModel>(this as CategoryDetailsModel, _$identity);

  /// Serializes this CategoryDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsModel&&const DeepCollectionEquality().equals(other.products, products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(products));

@override
String toString() {
  return 'CategoryDetailsModel(products: $products)';
}


}

/// @nodoc
abstract mixin class $CategoryDetailsModelCopyWith<$Res>  {
  factory $CategoryDetailsModelCopyWith(CategoryDetailsModel value, $Res Function(CategoryDetailsModel) _then) = _$CategoryDetailsModelCopyWithImpl;
@useResult
$Res call({
 List<ProductModel> products
});




}
/// @nodoc
class _$CategoryDetailsModelCopyWithImpl<$Res>
    implements $CategoryDetailsModelCopyWith<$Res> {
  _$CategoryDetailsModelCopyWithImpl(this._self, this._then);

  final CategoryDetailsModel _self;
  final $Res Function(CategoryDetailsModel) _then;

/// Create a copy of CategoryDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,}) {
  return _then(_self.copyWith(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryDetailsModel].
extension CategoryDetailsModelPatterns on CategoryDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductModel> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryDetailsModel() when $default != null:
return $default(_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductModel> products)  $default,) {final _that = this;
switch (_that) {
case _CategoryDetailsModel():
return $default(_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductModel> products)?  $default,) {final _that = this;
switch (_that) {
case _CategoryDetailsModel() when $default != null:
return $default(_that.products);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryDetailsModel extends CategoryDetailsModel {
  const _CategoryDetailsModel({required final  List<ProductModel> products}): _products = products,super._();
  factory _CategoryDetailsModel.fromJson(Map<String, dynamic> json) => _$CategoryDetailsModelFromJson(json);

 final  List<ProductModel> _products;
@override List<ProductModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of CategoryDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDetailsModelCopyWith<_CategoryDetailsModel> get copyWith => __$CategoryDetailsModelCopyWithImpl<_CategoryDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryDetailsModel&&const DeepCollectionEquality().equals(other._products, _products));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'CategoryDetailsModel(products: $products)';
}


}

/// @nodoc
abstract mixin class _$CategoryDetailsModelCopyWith<$Res> implements $CategoryDetailsModelCopyWith<$Res> {
  factory _$CategoryDetailsModelCopyWith(_CategoryDetailsModel value, $Res Function(_CategoryDetailsModel) _then) = __$CategoryDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 List<ProductModel> products
});




}
/// @nodoc
class __$CategoryDetailsModelCopyWithImpl<$Res>
    implements _$CategoryDetailsModelCopyWith<$Res> {
  __$CategoryDetailsModelCopyWithImpl(this._self, this._then);

  final _CategoryDetailsModel _self;
  final $Res Function(_CategoryDetailsModel) _then;

/// Create a copy of CategoryDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(_CategoryDetailsModel(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,
  ));
}


}

// dart format on
