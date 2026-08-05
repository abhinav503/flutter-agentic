// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geo_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeoAddressModel {

 String get formatted;@JsonKey(name: 'address_line') String get addressLine; String get city; String get state;@JsonKey(name: 'postal_code') String get postalCode; String get country; double? get latitude; double? get longitude;
/// Create a copy of GeoAddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoAddressModelCopyWith<GeoAddressModel> get copyWith => _$GeoAddressModelCopyWithImpl<GeoAddressModel>(this as GeoAddressModel, _$identity);

  /// Serializes this GeoAddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoAddressModel&&(identical(other.formatted, formatted) || other.formatted == formatted)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.country, country) || other.country == country)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formatted,addressLine,city,state,postalCode,country,latitude,longitude);

@override
String toString() {
  return 'GeoAddressModel(formatted: $formatted, addressLine: $addressLine, city: $city, state: $state, postalCode: $postalCode, country: $country, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $GeoAddressModelCopyWith<$Res>  {
  factory $GeoAddressModelCopyWith(GeoAddressModel value, $Res Function(GeoAddressModel) _then) = _$GeoAddressModelCopyWithImpl;
@useResult
$Res call({
 String formatted,@JsonKey(name: 'address_line') String addressLine, String city, String state,@JsonKey(name: 'postal_code') String postalCode, String country, double? latitude, double? longitude
});




}
/// @nodoc
class _$GeoAddressModelCopyWithImpl<$Res>
    implements $GeoAddressModelCopyWith<$Res> {
  _$GeoAddressModelCopyWithImpl(this._self, this._then);

  final GeoAddressModel _self;
  final $Res Function(GeoAddressModel) _then;

/// Create a copy of GeoAddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? formatted = null,Object? addressLine = null,Object? city = null,Object? state = null,Object? postalCode = null,Object? country = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_self.copyWith(
formatted: null == formatted ? _self.formatted : formatted // ignore: cast_nullable_to_non_nullable
as String,addressLine: null == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoAddressModel].
extension GeoAddressModelPatterns on GeoAddressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoAddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoAddressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoAddressModel value)  $default,){
final _that = this;
switch (_that) {
case _GeoAddressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoAddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _GeoAddressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String formatted, @JsonKey(name: 'address_line')  String addressLine,  String city,  String state, @JsonKey(name: 'postal_code')  String postalCode,  String country,  double? latitude,  double? longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoAddressModel() when $default != null:
return $default(_that.formatted,_that.addressLine,_that.city,_that.state,_that.postalCode,_that.country,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String formatted, @JsonKey(name: 'address_line')  String addressLine,  String city,  String state, @JsonKey(name: 'postal_code')  String postalCode,  String country,  double? latitude,  double? longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoAddressModel():
return $default(_that.formatted,_that.addressLine,_that.city,_that.state,_that.postalCode,_that.country,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String formatted, @JsonKey(name: 'address_line')  String addressLine,  String city,  String state, @JsonKey(name: 'postal_code')  String postalCode,  String country,  double? latitude,  double? longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoAddressModel() when $default != null:
return $default(_that.formatted,_that.addressLine,_that.city,_that.state,_that.postalCode,_that.country,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoAddressModel extends GeoAddressModel {
  const _GeoAddressModel({this.formatted = '', @JsonKey(name: 'address_line') this.addressLine = '', this.city = '', this.state = '', @JsonKey(name: 'postal_code') this.postalCode = '', this.country = '', this.latitude, this.longitude}): super._();
  factory _GeoAddressModel.fromJson(Map<String, dynamic> json) => _$GeoAddressModelFromJson(json);

@override@JsonKey() final  String formatted;
@override@JsonKey(name: 'address_line') final  String addressLine;
@override@JsonKey() final  String city;
@override@JsonKey() final  String state;
@override@JsonKey(name: 'postal_code') final  String postalCode;
@override@JsonKey() final  String country;
@override final  double? latitude;
@override final  double? longitude;

/// Create a copy of GeoAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoAddressModelCopyWith<_GeoAddressModel> get copyWith => __$GeoAddressModelCopyWithImpl<_GeoAddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoAddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoAddressModel&&(identical(other.formatted, formatted) || other.formatted == formatted)&&(identical(other.addressLine, addressLine) || other.addressLine == addressLine)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.country, country) || other.country == country)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,formatted,addressLine,city,state,postalCode,country,latitude,longitude);

@override
String toString() {
  return 'GeoAddressModel(formatted: $formatted, addressLine: $addressLine, city: $city, state: $state, postalCode: $postalCode, country: $country, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoAddressModelCopyWith<$Res> implements $GeoAddressModelCopyWith<$Res> {
  factory _$GeoAddressModelCopyWith(_GeoAddressModel value, $Res Function(_GeoAddressModel) _then) = __$GeoAddressModelCopyWithImpl;
@override @useResult
$Res call({
 String formatted,@JsonKey(name: 'address_line') String addressLine, String city, String state,@JsonKey(name: 'postal_code') String postalCode, String country, double? latitude, double? longitude
});




}
/// @nodoc
class __$GeoAddressModelCopyWithImpl<$Res>
    implements _$GeoAddressModelCopyWith<$Res> {
  __$GeoAddressModelCopyWithImpl(this._self, this._then);

  final _GeoAddressModel _self;
  final $Res Function(_GeoAddressModel) _then;

/// Create a copy of GeoAddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? formatted = null,Object? addressLine = null,Object? city = null,Object? state = null,Object? postalCode = null,Object? country = null,Object? latitude = freezed,Object? longitude = freezed,}) {
  return _then(_GeoAddressModel(
formatted: null == formatted ? _self.formatted : formatted // ignore: cast_nullable_to_non_nullable
as String,addressLine: null == addressLine ? _self.addressLine : addressLine // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
