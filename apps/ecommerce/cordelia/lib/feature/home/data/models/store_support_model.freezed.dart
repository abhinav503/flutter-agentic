// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_support_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreSupportModel {

 String get email; String get phone; String get hours;
/// Create a copy of StoreSupportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSupportModelCopyWith<StoreSupportModel> get copyWith => _$StoreSupportModelCopyWithImpl<StoreSupportModel>(this as StoreSupportModel, _$identity);

  /// Serializes this StoreSupportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSupportModel&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,hours);

@override
String toString() {
  return 'StoreSupportModel(email: $email, phone: $phone, hours: $hours)';
}


}

/// @nodoc
abstract mixin class $StoreSupportModelCopyWith<$Res>  {
  factory $StoreSupportModelCopyWith(StoreSupportModel value, $Res Function(StoreSupportModel) _then) = _$StoreSupportModelCopyWithImpl;
@useResult
$Res call({
 String email, String phone, String hours
});




}
/// @nodoc
class _$StoreSupportModelCopyWithImpl<$Res>
    implements $StoreSupportModelCopyWith<$Res> {
  _$StoreSupportModelCopyWithImpl(this._self, this._then);

  final StoreSupportModel _self;
  final $Res Function(StoreSupportModel) _then;

/// Create a copy of StoreSupportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? phone = null,Object? hours = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSupportModel].
extension StoreSupportModelPatterns on StoreSupportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSupportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSupportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSupportModel value)  $default,){
final _that = this;
switch (_that) {
case _StoreSupportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSupportModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSupportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String phone,  String hours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSupportModel() when $default != null:
return $default(_that.email,_that.phone,_that.hours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String phone,  String hours)  $default,) {final _that = this;
switch (_that) {
case _StoreSupportModel():
return $default(_that.email,_that.phone,_that.hours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String phone,  String hours)?  $default,) {final _that = this;
switch (_that) {
case _StoreSupportModel() when $default != null:
return $default(_that.email,_that.phone,_that.hours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreSupportModel extends StoreSupportModel {
  const _StoreSupportModel({this.email = '', this.phone = '', this.hours = ''}): super._();
  factory _StoreSupportModel.fromJson(Map<String, dynamic> json) => _$StoreSupportModelFromJson(json);

@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String hours;

/// Create a copy of StoreSupportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSupportModelCopyWith<_StoreSupportModel> get copyWith => __$StoreSupportModelCopyWithImpl<_StoreSupportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreSupportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSupportModel&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.hours, hours) || other.hours == hours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,hours);

@override
String toString() {
  return 'StoreSupportModel(email: $email, phone: $phone, hours: $hours)';
}


}

/// @nodoc
abstract mixin class _$StoreSupportModelCopyWith<$Res> implements $StoreSupportModelCopyWith<$Res> {
  factory _$StoreSupportModelCopyWith(_StoreSupportModel value, $Res Function(_StoreSupportModel) _then) = __$StoreSupportModelCopyWithImpl;
@override @useResult
$Res call({
 String email, String phone, String hours
});




}
/// @nodoc
class __$StoreSupportModelCopyWithImpl<$Res>
    implements _$StoreSupportModelCopyWith<$Res> {
  __$StoreSupportModelCopyWithImpl(this._self, this._then);

  final _StoreSupportModel _self;
  final $Res Function(_StoreSupportModel) _then;

/// Create a copy of StoreSupportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? phone = null,Object? hours = null,}) {
  return _then(_StoreSupportModel(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
