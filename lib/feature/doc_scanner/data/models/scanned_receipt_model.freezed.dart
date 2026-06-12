// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scanned_receipt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScannedReceiptModel {

 String get id; String get imagePath; String? get restaurantName; String? get date; double? get amount; String? get currency;@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) ExtractionStatus get status; String? get errorMessage;
/// Create a copy of ScannedReceiptModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScannedReceiptModelCopyWith<ScannedReceiptModel> get copyWith => _$ScannedReceiptModelCopyWithImpl<ScannedReceiptModel>(this as ScannedReceiptModel, _$identity);

  /// Serializes this ScannedReceiptModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScannedReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,imagePath,restaurantName,date,amount,currency,status,errorMessage);

@override
String toString() {
  return 'ScannedReceiptModel(id: $id, imagePath: $imagePath, restaurantName: $restaurantName, date: $date, amount: $amount, currency: $currency, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ScannedReceiptModelCopyWith<$Res>  {
  factory $ScannedReceiptModelCopyWith(ScannedReceiptModel value, $Res Function(ScannedReceiptModel) _then) = _$ScannedReceiptModelCopyWithImpl;
@useResult
$Res call({
 String id, String imagePath, String? restaurantName, String? date, double? amount, String? currency,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) ExtractionStatus status, String? errorMessage
});




}
/// @nodoc
class _$ScannedReceiptModelCopyWithImpl<$Res>
    implements $ScannedReceiptModelCopyWith<$Res> {
  _$ScannedReceiptModelCopyWithImpl(this._self, this._then);

  final ScannedReceiptModel _self;
  final $Res Function(ScannedReceiptModel) _then;

/// Create a copy of ScannedReceiptModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? imagePath = null,Object? restaurantName = freezed,Object? date = freezed,Object? amount = freezed,Object? currency = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,restaurantName: freezed == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExtractionStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScannedReceiptModel].
extension ScannedReceiptModelPatterns on ScannedReceiptModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScannedReceiptModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScannedReceiptModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScannedReceiptModel value)  $default,){
final _that = this;
switch (_that) {
case _ScannedReceiptModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScannedReceiptModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScannedReceiptModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String imagePath,  String? restaurantName,  String? date,  double? amount,  String? currency, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  ExtractionStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScannedReceiptModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.restaurantName,_that.date,_that.amount,_that.currency,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String imagePath,  String? restaurantName,  String? date,  double? amount,  String? currency, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  ExtractionStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ScannedReceiptModel():
return $default(_that.id,_that.imagePath,_that.restaurantName,_that.date,_that.amount,_that.currency,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String imagePath,  String? restaurantName,  String? date,  double? amount,  String? currency, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)  ExtractionStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ScannedReceiptModel() when $default != null:
return $default(_that.id,_that.imagePath,_that.restaurantName,_that.date,_that.amount,_that.currency,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScannedReceiptModel extends ScannedReceiptModel {
  const _ScannedReceiptModel({required this.id, required this.imagePath, this.restaurantName, this.date, this.amount, this.currency, @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) required this.status, this.errorMessage}): super._();
  factory _ScannedReceiptModel.fromJson(Map<String, dynamic> json) => _$ScannedReceiptModelFromJson(json);

@override final  String id;
@override final  String imagePath;
@override final  String? restaurantName;
@override final  String? date;
@override final  double? amount;
@override final  String? currency;
@override@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) final  ExtractionStatus status;
@override final  String? errorMessage;

/// Create a copy of ScannedReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScannedReceiptModelCopyWith<_ScannedReceiptModel> get copyWith => __$ScannedReceiptModelCopyWithImpl<_ScannedReceiptModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScannedReceiptModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScannedReceiptModel&&(identical(other.id, id) || other.id == id)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,imagePath,restaurantName,date,amount,currency,status,errorMessage);

@override
String toString() {
  return 'ScannedReceiptModel(id: $id, imagePath: $imagePath, restaurantName: $restaurantName, date: $date, amount: $amount, currency: $currency, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ScannedReceiptModelCopyWith<$Res> implements $ScannedReceiptModelCopyWith<$Res> {
  factory _$ScannedReceiptModelCopyWith(_ScannedReceiptModel value, $Res Function(_ScannedReceiptModel) _then) = __$ScannedReceiptModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String imagePath, String? restaurantName, String? date, double? amount, String? currency,@JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) ExtractionStatus status, String? errorMessage
});




}
/// @nodoc
class __$ScannedReceiptModelCopyWithImpl<$Res>
    implements _$ScannedReceiptModelCopyWith<$Res> {
  __$ScannedReceiptModelCopyWithImpl(this._self, this._then);

  final _ScannedReceiptModel _self;
  final $Res Function(_ScannedReceiptModel) _then;

/// Create a copy of ScannedReceiptModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? imagePath = null,Object? restaurantName = freezed,Object? date = freezed,Object? amount = freezed,Object? currency = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_ScannedReceiptModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,restaurantName: freezed == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExtractionStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
