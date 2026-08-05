// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pincode_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PincodeInfoModel {

 String get city; String get state; String get country;
/// Create a copy of PincodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PincodeInfoModelCopyWith<PincodeInfoModel> get copyWith => _$PincodeInfoModelCopyWithImpl<PincodeInfoModel>(this as PincodeInfoModel, _$identity);

  /// Serializes this PincodeInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PincodeInfoModel&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,city,state,country);

@override
String toString() {
  return 'PincodeInfoModel(city: $city, state: $state, country: $country)';
}


}

/// @nodoc
abstract mixin class $PincodeInfoModelCopyWith<$Res>  {
  factory $PincodeInfoModelCopyWith(PincodeInfoModel value, $Res Function(PincodeInfoModel) _then) = _$PincodeInfoModelCopyWithImpl;
@useResult
$Res call({
 String city, String state, String country
});




}
/// @nodoc
class _$PincodeInfoModelCopyWithImpl<$Res>
    implements $PincodeInfoModelCopyWith<$Res> {
  _$PincodeInfoModelCopyWithImpl(this._self, this._then);

  final PincodeInfoModel _self;
  final $Res Function(PincodeInfoModel) _then;

/// Create a copy of PincodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = null,Object? state = null,Object? country = null,}) {
  return _then(_self.copyWith(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PincodeInfoModel].
extension PincodeInfoModelPatterns on PincodeInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PincodeInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PincodeInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PincodeInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _PincodeInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PincodeInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _PincodeInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String city,  String state,  String country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PincodeInfoModel() when $default != null:
return $default(_that.city,_that.state,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String city,  String state,  String country)  $default,) {final _that = this;
switch (_that) {
case _PincodeInfoModel():
return $default(_that.city,_that.state,_that.country);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String city,  String state,  String country)?  $default,) {final _that = this;
switch (_that) {
case _PincodeInfoModel() when $default != null:
return $default(_that.city,_that.state,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PincodeInfoModel extends PincodeInfoModel {
  const _PincodeInfoModel({this.city = '', this.state = '', this.country = ''}): super._();
  factory _PincodeInfoModel.fromJson(Map<String, dynamic> json) => _$PincodeInfoModelFromJson(json);

@override@JsonKey() final  String city;
@override@JsonKey() final  String state;
@override@JsonKey() final  String country;

/// Create a copy of PincodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PincodeInfoModelCopyWith<_PincodeInfoModel> get copyWith => __$PincodeInfoModelCopyWithImpl<_PincodeInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PincodeInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PincodeInfoModel&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,city,state,country);

@override
String toString() {
  return 'PincodeInfoModel(city: $city, state: $state, country: $country)';
}


}

/// @nodoc
abstract mixin class _$PincodeInfoModelCopyWith<$Res> implements $PincodeInfoModelCopyWith<$Res> {
  factory _$PincodeInfoModelCopyWith(_PincodeInfoModel value, $Res Function(_PincodeInfoModel) _then) = __$PincodeInfoModelCopyWithImpl;
@override @useResult
$Res call({
 String city, String state, String country
});




}
/// @nodoc
class __$PincodeInfoModelCopyWithImpl<$Res>
    implements _$PincodeInfoModelCopyWith<$Res> {
  __$PincodeInfoModelCopyWithImpl(this._self, this._then);

  final _PincodeInfoModel _self;
  final $Res Function(_PincodeInfoModel) _then;

/// Create a copy of PincodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = null,Object? state = null,Object? country = null,}) {
  return _then(_PincodeInfoModel(
city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
