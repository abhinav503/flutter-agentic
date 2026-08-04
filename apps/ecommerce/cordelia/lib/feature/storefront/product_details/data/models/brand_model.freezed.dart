// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrandModel {

 String get id; String get name;// `image` not `imageUrl` — same wire convention as every other
// serializer (category/product/store).
 String get image;
/// Create a copy of BrandModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandModelCopyWith<BrandModel> get copyWith => _$BrandModelCopyWithImpl<BrandModel>(this as BrandModel, _$identity);

  /// Serializes this BrandModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image);

@override
String toString() {
  return 'BrandModel(id: $id, name: $name, image: $image)';
}


}

/// @nodoc
abstract mixin class $BrandModelCopyWith<$Res>  {
  factory $BrandModelCopyWith(BrandModel value, $Res Function(BrandModel) _then) = _$BrandModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String image
});




}
/// @nodoc
class _$BrandModelCopyWithImpl<$Res>
    implements $BrandModelCopyWith<$Res> {
  _$BrandModelCopyWithImpl(this._self, this._then);

  final BrandModel _self;
  final $Res Function(BrandModel) _then;

/// Create a copy of BrandModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BrandModel].
extension BrandModelPatterns on BrandModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrandModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrandModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrandModel value)  $default,){
final _that = this;
switch (_that) {
case _BrandModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrandModel value)?  $default,){
final _that = this;
switch (_that) {
case _BrandModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrandModel() when $default != null:
return $default(_that.id,_that.name,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String image)  $default,) {final _that = this;
switch (_that) {
case _BrandModel():
return $default(_that.id,_that.name,_that.image);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String image)?  $default,) {final _that = this;
switch (_that) {
case _BrandModel() when $default != null:
return $default(_that.id,_that.name,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrandModel extends BrandModel {
  const _BrandModel({required this.id, required this.name, required this.image}): super._();
  factory _BrandModel.fromJson(Map<String, dynamic> json) => _$BrandModelFromJson(json);

@override final  String id;
@override final  String name;
// `image` not `imageUrl` — same wire convention as every other
// serializer (category/product/store).
@override final  String image;

/// Create a copy of BrandModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandModelCopyWith<_BrandModel> get copyWith => __$BrandModelCopyWithImpl<_BrandModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrandModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrandModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image);

@override
String toString() {
  return 'BrandModel(id: $id, name: $name, image: $image)';
}


}

/// @nodoc
abstract mixin class _$BrandModelCopyWith<$Res> implements $BrandModelCopyWith<$Res> {
  factory _$BrandModelCopyWith(_BrandModel value, $Res Function(_BrandModel) _then) = __$BrandModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String image
});




}
/// @nodoc
class __$BrandModelCopyWithImpl<$Res>
    implements _$BrandModelCopyWith<$Res> {
  __$BrandModelCopyWithImpl(this._self, this._then);

  final _BrandModel _self;
  final $Res Function(_BrandModel) _then;

/// Create a copy of BrandModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,}) {
  return _then(_BrandModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
