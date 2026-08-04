// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_reviews_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductReviewsModel {

 ProductRatingModel get rating; List<ReviewModel> get reviews;
/// Create a copy of ProductReviewsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsModelCopyWith<ProductReviewsModel> get copyWith => _$ProductReviewsModelCopyWithImpl<ProductReviewsModel>(this as ProductReviewsModel, _$identity);

  /// Serializes this ProductReviewsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsModel&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.reviews, reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,const DeepCollectionEquality().hash(reviews));

@override
String toString() {
  return 'ProductReviewsModel(rating: $rating, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsModelCopyWith<$Res>  {
  factory $ProductReviewsModelCopyWith(ProductReviewsModel value, $Res Function(ProductReviewsModel) _then) = _$ProductReviewsModelCopyWithImpl;
@useResult
$Res call({
 ProductRatingModel rating, List<ReviewModel> reviews
});


$ProductRatingModelCopyWith<$Res> get rating;

}
/// @nodoc
class _$ProductReviewsModelCopyWithImpl<$Res>
    implements $ProductReviewsModelCopyWith<$Res> {
  _$ProductReviewsModelCopyWithImpl(this._self, this._then);

  final ProductReviewsModel _self;
  final $Res Function(ProductReviewsModel) _then;

/// Create a copy of ProductReviewsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rating = null,Object? reviews = null,}) {
  return _then(_self.copyWith(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as ProductRatingModel,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ReviewModel>,
  ));
}
/// Create a copy of ProductReviewsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductRatingModelCopyWith<$Res> get rating {
  
  return $ProductRatingModelCopyWith<$Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductReviewsModel].
extension ProductReviewsModelPatterns on ProductReviewsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductReviewsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductReviewsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductReviewsModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductReviewsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductReviewsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductReviewsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProductRatingModel rating,  List<ReviewModel> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductReviewsModel() when $default != null:
return $default(_that.rating,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProductRatingModel rating,  List<ReviewModel> reviews)  $default,) {final _that = this;
switch (_that) {
case _ProductReviewsModel():
return $default(_that.rating,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProductRatingModel rating,  List<ReviewModel> reviews)?  $default,) {final _that = this;
switch (_that) {
case _ProductReviewsModel() when $default != null:
return $default(_that.rating,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductReviewsModel extends ProductReviewsModel {
  const _ProductReviewsModel({this.rating = const ProductRatingModel(), final  List<ReviewModel> reviews = const <ReviewModel>[]}): _reviews = reviews,super._();
  factory _ProductReviewsModel.fromJson(Map<String, dynamic> json) => _$ProductReviewsModelFromJson(json);

@override@JsonKey() final  ProductRatingModel rating;
 final  List<ReviewModel> _reviews;
@override@JsonKey() List<ReviewModel> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of ProductReviewsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductReviewsModelCopyWith<_ProductReviewsModel> get copyWith => __$ProductReviewsModelCopyWithImpl<_ProductReviewsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductReviewsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductReviewsModel&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other._reviews, _reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rating,const DeepCollectionEquality().hash(_reviews));

@override
String toString() {
  return 'ProductReviewsModel(rating: $rating, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$ProductReviewsModelCopyWith<$Res> implements $ProductReviewsModelCopyWith<$Res> {
  factory _$ProductReviewsModelCopyWith(_ProductReviewsModel value, $Res Function(_ProductReviewsModel) _then) = __$ProductReviewsModelCopyWithImpl;
@override @useResult
$Res call({
 ProductRatingModel rating, List<ReviewModel> reviews
});


@override $ProductRatingModelCopyWith<$Res> get rating;

}
/// @nodoc
class __$ProductReviewsModelCopyWithImpl<$Res>
    implements _$ProductReviewsModelCopyWith<$Res> {
  __$ProductReviewsModelCopyWithImpl(this._self, this._then);

  final _ProductReviewsModel _self;
  final $Res Function(_ProductReviewsModel) _then;

/// Create a copy of ProductReviewsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? reviews = null,}) {
  return _then(_ProductReviewsModel(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as ProductRatingModel,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<ReviewModel>,
  ));
}

/// Create a copy of ProductReviewsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductRatingModelCopyWith<$Res> get rating {
  
  return $ProductRatingModelCopyWith<$Res>(_self.rating, (value) {
    return _then(_self.copyWith(rating: value));
  });
}
}

// dart format on
