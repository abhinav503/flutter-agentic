// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_intent_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentIntentModel {

@JsonKey(name: 'razorpayOrderId') String get razorpayOrderId;@JsonKey(name: 'razorpayKeyId') String get razorpayKeyId; int get amount; String get currency;
/// Create a copy of PaymentIntentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentIntentModelCopyWith<PaymentIntentModel> get copyWith => _$PaymentIntentModelCopyWithImpl<PaymentIntentModel>(this as PaymentIntentModel, _$identity);

  /// Serializes this PaymentIntentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentIntentModel&&(identical(other.razorpayOrderId, razorpayOrderId) || other.razorpayOrderId == razorpayOrderId)&&(identical(other.razorpayKeyId, razorpayKeyId) || other.razorpayKeyId == razorpayKeyId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,razorpayOrderId,razorpayKeyId,amount,currency);

@override
String toString() {
  return 'PaymentIntentModel(razorpayOrderId: $razorpayOrderId, razorpayKeyId: $razorpayKeyId, amount: $amount, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $PaymentIntentModelCopyWith<$Res>  {
  factory $PaymentIntentModelCopyWith(PaymentIntentModel value, $Res Function(PaymentIntentModel) _then) = _$PaymentIntentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'razorpayOrderId') String razorpayOrderId,@JsonKey(name: 'razorpayKeyId') String razorpayKeyId, int amount, String currency
});




}
/// @nodoc
class _$PaymentIntentModelCopyWithImpl<$Res>
    implements $PaymentIntentModelCopyWith<$Res> {
  _$PaymentIntentModelCopyWithImpl(this._self, this._then);

  final PaymentIntentModel _self;
  final $Res Function(PaymentIntentModel) _then;

/// Create a copy of PaymentIntentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? razorpayOrderId = null,Object? razorpayKeyId = null,Object? amount = null,Object? currency = null,}) {
  return _then(_self.copyWith(
razorpayOrderId: null == razorpayOrderId ? _self.razorpayOrderId : razorpayOrderId // ignore: cast_nullable_to_non_nullable
as String,razorpayKeyId: null == razorpayKeyId ? _self.razorpayKeyId : razorpayKeyId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentIntentModel].
extension PaymentIntentModelPatterns on PaymentIntentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentIntentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentIntentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentIntentModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentIntentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentIntentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentIntentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'razorpayOrderId')  String razorpayOrderId, @JsonKey(name: 'razorpayKeyId')  String razorpayKeyId,  int amount,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentIntentModel() when $default != null:
return $default(_that.razorpayOrderId,_that.razorpayKeyId,_that.amount,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'razorpayOrderId')  String razorpayOrderId, @JsonKey(name: 'razorpayKeyId')  String razorpayKeyId,  int amount,  String currency)  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentModel():
return $default(_that.razorpayOrderId,_that.razorpayKeyId,_that.amount,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'razorpayOrderId')  String razorpayOrderId, @JsonKey(name: 'razorpayKeyId')  String razorpayKeyId,  int amount,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentModel() when $default != null:
return $default(_that.razorpayOrderId,_that.razorpayKeyId,_that.amount,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentIntentModel extends PaymentIntentModel {
  const _PaymentIntentModel({@JsonKey(name: 'razorpayOrderId') required this.razorpayOrderId, @JsonKey(name: 'razorpayKeyId') required this.razorpayKeyId, required this.amount, required this.currency}): super._();
  factory _PaymentIntentModel.fromJson(Map<String, dynamic> json) => _$PaymentIntentModelFromJson(json);

@override@JsonKey(name: 'razorpayOrderId') final  String razorpayOrderId;
@override@JsonKey(name: 'razorpayKeyId') final  String razorpayKeyId;
@override final  int amount;
@override final  String currency;

/// Create a copy of PaymentIntentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentIntentModelCopyWith<_PaymentIntentModel> get copyWith => __$PaymentIntentModelCopyWithImpl<_PaymentIntentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentIntentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentIntentModel&&(identical(other.razorpayOrderId, razorpayOrderId) || other.razorpayOrderId == razorpayOrderId)&&(identical(other.razorpayKeyId, razorpayKeyId) || other.razorpayKeyId == razorpayKeyId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,razorpayOrderId,razorpayKeyId,amount,currency);

@override
String toString() {
  return 'PaymentIntentModel(razorpayOrderId: $razorpayOrderId, razorpayKeyId: $razorpayKeyId, amount: $amount, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$PaymentIntentModelCopyWith<$Res> implements $PaymentIntentModelCopyWith<$Res> {
  factory _$PaymentIntentModelCopyWith(_PaymentIntentModel value, $Res Function(_PaymentIntentModel) _then) = __$PaymentIntentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'razorpayOrderId') String razorpayOrderId,@JsonKey(name: 'razorpayKeyId') String razorpayKeyId, int amount, String currency
});




}
/// @nodoc
class __$PaymentIntentModelCopyWithImpl<$Res>
    implements _$PaymentIntentModelCopyWith<$Res> {
  __$PaymentIntentModelCopyWithImpl(this._self, this._then);

  final _PaymentIntentModel _self;
  final $Res Function(_PaymentIntentModel) _then;

/// Create a copy of PaymentIntentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? razorpayOrderId = null,Object? razorpayKeyId = null,Object? amount = null,Object? currency = null,}) {
  return _then(_PaymentIntentModel(
razorpayOrderId: null == razorpayOrderId ? _self.razorpayOrderId : razorpayOrderId // ignore: cast_nullable_to_non_nullable
as String,razorpayKeyId: null == razorpayKeyId ? _self.razorpayKeyId : razorpayKeyId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
