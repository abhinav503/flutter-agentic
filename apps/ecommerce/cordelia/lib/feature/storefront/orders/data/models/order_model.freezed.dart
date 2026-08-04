// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {

 String get id; String get status;// Defaulted: orders placed before the refund axis existed (and the
// fromEntity path) omit it — parsed to RefundStatus.none in toEntity.
@JsonKey(name: 'refund_status') String get refundStatus;@JsonKey(name: 'placed_at') String get placedAt;// Defaulted: the bundled mock orders carry no timeline, and neither does
// the fromEntity path.
@JsonKey(name: 'status_history') List<OrderStatusChangeModel> get statusHistory;@JsonKey(name: 'delivery_otp') String get deliveryOtp;// Defaulted: empty on the payment-less path, and absent from the mock
// orders and from orders serialized before the field existed.
@JsonKey(name: 'payment_id') String get paymentId;// Defaulted: orders placed without a coupon (and those predating the
// feature) omit both.
@JsonKey(name: 'coupon_code') String get couponCode;@JsonKey(name: 'coupon_discount') double get couponDiscount;// The shopper's rating of this delivery. Defaulted: 0 is every order
// that hasn't been rated, including every one placed before the feature
// existed, and reviewed_at is absent for exactly the same set.
 int get rating;@JsonKey(name: 'review_text') String get reviewText;@JsonKey(name: 'reviewed_at') String get reviewedAt; List<OrderLineItemModel> get items;// Reuses AddressModel — the server serializes the snapshot through the
// same shape the /users/addresses endpoints use. Nullable: legacy orders
// predate the field.
@JsonKey(name: 'delivery_address') AddressModel? get deliveryAddress;
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderModelCopyWith<OrderModel> get copyWith => _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundStatus, refundStatus) || other.refundStatus == refundStatus)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory)&&(identical(other.deliveryOtp, deliveryOtp) || other.deliveryOtp == deliveryOtp)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode)&&(identical(other.couponDiscount, couponDiscount) || other.couponDiscount == couponDiscount)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewText, reviewText) || other.reviewText == reviewText)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,refundStatus,placedAt,const DeepCollectionEquality().hash(statusHistory),deliveryOtp,paymentId,couponCode,couponDiscount,rating,reviewText,reviewedAt,const DeepCollectionEquality().hash(items),deliveryAddress);

@override
String toString() {
  return 'OrderModel(id: $id, status: $status, refundStatus: $refundStatus, placedAt: $placedAt, statusHistory: $statusHistory, deliveryOtp: $deliveryOtp, paymentId: $paymentId, couponCode: $couponCode, couponDiscount: $couponDiscount, rating: $rating, reviewText: $reviewText, reviewedAt: $reviewedAt, items: $items, deliveryAddress: $deliveryAddress)';
}


}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res>  {
  factory $OrderModelCopyWith(OrderModel value, $Res Function(OrderModel) _then) = _$OrderModelCopyWithImpl;
@useResult
$Res call({
 String id, String status,@JsonKey(name: 'refund_status') String refundStatus,@JsonKey(name: 'placed_at') String placedAt,@JsonKey(name: 'status_history') List<OrderStatusChangeModel> statusHistory,@JsonKey(name: 'delivery_otp') String deliveryOtp,@JsonKey(name: 'payment_id') String paymentId,@JsonKey(name: 'coupon_code') String couponCode,@JsonKey(name: 'coupon_discount') double couponDiscount, int rating,@JsonKey(name: 'review_text') String reviewText,@JsonKey(name: 'reviewed_at') String reviewedAt, List<OrderLineItemModel> items,@JsonKey(name: 'delivery_address') AddressModel? deliveryAddress
});


$AddressModelCopyWith<$Res>? get deliveryAddress;

}
/// @nodoc
class _$OrderModelCopyWithImpl<$Res>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? refundStatus = null,Object? placedAt = null,Object? statusHistory = null,Object? deliveryOtp = null,Object? paymentId = null,Object? couponCode = null,Object? couponDiscount = null,Object? rating = null,Object? reviewText = null,Object? reviewedAt = null,Object? items = null,Object? deliveryAddress = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,refundStatus: null == refundStatus ? _self.refundStatus : refundStatus // ignore: cast_nullable_to_non_nullable
as String,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as String,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<OrderStatusChangeModel>,deliveryOtp: null == deliveryOtp ? _self.deliveryOtp : deliveryOtp // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,couponCode: null == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String,couponDiscount: null == couponDiscount ? _self.couponDiscount : couponDiscount // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,reviewText: null == reviewText ? _self.reviewText : reviewText // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: null == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineItemModel>,deliveryAddress: freezed == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as AddressModel?,
  ));
}
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressModelCopyWith<$Res>? get deliveryAddress {
    if (_self.deliveryAddress == null) {
    return null;
  }

  return $AddressModelCopyWith<$Res>(_self.deliveryAddress!, (value) {
    return _then(_self.copyWith(deliveryAddress: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'refund_status')  String refundStatus, @JsonKey(name: 'placed_at')  String placedAt, @JsonKey(name: 'status_history')  List<OrderStatusChangeModel> statusHistory, @JsonKey(name: 'delivery_otp')  String deliveryOtp, @JsonKey(name: 'payment_id')  String paymentId, @JsonKey(name: 'coupon_code')  String couponCode, @JsonKey(name: 'coupon_discount')  double couponDiscount,  int rating, @JsonKey(name: 'review_text')  String reviewText, @JsonKey(name: 'reviewed_at')  String reviewedAt,  List<OrderLineItemModel> items, @JsonKey(name: 'delivery_address')  AddressModel? deliveryAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.status,_that.refundStatus,_that.placedAt,_that.statusHistory,_that.deliveryOtp,_that.paymentId,_that.couponCode,_that.couponDiscount,_that.rating,_that.reviewText,_that.reviewedAt,_that.items,_that.deliveryAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'refund_status')  String refundStatus, @JsonKey(name: 'placed_at')  String placedAt, @JsonKey(name: 'status_history')  List<OrderStatusChangeModel> statusHistory, @JsonKey(name: 'delivery_otp')  String deliveryOtp, @JsonKey(name: 'payment_id')  String paymentId, @JsonKey(name: 'coupon_code')  String couponCode, @JsonKey(name: 'coupon_discount')  double couponDiscount,  int rating, @JsonKey(name: 'review_text')  String reviewText, @JsonKey(name: 'reviewed_at')  String reviewedAt,  List<OrderLineItemModel> items, @JsonKey(name: 'delivery_address')  AddressModel? deliveryAddress)  $default,) {final _that = this;
switch (_that) {
case _OrderModel():
return $default(_that.id,_that.status,_that.refundStatus,_that.placedAt,_that.statusHistory,_that.deliveryOtp,_that.paymentId,_that.couponCode,_that.couponDiscount,_that.rating,_that.reviewText,_that.reviewedAt,_that.items,_that.deliveryAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status, @JsonKey(name: 'refund_status')  String refundStatus, @JsonKey(name: 'placed_at')  String placedAt, @JsonKey(name: 'status_history')  List<OrderStatusChangeModel> statusHistory, @JsonKey(name: 'delivery_otp')  String deliveryOtp, @JsonKey(name: 'payment_id')  String paymentId, @JsonKey(name: 'coupon_code')  String couponCode, @JsonKey(name: 'coupon_discount')  double couponDiscount,  int rating, @JsonKey(name: 'review_text')  String reviewText, @JsonKey(name: 'reviewed_at')  String reviewedAt,  List<OrderLineItemModel> items, @JsonKey(name: 'delivery_address')  AddressModel? deliveryAddress)?  $default,) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.status,_that.refundStatus,_that.placedAt,_that.statusHistory,_that.deliveryOtp,_that.paymentId,_that.couponCode,_that.couponDiscount,_that.rating,_that.reviewText,_that.reviewedAt,_that.items,_that.deliveryAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderModel extends OrderModel {
  const _OrderModel({required this.id, required this.status, @JsonKey(name: 'refund_status') this.refundStatus = 'NONE', @JsonKey(name: 'placed_at') required this.placedAt, @JsonKey(name: 'status_history') final  List<OrderStatusChangeModel> statusHistory = const <OrderStatusChangeModel>[], @JsonKey(name: 'delivery_otp') required this.deliveryOtp, @JsonKey(name: 'payment_id') this.paymentId = '', @JsonKey(name: 'coupon_code') this.couponCode = '', @JsonKey(name: 'coupon_discount') this.couponDiscount = 0, this.rating = 0, @JsonKey(name: 'review_text') this.reviewText = '', @JsonKey(name: 'reviewed_at') this.reviewedAt = '', required final  List<OrderLineItemModel> items, @JsonKey(name: 'delivery_address') this.deliveryAddress}): _statusHistory = statusHistory,_items = items,super._();
  factory _OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

@override final  String id;
@override final  String status;
// Defaulted: orders placed before the refund axis existed (and the
// fromEntity path) omit it — parsed to RefundStatus.none in toEntity.
@override@JsonKey(name: 'refund_status') final  String refundStatus;
@override@JsonKey(name: 'placed_at') final  String placedAt;
// Defaulted: the bundled mock orders carry no timeline, and neither does
// the fromEntity path.
 final  List<OrderStatusChangeModel> _statusHistory;
// Defaulted: the bundled mock orders carry no timeline, and neither does
// the fromEntity path.
@override@JsonKey(name: 'status_history') List<OrderStatusChangeModel> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}

@override@JsonKey(name: 'delivery_otp') final  String deliveryOtp;
// Defaulted: empty on the payment-less path, and absent from the mock
// orders and from orders serialized before the field existed.
@override@JsonKey(name: 'payment_id') final  String paymentId;
// Defaulted: orders placed without a coupon (and those predating the
// feature) omit both.
@override@JsonKey(name: 'coupon_code') final  String couponCode;
@override@JsonKey(name: 'coupon_discount') final  double couponDiscount;
// The shopper's rating of this delivery. Defaulted: 0 is every order
// that hasn't been rated, including every one placed before the feature
// existed, and reviewed_at is absent for exactly the same set.
@override@JsonKey() final  int rating;
@override@JsonKey(name: 'review_text') final  String reviewText;
@override@JsonKey(name: 'reviewed_at') final  String reviewedAt;
 final  List<OrderLineItemModel> _items;
@override List<OrderLineItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

// Reuses AddressModel — the server serializes the snapshot through the
// same shape the /users/addresses endpoints use. Nullable: legacy orders
// predate the field.
@override@JsonKey(name: 'delivery_address') final  AddressModel? deliveryAddress;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderModelCopyWith<_OrderModel> get copyWith => __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.refundStatus, refundStatus) || other.refundStatus == refundStatus)&&(identical(other.placedAt, placedAt) || other.placedAt == placedAt)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory)&&(identical(other.deliveryOtp, deliveryOtp) || other.deliveryOtp == deliveryOtp)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.couponCode, couponCode) || other.couponCode == couponCode)&&(identical(other.couponDiscount, couponDiscount) || other.couponDiscount == couponDiscount)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewText, reviewText) || other.reviewText == reviewText)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,refundStatus,placedAt,const DeepCollectionEquality().hash(_statusHistory),deliveryOtp,paymentId,couponCode,couponDiscount,rating,reviewText,reviewedAt,const DeepCollectionEquality().hash(_items),deliveryAddress);

@override
String toString() {
  return 'OrderModel(id: $id, status: $status, refundStatus: $refundStatus, placedAt: $placedAt, statusHistory: $statusHistory, deliveryOtp: $deliveryOtp, paymentId: $paymentId, couponCode: $couponCode, couponDiscount: $couponDiscount, rating: $rating, reviewText: $reviewText, reviewedAt: $reviewedAt, items: $items, deliveryAddress: $deliveryAddress)';
}


}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res> implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(_OrderModel value, $Res Function(_OrderModel) _then) = __$OrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String status,@JsonKey(name: 'refund_status') String refundStatus,@JsonKey(name: 'placed_at') String placedAt,@JsonKey(name: 'status_history') List<OrderStatusChangeModel> statusHistory,@JsonKey(name: 'delivery_otp') String deliveryOtp,@JsonKey(name: 'payment_id') String paymentId,@JsonKey(name: 'coupon_code') String couponCode,@JsonKey(name: 'coupon_discount') double couponDiscount, int rating,@JsonKey(name: 'review_text') String reviewText,@JsonKey(name: 'reviewed_at') String reviewedAt, List<OrderLineItemModel> items,@JsonKey(name: 'delivery_address') AddressModel? deliveryAddress
});


@override $AddressModelCopyWith<$Res>? get deliveryAddress;

}
/// @nodoc
class __$OrderModelCopyWithImpl<$Res>
    implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? refundStatus = null,Object? placedAt = null,Object? statusHistory = null,Object? deliveryOtp = null,Object? paymentId = null,Object? couponCode = null,Object? couponDiscount = null,Object? rating = null,Object? reviewText = null,Object? reviewedAt = null,Object? items = null,Object? deliveryAddress = freezed,}) {
  return _then(_OrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,refundStatus: null == refundStatus ? _self.refundStatus : refundStatus // ignore: cast_nullable_to_non_nullable
as String,placedAt: null == placedAt ? _self.placedAt : placedAt // ignore: cast_nullable_to_non_nullable
as String,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<OrderStatusChangeModel>,deliveryOtp: null == deliveryOtp ? _self.deliveryOtp : deliveryOtp // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,couponCode: null == couponCode ? _self.couponCode : couponCode // ignore: cast_nullable_to_non_nullable
as String,couponDiscount: null == couponDiscount ? _self.couponDiscount : couponDiscount // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,reviewText: null == reviewText ? _self.reviewText : reviewText // ignore: cast_nullable_to_non_nullable
as String,reviewedAt: null == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineItemModel>,deliveryAddress: freezed == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as AddressModel?,
  ));
}

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressModelCopyWith<$Res>? get deliveryAddress {
    if (_self.deliveryAddress == null) {
    return null;
  }

  return $AddressModelCopyWith<$Res>(_self.deliveryAddress!, (value) {
    return _then(_self.copyWith(deliveryAddress: value));
  });
}
}

// dart format on
