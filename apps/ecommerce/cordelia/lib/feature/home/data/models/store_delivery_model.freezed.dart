// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_delivery_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreDeliveryModel {

 double get fee;@JsonKey(name: 'free_above') double get freeAbove; List<String> get areas;
/// Create a copy of StoreDeliveryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDeliveryModelCopyWith<StoreDeliveryModel> get copyWith => _$StoreDeliveryModelCopyWithImpl<StoreDeliveryModel>(this as StoreDeliveryModel, _$identity);

  /// Serializes this StoreDeliveryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDeliveryModel&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.freeAbove, freeAbove) || other.freeAbove == freeAbove)&&const DeepCollectionEquality().equals(other.areas, areas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fee,freeAbove,const DeepCollectionEquality().hash(areas));

@override
String toString() {
  return 'StoreDeliveryModel(fee: $fee, freeAbove: $freeAbove, areas: $areas)';
}


}

/// @nodoc
abstract mixin class $StoreDeliveryModelCopyWith<$Res>  {
  factory $StoreDeliveryModelCopyWith(StoreDeliveryModel value, $Res Function(StoreDeliveryModel) _then) = _$StoreDeliveryModelCopyWithImpl;
@useResult
$Res call({
 double fee,@JsonKey(name: 'free_above') double freeAbove, List<String> areas
});




}
/// @nodoc
class _$StoreDeliveryModelCopyWithImpl<$Res>
    implements $StoreDeliveryModelCopyWith<$Res> {
  _$StoreDeliveryModelCopyWithImpl(this._self, this._then);

  final StoreDeliveryModel _self;
  final $Res Function(StoreDeliveryModel) _then;

/// Create a copy of StoreDeliveryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fee = null,Object? freeAbove = null,Object? areas = null,}) {
  return _then(_self.copyWith(
fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as double,freeAbove: null == freeAbove ? _self.freeAbove : freeAbove // ignore: cast_nullable_to_non_nullable
as double,areas: null == areas ? _self.areas : areas // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreDeliveryModel].
extension StoreDeliveryModelPatterns on StoreDeliveryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDeliveryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDeliveryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDeliveryModel value)  $default,){
final _that = this;
switch (_that) {
case _StoreDeliveryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDeliveryModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDeliveryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double fee, @JsonKey(name: 'free_above')  double freeAbove,  List<String> areas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDeliveryModel() when $default != null:
return $default(_that.fee,_that.freeAbove,_that.areas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double fee, @JsonKey(name: 'free_above')  double freeAbove,  List<String> areas)  $default,) {final _that = this;
switch (_that) {
case _StoreDeliveryModel():
return $default(_that.fee,_that.freeAbove,_that.areas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double fee, @JsonKey(name: 'free_above')  double freeAbove,  List<String> areas)?  $default,) {final _that = this;
switch (_that) {
case _StoreDeliveryModel() when $default != null:
return $default(_that.fee,_that.freeAbove,_that.areas);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreDeliveryModel extends StoreDeliveryModel {
  const _StoreDeliveryModel({this.fee = 0.0, @JsonKey(name: 'free_above') this.freeAbove = 0.0, final  List<String> areas = const <String>[]}): _areas = areas,super._();
  factory _StoreDeliveryModel.fromJson(Map<String, dynamic> json) => _$StoreDeliveryModelFromJson(json);

@override@JsonKey() final  double fee;
@override@JsonKey(name: 'free_above') final  double freeAbove;
 final  List<String> _areas;
@override@JsonKey() List<String> get areas {
  if (_areas is EqualUnmodifiableListView) return _areas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_areas);
}


/// Create a copy of StoreDeliveryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDeliveryModelCopyWith<_StoreDeliveryModel> get copyWith => __$StoreDeliveryModelCopyWithImpl<_StoreDeliveryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreDeliveryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDeliveryModel&&(identical(other.fee, fee) || other.fee == fee)&&(identical(other.freeAbove, freeAbove) || other.freeAbove == freeAbove)&&const DeepCollectionEquality().equals(other._areas, _areas));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fee,freeAbove,const DeepCollectionEquality().hash(_areas));

@override
String toString() {
  return 'StoreDeliveryModel(fee: $fee, freeAbove: $freeAbove, areas: $areas)';
}


}

/// @nodoc
abstract mixin class _$StoreDeliveryModelCopyWith<$Res> implements $StoreDeliveryModelCopyWith<$Res> {
  factory _$StoreDeliveryModelCopyWith(_StoreDeliveryModel value, $Res Function(_StoreDeliveryModel) _then) = __$StoreDeliveryModelCopyWithImpl;
@override @useResult
$Res call({
 double fee,@JsonKey(name: 'free_above') double freeAbove, List<String> areas
});




}
/// @nodoc
class __$StoreDeliveryModelCopyWithImpl<$Res>
    implements _$StoreDeliveryModelCopyWith<$Res> {
  __$StoreDeliveryModelCopyWithImpl(this._self, this._then);

  final _StoreDeliveryModel _self;
  final $Res Function(_StoreDeliveryModel) _then;

/// Create a copy of StoreDeliveryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fee = null,Object? freeAbove = null,Object? areas = null,}) {
  return _then(_StoreDeliveryModel(
fee: null == fee ? _self.fee : fee // ignore: cast_nullable_to_non_nullable
as double,freeAbove: null == freeAbove ? _self.freeAbove : freeAbove // ignore: cast_nullable_to_non_nullable
as double,areas: null == areas ? _self._areas : areas // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
