// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_results_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResultsModel {

 List<ProductModel> get products; List<CategoryModel> get categories;
/// Create a copy of SearchResultsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultsModelCopyWith<SearchResultsModel> get copyWith => _$SearchResultsModelCopyWithImpl<SearchResultsModel>(this as SearchResultsModel, _$identity);

  /// Serializes this SearchResultsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultsModel&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'SearchResultsModel(products: $products, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $SearchResultsModelCopyWith<$Res>  {
  factory $SearchResultsModelCopyWith(SearchResultsModel value, $Res Function(SearchResultsModel) _then) = _$SearchResultsModelCopyWithImpl;
@useResult
$Res call({
 List<ProductModel> products, List<CategoryModel> categories
});




}
/// @nodoc
class _$SearchResultsModelCopyWithImpl<$Res>
    implements $SearchResultsModelCopyWith<$Res> {
  _$SearchResultsModelCopyWithImpl(this._self, this._then);

  final SearchResultsModel _self;
  final $Res Function(SearchResultsModel) _then;

/// Create a copy of SearchResultsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? products = null,Object? categories = null,}) {
  return _then(_self.copyWith(
products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResultsModel].
extension SearchResultsModelPatterns on SearchResultsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResultsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResultsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResultsModel value)  $default,){
final _that = this;
switch (_that) {
case _SearchResultsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResultsModel value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResultsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductModel> products,  List<CategoryModel> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResultsModel() when $default != null:
return $default(_that.products,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductModel> products,  List<CategoryModel> categories)  $default,) {final _that = this;
switch (_that) {
case _SearchResultsModel():
return $default(_that.products,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductModel> products,  List<CategoryModel> categories)?  $default,) {final _that = this;
switch (_that) {
case _SearchResultsModel() when $default != null:
return $default(_that.products,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResultsModel extends SearchResultsModel {
  const _SearchResultsModel({required final  List<ProductModel> products, required final  List<CategoryModel> categories}): _products = products,_categories = categories,super._();
  factory _SearchResultsModel.fromJson(Map<String, dynamic> json) => _$SearchResultsModelFromJson(json);

 final  List<ProductModel> _products;
@override List<ProductModel> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<CategoryModel> _categories;
@override List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of SearchResultsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultsModelCopyWith<_SearchResultsModel> get copyWith => __$SearchResultsModelCopyWithImpl<_SearchResultsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultsModel&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'SearchResultsModel(products: $products, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$SearchResultsModelCopyWith<$Res> implements $SearchResultsModelCopyWith<$Res> {
  factory _$SearchResultsModelCopyWith(_SearchResultsModel value, $Res Function(_SearchResultsModel) _then) = __$SearchResultsModelCopyWithImpl;
@override @useResult
$Res call({
 List<ProductModel> products, List<CategoryModel> categories
});




}
/// @nodoc
class __$SearchResultsModelCopyWithImpl<$Res>
    implements _$SearchResultsModelCopyWith<$Res> {
  __$SearchResultsModelCopyWithImpl(this._self, this._then);

  final _SearchResultsModel _self;
  final $Res Function(_SearchResultsModel) _then;

/// Create a copy of SearchResultsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? products = null,Object? categories = null,}) {
  return _then(_SearchResultsModel(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductModel>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,
  ));
}


}

// dart format on
