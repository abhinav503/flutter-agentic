// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_suggestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaceSuggestionModel {

 String get description;@JsonKey(name: 'place_id') String get placeId; double? get latitude; double? get longitude;
/// Create a copy of PlaceSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceSuggestionModelCopyWith<PlaceSuggestionModel> get copyWith => _$PlaceSuggestionModelCopyWithImpl<PlaceSuggestionModel>(this as PlaceSuggestionModel, _$identity);

  /// Serializes this PlaceSuggestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceSuggestionModel&&(identical(other.description, description) || other.description == description)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,placeId,latitude,longitude);

@override
String toString() {
  return 'PlaceSuggestionModel(description: $description, placeId: $placeId, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $PlaceSuggestionModelCopyWith<$Res>  {
  factory $PlaceSuggestionModelCopyWith(PlaceSuggestionModel value, $Res Function(PlaceSuggestionModel) _then) = _$PlaceSuggestionModelCopyWithImpl;
@useResult
$Res call({
 String description,@JsonKey(name: 'place_id') String placeId, double? latitude, double? longitude
});




}
/// @nodoc
class _$PlaceSuggestionModelCopyWithImpl<$Res>
    implements $PlaceSuggestionModelCopyWith<$Res> {
  _$PlaceSuggestionModelCopyWithImpl(this._self, this._then);

  final PlaceSuggestionModel _self;
  final $Res Function(PlaceSuggestionModel) _then;

/// Create a copy of PlaceSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = null,Object? placeId = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceSuggestionModel].
extension PlaceSuggestionModelPatterns on PlaceSuggestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceSuggestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceSuggestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceSuggestionModel value)  $default,){
final _that = this;
switch (_that) {
case _PlaceSuggestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceSuggestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceSuggestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String description, @JsonKey(name: 'place_id')  String placeId,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceSuggestionModel() when $default != null:
return $default(_that.description,_that.placeId,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String description, @JsonKey(name: 'place_id')  String placeId,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _PlaceSuggestionModel():
return $default(_that.description,_that.placeId,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String description, @JsonKey(name: 'place_id')  String placeId,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _PlaceSuggestionModel() when $default != null:
return $default(_that.description,_that.placeId,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaceSuggestionModel extends PlaceSuggestionModel {
  const _PlaceSuggestionModel({this.description = '', @JsonKey(name: 'place_id') this.placeId = '', this.latitude, this.longitude}): super._();
  factory _PlaceSuggestionModel.fromJson(Map<String, dynamic> json) => _$PlaceSuggestionModelFromJson(json);

@override@JsonKey() final  String description;
@override@JsonKey(name: 'place_id') final  String placeId;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of PlaceSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceSuggestionModelCopyWith<_PlaceSuggestionModel> get copyWith => __$PlaceSuggestionModelCopyWithImpl<_PlaceSuggestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceSuggestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceSuggestionModel&&(identical(other.description, description) || other.description == description)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,placeId,latitude,longitude);

@override
String toString() {
  return 'PlaceSuggestionModel(description: $description, placeId: $placeId, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$PlaceSuggestionModelCopyWith<$Res> implements $PlaceSuggestionModelCopyWith<$Res> {
  factory _$PlaceSuggestionModelCopyWith(_PlaceSuggestionModel value, $Res Function(_PlaceSuggestionModel) _then) = __$PlaceSuggestionModelCopyWithImpl;
@override @useResult
$Res call({
 String description,@JsonKey(name: 'place_id') String placeId, double? latitude, double? longitude
});




}
/// @nodoc
class __$PlaceSuggestionModelCopyWithImpl<$Res>
    implements _$PlaceSuggestionModelCopyWith<$Res> {
  __$PlaceSuggestionModelCopyWithImpl(this._self, this._then);

  final _PlaceSuggestionModel _self;
  final $Res Function(_PlaceSuggestionModel) _then;

/// Create a copy of PlaceSuggestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = null,Object? placeId = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_PlaceSuggestionModel(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
