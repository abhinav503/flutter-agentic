// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_search_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentSearchModel {

 String get id; String get name;// Raw wire string ('product' / 'category') — parsed to RecentSearchType
// only in toEntity(), per the data-layer-parses-wire-strings convention.
 String get type;
/// Create a copy of RecentSearchModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentSearchModelCopyWith<RecentSearchModel> get copyWith => _$RecentSearchModelCopyWithImpl<RecentSearchModel>(this as RecentSearchModel, _$identity);

  /// Serializes this RecentSearchModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentSearchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type);

@override
String toString() {
  return 'RecentSearchModel(id: $id, name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class $RecentSearchModelCopyWith<$Res>  {
  factory $RecentSearchModelCopyWith(RecentSearchModel value, $Res Function(RecentSearchModel) _then) = _$RecentSearchModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type
});




}
/// @nodoc
class _$RecentSearchModelCopyWithImpl<$Res>
    implements $RecentSearchModelCopyWith<$Res> {
  _$RecentSearchModelCopyWithImpl(this._self, this._then);

  final RecentSearchModel _self;
  final $Res Function(RecentSearchModel) _then;

/// Create a copy of RecentSearchModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentSearchModel].
extension RecentSearchModelPatterns on RecentSearchModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentSearchModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentSearchModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentSearchModel value)  $default,){
final _that = this;
switch (_that) {
case _RecentSearchModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentSearchModel value)?  $default,){
final _that = this;
switch (_that) {
case _RecentSearchModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentSearchModel() when $default != null:
return $default(_that.id,_that.name,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String type)  $default,) {final _that = this;
switch (_that) {
case _RecentSearchModel():
return $default(_that.id,_that.name,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String type)?  $default,) {final _that = this;
switch (_that) {
case _RecentSearchModel() when $default != null:
return $default(_that.id,_that.name,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentSearchModel extends RecentSearchModel {
  const _RecentSearchModel({required this.id, required this.name, required this.type}): super._();
  factory _RecentSearchModel.fromJson(Map<String, dynamic> json) => _$RecentSearchModelFromJson(json);

@override final  String id;
@override final  String name;
// Raw wire string ('product' / 'category') — parsed to RecentSearchType
// only in toEntity(), per the data-layer-parses-wire-strings convention.
@override final  String type;

/// Create a copy of RecentSearchModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentSearchModelCopyWith<_RecentSearchModel> get copyWith => __$RecentSearchModelCopyWithImpl<_RecentSearchModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentSearchModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentSearchModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type);

@override
String toString() {
  return 'RecentSearchModel(id: $id, name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class _$RecentSearchModelCopyWith<$Res> implements $RecentSearchModelCopyWith<$Res> {
  factory _$RecentSearchModelCopyWith(_RecentSearchModel value, $Res Function(_RecentSearchModel) _then) = __$RecentSearchModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type
});




}
/// @nodoc
class __$RecentSearchModelCopyWithImpl<$Res>
    implements _$RecentSearchModelCopyWith<$Res> {
  __$RecentSearchModelCopyWithImpl(this._self, this._then);

  final _RecentSearchModel _self;
  final $Res Function(_RecentSearchModel) _then;

/// Create a copy of RecentSearchModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,}) {
  return _then(_RecentSearchModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
