// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_status_change_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderStatusChangeModel {

 String get status; String get at;
/// Create a copy of OrderStatusChangeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderStatusChangeModelCopyWith<OrderStatusChangeModel> get copyWith => _$OrderStatusChangeModelCopyWithImpl<OrderStatusChangeModel>(this as OrderStatusChangeModel, _$identity);

  /// Serializes this OrderStatusChangeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderStatusChangeModel&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,at);

@override
String toString() {
  return 'OrderStatusChangeModel(status: $status, at: $at)';
}


}

/// @nodoc
abstract mixin class $OrderStatusChangeModelCopyWith<$Res>  {
  factory $OrderStatusChangeModelCopyWith(OrderStatusChangeModel value, $Res Function(OrderStatusChangeModel) _then) = _$OrderStatusChangeModelCopyWithImpl;
@useResult
$Res call({
 String status, String at
});




}
/// @nodoc
class _$OrderStatusChangeModelCopyWithImpl<$Res>
    implements $OrderStatusChangeModelCopyWith<$Res> {
  _$OrderStatusChangeModelCopyWithImpl(this._self, this._then);

  final OrderStatusChangeModel _self;
  final $Res Function(OrderStatusChangeModel) _then;

/// Create a copy of OrderStatusChangeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? at = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderStatusChangeModel].
extension OrderStatusChangeModelPatterns on OrderStatusChangeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderStatusChangeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderStatusChangeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderStatusChangeModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderStatusChangeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderStatusChangeModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderStatusChangeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderStatusChangeModel() when $default != null:
return $default(_that.status,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String at)  $default,) {final _that = this;
switch (_that) {
case _OrderStatusChangeModel():
return $default(_that.status,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String at)?  $default,) {final _that = this;
switch (_that) {
case _OrderStatusChangeModel() when $default != null:
return $default(_that.status,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderStatusChangeModel extends OrderStatusChangeModel {
  const _OrderStatusChangeModel({required this.status, required this.at}): super._();
  factory _OrderStatusChangeModel.fromJson(Map<String, dynamic> json) => _$OrderStatusChangeModelFromJson(json);

@override final  String status;
@override final  String at;

/// Create a copy of OrderStatusChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderStatusChangeModelCopyWith<_OrderStatusChangeModel> get copyWith => __$OrderStatusChangeModelCopyWithImpl<_OrderStatusChangeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderStatusChangeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderStatusChangeModel&&(identical(other.status, status) || other.status == status)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,at);

@override
String toString() {
  return 'OrderStatusChangeModel(status: $status, at: $at)';
}


}

/// @nodoc
abstract mixin class _$OrderStatusChangeModelCopyWith<$Res> implements $OrderStatusChangeModelCopyWith<$Res> {
  factory _$OrderStatusChangeModelCopyWith(_OrderStatusChangeModel value, $Res Function(_OrderStatusChangeModel) _then) = __$OrderStatusChangeModelCopyWithImpl;
@override @useResult
$Res call({
 String status, String at
});




}
/// @nodoc
class __$OrderStatusChangeModelCopyWithImpl<$Res>
    implements _$OrderStatusChangeModelCopyWith<$Res> {
  __$OrderStatusChangeModelCopyWithImpl(this._self, this._then);

  final _OrderStatusChangeModel _self;
  final $Res Function(_OrderStatusChangeModel) _then;

/// Create a copy of OrderStatusChangeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? at = null,}) {
  return _then(_OrderStatusChangeModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
