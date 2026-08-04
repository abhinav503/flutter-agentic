// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewModel {

 String get uid;@JsonKey(name: 'product_id') String get productId; int get rating; String get text;@JsonKey(name: 'user_name') String get userName;@JsonKey(name: 'user_avatar_url') String get userAvatarUrl;@JsonKey(name: 'verified_purchase') bool get verifiedPurchase;// ISO-8601 wire strings, parsed to DateTime only in toEntity() — the
// data layer parses wire values, per the layer convention.
@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;
/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewModelCopyWith<ReviewModel> get copyWith => _$ReviewModelCopyWithImpl<ReviewModel>(this as ReviewModel, _$identity);

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.verifiedPurchase, verifiedPurchase) || other.verifiedPurchase == verifiedPurchase)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,productId,rating,text,userName,userAvatarUrl,verifiedPurchase,createdAt,updatedAt);

@override
String toString() {
  return 'ReviewModel(uid: $uid, productId: $productId, rating: $rating, text: $text, userName: $userName, userAvatarUrl: $userAvatarUrl, verifiedPurchase: $verifiedPurchase, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewModelCopyWith<$Res>  {
  factory $ReviewModelCopyWith(ReviewModel value, $Res Function(ReviewModel) _then) = _$ReviewModelCopyWithImpl;
@useResult
$Res call({
 String uid,@JsonKey(name: 'product_id') String productId, int rating, String text,@JsonKey(name: 'user_name') String userName,@JsonKey(name: 'user_avatar_url') String userAvatarUrl,@JsonKey(name: 'verified_purchase') bool verifiedPurchase,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class _$ReviewModelCopyWithImpl<$Res>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._self, this._then);

  final ReviewModel _self;
  final $Res Function(ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? productId = null,Object? rating = null,Object? text = null,Object? userName = null,Object? userAvatarUrl = null,Object? verifiedPurchase = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: null == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,verifiedPurchase: null == verifiedPurchase ? _self.verifiedPurchase : verifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewModel].
extension ReviewModelPatterns on ReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _ReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid, @JsonKey(name: 'product_id')  String productId,  int rating,  String text, @JsonKey(name: 'user_name')  String userName, @JsonKey(name: 'user_avatar_url')  String userAvatarUrl, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
return $default(_that.uid,_that.productId,_that.rating,_that.text,_that.userName,_that.userAvatarUrl,_that.verifiedPurchase,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid, @JsonKey(name: 'product_id')  String productId,  int rating,  String text, @JsonKey(name: 'user_name')  String userName, @JsonKey(name: 'user_avatar_url')  String userAvatarUrl, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewModel():
return $default(_that.uid,_that.productId,_that.rating,_that.text,_that.userName,_that.userAvatarUrl,_that.verifiedPurchase,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid, @JsonKey(name: 'product_id')  String productId,  int rating,  String text, @JsonKey(name: 'user_name')  String userName, @JsonKey(name: 'user_avatar_url')  String userAvatarUrl, @JsonKey(name: 'verified_purchase')  bool verifiedPurchase, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
return $default(_that.uid,_that.productId,_that.rating,_that.text,_that.userName,_that.userAvatarUrl,_that.verifiedPurchase,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewModel extends ReviewModel {
  const _ReviewModel({required this.uid, @JsonKey(name: 'product_id') required this.productId, required this.rating, required this.text, @JsonKey(name: 'user_name') required this.userName, @JsonKey(name: 'user_avatar_url') this.userAvatarUrl = '', @JsonKey(name: 'verified_purchase') this.verifiedPurchase = false, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): super._();
  factory _ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

@override final  String uid;
@override@JsonKey(name: 'product_id') final  String productId;
@override final  int rating;
@override final  String text;
@override@JsonKey(name: 'user_name') final  String userName;
@override@JsonKey(name: 'user_avatar_url') final  String userAvatarUrl;
@override@JsonKey(name: 'verified_purchase') final  bool verifiedPurchase;
// ISO-8601 wire strings, parsed to DateTime only in toEntity() — the
// data layer parses wire values, per the layer convention.
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewModelCopyWith<_ReviewModel> get copyWith => __$ReviewModelCopyWithImpl<_ReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.verifiedPurchase, verifiedPurchase) || other.verifiedPurchase == verifiedPurchase)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,productId,rating,text,userName,userAvatarUrl,verifiedPurchase,createdAt,updatedAt);

@override
String toString() {
  return 'ReviewModel(uid: $uid, productId: $productId, rating: $rating, text: $text, userName: $userName, userAvatarUrl: $userAvatarUrl, verifiedPurchase: $verifiedPurchase, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewModelCopyWith<$Res> implements $ReviewModelCopyWith<$Res> {
  factory _$ReviewModelCopyWith(_ReviewModel value, $Res Function(_ReviewModel) _then) = __$ReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String uid,@JsonKey(name: 'product_id') String productId, int rating, String text,@JsonKey(name: 'user_name') String userName,@JsonKey(name: 'user_avatar_url') String userAvatarUrl,@JsonKey(name: 'verified_purchase') bool verifiedPurchase,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt
});




}
/// @nodoc
class __$ReviewModelCopyWithImpl<$Res>
    implements _$ReviewModelCopyWith<$Res> {
  __$ReviewModelCopyWithImpl(this._self, this._then);

  final _ReviewModel _self;
  final $Res Function(_ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? productId = null,Object? rating = null,Object? text = null,Object? userName = null,Object? userAvatarUrl = null,Object? verifiedPurchase = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReviewModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: null == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,verifiedPurchase: null == verifiedPurchase ? _self.verifiedPurchase : verifiedPurchase // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
