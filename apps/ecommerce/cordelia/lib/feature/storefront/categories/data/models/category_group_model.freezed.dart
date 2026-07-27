// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryGroupModel {

 String get name; List<CategoryModel> get categories;
/// Create a copy of CategoryGroupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryGroupModelCopyWith<CategoryGroupModel> get copyWith => _$CategoryGroupModelCopyWithImpl<CategoryGroupModel>(this as CategoryGroupModel, _$identity);

  /// Serializes this CategoryGroupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryGroupModel&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'CategoryGroupModel(name: $name, categories: $categories)';
}


}

/// @nodoc
abstract mixin class $CategoryGroupModelCopyWith<$Res>  {
  factory $CategoryGroupModelCopyWith(CategoryGroupModel value, $Res Function(CategoryGroupModel) _then) = _$CategoryGroupModelCopyWithImpl;
@useResult
$Res call({
 String name, List<CategoryModel> categories
});




}
/// @nodoc
class _$CategoryGroupModelCopyWithImpl<$Res>
    implements $CategoryGroupModelCopyWith<$Res> {
  _$CategoryGroupModelCopyWithImpl(this._self, this._then);

  final CategoryGroupModel _self;
  final $Res Function(CategoryGroupModel) _then;

/// Create a copy of CategoryGroupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? categories = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryGroupModel].
extension CategoryGroupModelPatterns on CategoryGroupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryGroupModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryGroupModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryGroupModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryGroupModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryGroupModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryGroupModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  List<CategoryModel> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryGroupModel() when $default != null:
return $default(_that.name,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  List<CategoryModel> categories)  $default,) {final _that = this;
switch (_that) {
case _CategoryGroupModel():
return $default(_that.name,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  List<CategoryModel> categories)?  $default,) {final _that = this;
switch (_that) {
case _CategoryGroupModel() when $default != null:
return $default(_that.name,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryGroupModel extends CategoryGroupModel {
  const _CategoryGroupModel({required this.name, required final  List<CategoryModel> categories}): _categories = categories,super._();
  factory _CategoryGroupModel.fromJson(Map<String, dynamic> json) => _$CategoryGroupModelFromJson(json);

@override final  String name;
 final  List<CategoryModel> _categories;
@override List<CategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of CategoryGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryGroupModelCopyWith<_CategoryGroupModel> get copyWith => __$CategoryGroupModelCopyWithImpl<_CategoryGroupModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryGroupModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryGroupModel&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'CategoryGroupModel(name: $name, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$CategoryGroupModelCopyWith<$Res> implements $CategoryGroupModelCopyWith<$Res> {
  factory _$CategoryGroupModelCopyWith(_CategoryGroupModel value, $Res Function(_CategoryGroupModel) _then) = __$CategoryGroupModelCopyWithImpl;
@override @useResult
$Res call({
 String name, List<CategoryModel> categories
});




}
/// @nodoc
class __$CategoryGroupModelCopyWithImpl<$Res>
    implements _$CategoryGroupModelCopyWith<$Res> {
  __$CategoryGroupModelCopyWithImpl(this._self, this._then);

  final _CategoryGroupModel _self;
  final $Res Function(_CategoryGroupModel) _then;

/// Create a copy of CategoryGroupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? categories = null,}) {
  return _then(_CategoryGroupModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<CategoryModel>,
  ));
}


}

// dart format on
