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

// Every field below the first two is defaulted rather than required: a
// server deployment predating the Razorpay/Stripe split omits `provider`
// and `clientSecret` entirely, and checkout must keep working against it.
// An absent provider parses to Razorpay, which is what such a server is.
@JsonKey(name: 'provider', defaultValue: 'razorpay') String get provider;@JsonKey(name: 'paymentOrderId') String get paymentOrderId;@JsonKey(name: 'publishableKey') String get publishableKey;@JsonKey(name: 'clientSecret', defaultValue: '') String get clientSecret; int get amount; String get currency;@JsonKey(name: 'storeName', defaultValue: '') String get storeName;
/// Create a copy of PaymentIntentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentIntentModelCopyWith<PaymentIntentModel> get copyWith => _$PaymentIntentModelCopyWithImpl<PaymentIntentModel>(this as PaymentIntentModel, _$identity);

  /// Serializes this PaymentIntentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentIntentModel&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.paymentOrderId, paymentOrderId) || other.paymentOrderId == paymentOrderId)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.storeName, storeName) || other.storeName == storeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,paymentOrderId,publishableKey,clientSecret,amount,currency,storeName);

@override
String toString() {
  return 'PaymentIntentModel(provider: $provider, paymentOrderId: $paymentOrderId, publishableKey: $publishableKey, clientSecret: $clientSecret, amount: $amount, currency: $currency, storeName: $storeName)';
}


}

/// @nodoc
abstract mixin class $PaymentIntentModelCopyWith<$Res>  {
  factory $PaymentIntentModelCopyWith(PaymentIntentModel value, $Res Function(PaymentIntentModel) _then) = _$PaymentIntentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'provider', defaultValue: 'razorpay') String provider,@JsonKey(name: 'paymentOrderId') String paymentOrderId,@JsonKey(name: 'publishableKey') String publishableKey,@JsonKey(name: 'clientSecret', defaultValue: '') String clientSecret, int amount, String currency,@JsonKey(name: 'storeName', defaultValue: '') String storeName
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
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? paymentOrderId = null,Object? publishableKey = null,Object? clientSecret = null,Object? amount = null,Object? currency = null,Object? storeName = null,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,paymentOrderId: null == paymentOrderId ? _self.paymentOrderId : paymentOrderId // ignore: cast_nullable_to_non_nullable
as String,publishableKey: null == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider', defaultValue: 'razorpay')  String provider, @JsonKey(name: 'paymentOrderId')  String paymentOrderId, @JsonKey(name: 'publishableKey')  String publishableKey, @JsonKey(name: 'clientSecret', defaultValue: '')  String clientSecret,  int amount,  String currency, @JsonKey(name: 'storeName', defaultValue: '')  String storeName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentIntentModel() when $default != null:
return $default(_that.provider,_that.paymentOrderId,_that.publishableKey,_that.clientSecret,_that.amount,_that.currency,_that.storeName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider', defaultValue: 'razorpay')  String provider, @JsonKey(name: 'paymentOrderId')  String paymentOrderId, @JsonKey(name: 'publishableKey')  String publishableKey, @JsonKey(name: 'clientSecret', defaultValue: '')  String clientSecret,  int amount,  String currency, @JsonKey(name: 'storeName', defaultValue: '')  String storeName)  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentModel():
return $default(_that.provider,_that.paymentOrderId,_that.publishableKey,_that.clientSecret,_that.amount,_that.currency,_that.storeName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'provider', defaultValue: 'razorpay')  String provider, @JsonKey(name: 'paymentOrderId')  String paymentOrderId, @JsonKey(name: 'publishableKey')  String publishableKey, @JsonKey(name: 'clientSecret', defaultValue: '')  String clientSecret,  int amount,  String currency, @JsonKey(name: 'storeName', defaultValue: '')  String storeName)?  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentModel() when $default != null:
return $default(_that.provider,_that.paymentOrderId,_that.publishableKey,_that.clientSecret,_that.amount,_that.currency,_that.storeName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentIntentModel extends PaymentIntentModel {
  const _PaymentIntentModel({@JsonKey(name: 'provider', defaultValue: 'razorpay') required this.provider, @JsonKey(name: 'paymentOrderId') required this.paymentOrderId, @JsonKey(name: 'publishableKey') required this.publishableKey, @JsonKey(name: 'clientSecret', defaultValue: '') required this.clientSecret, required this.amount, required this.currency, @JsonKey(name: 'storeName', defaultValue: '') required this.storeName}): super._();
  factory _PaymentIntentModel.fromJson(Map<String, dynamic> json) => _$PaymentIntentModelFromJson(json);

// Every field below the first two is defaulted rather than required: a
// server deployment predating the Razorpay/Stripe split omits `provider`
// and `clientSecret` entirely, and checkout must keep working against it.
// An absent provider parses to Razorpay, which is what such a server is.
@override@JsonKey(name: 'provider', defaultValue: 'razorpay') final  String provider;
@override@JsonKey(name: 'paymentOrderId') final  String paymentOrderId;
@override@JsonKey(name: 'publishableKey') final  String publishableKey;
@override@JsonKey(name: 'clientSecret', defaultValue: '') final  String clientSecret;
@override final  int amount;
@override final  String currency;
@override@JsonKey(name: 'storeName', defaultValue: '') final  String storeName;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentIntentModel&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.paymentOrderId, paymentOrderId) || other.paymentOrderId == paymentOrderId)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey)&&(identical(other.clientSecret, clientSecret) || other.clientSecret == clientSecret)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.storeName, storeName) || other.storeName == storeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,paymentOrderId,publishableKey,clientSecret,amount,currency,storeName);

@override
String toString() {
  return 'PaymentIntentModel(provider: $provider, paymentOrderId: $paymentOrderId, publishableKey: $publishableKey, clientSecret: $clientSecret, amount: $amount, currency: $currency, storeName: $storeName)';
}


}

/// @nodoc
abstract mixin class _$PaymentIntentModelCopyWith<$Res> implements $PaymentIntentModelCopyWith<$Res> {
  factory _$PaymentIntentModelCopyWith(_PaymentIntentModel value, $Res Function(_PaymentIntentModel) _then) = __$PaymentIntentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'provider', defaultValue: 'razorpay') String provider,@JsonKey(name: 'paymentOrderId') String paymentOrderId,@JsonKey(name: 'publishableKey') String publishableKey,@JsonKey(name: 'clientSecret', defaultValue: '') String clientSecret, int amount, String currency,@JsonKey(name: 'storeName', defaultValue: '') String storeName
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
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? paymentOrderId = null,Object? publishableKey = null,Object? clientSecret = null,Object? amount = null,Object? currency = null,Object? storeName = null,}) {
  return _then(_PaymentIntentModel(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,paymentOrderId: null == paymentOrderId ? _self.paymentOrderId : paymentOrderId // ignore: cast_nullable_to_non_nullable
as String,publishableKey: null == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String,clientSecret: null == clientSecret ? _self.clientSecret : clientSecret // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
