// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JokeModel {

 String get id; String get joke; int get status;
/// Create a copy of JokeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeModelCopyWith<JokeModel> get copyWith => _$JokeModelCopyWithImpl<JokeModel>(this as JokeModel, _$identity);

  /// Serializes this JokeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.joke, joke) || other.joke == joke)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,joke,status);

@override
String toString() {
  return 'JokeModel(id: $id, joke: $joke, status: $status)';
}


}

/// @nodoc
abstract mixin class $JokeModelCopyWith<$Res>  {
  factory $JokeModelCopyWith(JokeModel value, $Res Function(JokeModel) _then) = _$JokeModelCopyWithImpl;
@useResult
$Res call({
 String id, String joke, int status
});




}
/// @nodoc
class _$JokeModelCopyWithImpl<$Res>
    implements $JokeModelCopyWith<$Res> {
  _$JokeModelCopyWithImpl(this._self, this._then);

  final JokeModel _self;
  final $Res Function(JokeModel) _then;

/// Create a copy of JokeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? joke = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,joke: null == joke ? _self.joke : joke // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JokeModel].
extension JokeModelPatterns on JokeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokeModel value)  $default,){
final _that = this;
switch (_that) {
case _JokeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokeModel value)?  $default,){
final _that = this;
switch (_that) {
case _JokeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String joke,  int status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokeModel() when $default != null:
return $default(_that.id,_that.joke,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String joke,  int status)  $default,) {final _that = this;
switch (_that) {
case _JokeModel():
return $default(_that.id,_that.joke,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String joke,  int status)?  $default,) {final _that = this;
switch (_that) {
case _JokeModel() when $default != null:
return $default(_that.id,_that.joke,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JokeModel implements JokeModel {
  const _JokeModel({required this.id, required this.joke, required this.status});
  factory _JokeModel.fromJson(Map<String, dynamic> json) => _$JokeModelFromJson(json);

@override final  String id;
@override final  String joke;
@override final  int status;

/// Create a copy of JokeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokeModelCopyWith<_JokeModel> get copyWith => __$JokeModelCopyWithImpl<_JokeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JokeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.joke, joke) || other.joke == joke)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,joke,status);

@override
String toString() {
  return 'JokeModel(id: $id, joke: $joke, status: $status)';
}


}

/// @nodoc
abstract mixin class _$JokeModelCopyWith<$Res> implements $JokeModelCopyWith<$Res> {
  factory _$JokeModelCopyWith(_JokeModel value, $Res Function(_JokeModel) _then) = __$JokeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String joke, int status
});




}
/// @nodoc
class __$JokeModelCopyWithImpl<$Res>
    implements _$JokeModelCopyWith<$Res> {
  __$JokeModelCopyWithImpl(this._self, this._then);

  final _JokeModel _self;
  final $Res Function(_JokeModel) _then;

/// Create a copy of JokeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? joke = null,Object? status = null,}) {
  return _then(_JokeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,joke: null == joke ? _self.joke : joke // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
