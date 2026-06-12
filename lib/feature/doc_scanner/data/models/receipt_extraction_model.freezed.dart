// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_extraction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReceiptExtractionModel {

@JsonKey(name: 'restaurant_name') String? get restaurantName; String? get date;@JsonKey(name: 'total_amount') num? get totalAmount; String? get currency;
/// Create a copy of ReceiptExtractionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptExtractionModelCopyWith<ReceiptExtractionModel> get copyWith => _$ReceiptExtractionModelCopyWithImpl<ReceiptExtractionModel>(this as ReceiptExtractionModel, _$identity);

  /// Serializes this ReceiptExtractionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptExtractionModel&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantName,date,totalAmount,currency);

@override
String toString() {
  return 'ReceiptExtractionModel(restaurantName: $restaurantName, date: $date, totalAmount: $totalAmount, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $ReceiptExtractionModelCopyWith<$Res>  {
  factory $ReceiptExtractionModelCopyWith(ReceiptExtractionModel value, $Res Function(ReceiptExtractionModel) _then) = _$ReceiptExtractionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'restaurant_name') String? restaurantName, String? date,@JsonKey(name: 'total_amount') num? totalAmount, String? currency
});




}
/// @nodoc
class _$ReceiptExtractionModelCopyWithImpl<$Res>
    implements $ReceiptExtractionModelCopyWith<$Res> {
  _$ReceiptExtractionModelCopyWithImpl(this._self, this._then);

  final ReceiptExtractionModel _self;
  final $Res Function(ReceiptExtractionModel) _then;

/// Create a copy of ReceiptExtractionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restaurantName = freezed,Object? date = freezed,Object? totalAmount = freezed,Object? currency = freezed,}) {
  return _then(_self.copyWith(
restaurantName: freezed == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptExtractionModel].
extension ReceiptExtractionModelPatterns on ReceiptExtractionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptExtractionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptExtractionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptExtractionModel value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptExtractionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptExtractionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptExtractionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_name')  String? restaurantName,  String? date, @JsonKey(name: 'total_amount')  num? totalAmount,  String? currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptExtractionModel() when $default != null:
return $default(_that.restaurantName,_that.date,_that.totalAmount,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_name')  String? restaurantName,  String? date, @JsonKey(name: 'total_amount')  num? totalAmount,  String? currency)  $default,) {final _that = this;
switch (_that) {
case _ReceiptExtractionModel():
return $default(_that.restaurantName,_that.date,_that.totalAmount,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'restaurant_name')  String? restaurantName,  String? date, @JsonKey(name: 'total_amount')  num? totalAmount,  String? currency)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptExtractionModel() when $default != null:
return $default(_that.restaurantName,_that.date,_that.totalAmount,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptExtractionModel extends ReceiptExtractionModel {
  const _ReceiptExtractionModel({@JsonKey(name: 'restaurant_name') this.restaurantName, this.date, @JsonKey(name: 'total_amount') this.totalAmount, this.currency}): super._();
  factory _ReceiptExtractionModel.fromJson(Map<String, dynamic> json) => _$ReceiptExtractionModelFromJson(json);

@override@JsonKey(name: 'restaurant_name') final  String? restaurantName;
@override final  String? date;
@override@JsonKey(name: 'total_amount') final  num? totalAmount;
@override final  String? currency;

/// Create a copy of ReceiptExtractionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptExtractionModelCopyWith<_ReceiptExtractionModel> get copyWith => __$ReceiptExtractionModelCopyWithImpl<_ReceiptExtractionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptExtractionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptExtractionModel&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantName,date,totalAmount,currency);

@override
String toString() {
  return 'ReceiptExtractionModel(restaurantName: $restaurantName, date: $date, totalAmount: $totalAmount, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$ReceiptExtractionModelCopyWith<$Res> implements $ReceiptExtractionModelCopyWith<$Res> {
  factory _$ReceiptExtractionModelCopyWith(_ReceiptExtractionModel value, $Res Function(_ReceiptExtractionModel) _then) = __$ReceiptExtractionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'restaurant_name') String? restaurantName, String? date,@JsonKey(name: 'total_amount') num? totalAmount, String? currency
});




}
/// @nodoc
class __$ReceiptExtractionModelCopyWithImpl<$Res>
    implements _$ReceiptExtractionModelCopyWith<$Res> {
  __$ReceiptExtractionModelCopyWithImpl(this._self, this._then);

  final _ReceiptExtractionModel _self;
  final $Res Function(_ReceiptExtractionModel) _then;

/// Create a copy of ReceiptExtractionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restaurantName = freezed,Object? date = freezed,Object? totalAmount = freezed,Object? currency = freezed,}) {
  return _then(_ReceiptExtractionModel(
restaurantName: freezed == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as num?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
