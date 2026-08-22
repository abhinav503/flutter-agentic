// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_reviews_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductReviewsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductReviewsEvent()';
}


}

/// @nodoc
class $ProductReviewsEventCopyWith<$Res>  {
$ProductReviewsEventCopyWith(ProductReviewsEvent _, $Res Function(ProductReviewsEvent) __);
}


/// Adds pattern-matching-related methods to [ProductReviewsEvent].
extension ProductReviewsEventPatterns on ProductReviewsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductReviewsSeeded value)?  seeded,TResult Function( ProductReviewsRefreshed value)?  refreshed,TResult Function( ProductReviewsSubmitted value)?  submitted,TResult Function( ProductReviewsMineDeleted value)?  mineDeleted,TResult Function( ProductReviewsReported value)?  reported,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductReviewsSeeded() when seeded != null:
return seeded(_that);case ProductReviewsRefreshed() when refreshed != null:
return refreshed(_that);case ProductReviewsSubmitted() when submitted != null:
return submitted(_that);case ProductReviewsMineDeleted() when mineDeleted != null:
return mineDeleted(_that);case ProductReviewsReported() when reported != null:
return reported(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductReviewsSeeded value)  seeded,required TResult Function( ProductReviewsRefreshed value)  refreshed,required TResult Function( ProductReviewsSubmitted value)  submitted,required TResult Function( ProductReviewsMineDeleted value)  mineDeleted,required TResult Function( ProductReviewsReported value)  reported,}){
final _that = this;
switch (_that) {
case ProductReviewsSeeded():
return seeded(_that);case ProductReviewsRefreshed():
return refreshed(_that);case ProductReviewsSubmitted():
return submitted(_that);case ProductReviewsMineDeleted():
return mineDeleted(_that);case ProductReviewsReported():
return reported(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductReviewsSeeded value)?  seeded,TResult? Function( ProductReviewsRefreshed value)?  refreshed,TResult? Function( ProductReviewsSubmitted value)?  submitted,TResult? Function( ProductReviewsMineDeleted value)?  mineDeleted,TResult? Function( ProductReviewsReported value)?  reported,}){
final _that = this;
switch (_that) {
case ProductReviewsSeeded() when seeded != null:
return seeded(_that);case ProductReviewsRefreshed() when refreshed != null:
return refreshed(_that);case ProductReviewsSubmitted() when submitted != null:
return submitted(_that);case ProductReviewsMineDeleted() when mineDeleted != null:
return mineDeleted(_that);case ProductReviewsReported() when reported != null:
return reported(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ProductReviewsEntity reviews)?  seeded,TResult Function()?  refreshed,TResult Function( int rating,  String text)?  submitted,TResult Function()?  mineDeleted,TResult Function( String reviewUid,  ReviewReportReason reason,  bool block)?  reported,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductReviewsSeeded() when seeded != null:
return seeded(_that.reviews);case ProductReviewsRefreshed() when refreshed != null:
return refreshed();case ProductReviewsSubmitted() when submitted != null:
return submitted(_that.rating,_that.text);case ProductReviewsMineDeleted() when mineDeleted != null:
return mineDeleted();case ProductReviewsReported() when reported != null:
return reported(_that.reviewUid,_that.reason,_that.block);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ProductReviewsEntity reviews)  seeded,required TResult Function()  refreshed,required TResult Function( int rating,  String text)  submitted,required TResult Function()  mineDeleted,required TResult Function( String reviewUid,  ReviewReportReason reason,  bool block)  reported,}) {final _that = this;
switch (_that) {
case ProductReviewsSeeded():
return seeded(_that.reviews);case ProductReviewsRefreshed():
return refreshed();case ProductReviewsSubmitted():
return submitted(_that.rating,_that.text);case ProductReviewsMineDeleted():
return mineDeleted();case ProductReviewsReported():
return reported(_that.reviewUid,_that.reason,_that.block);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ProductReviewsEntity reviews)?  seeded,TResult? Function()?  refreshed,TResult? Function( int rating,  String text)?  submitted,TResult? Function()?  mineDeleted,TResult? Function( String reviewUid,  ReviewReportReason reason,  bool block)?  reported,}) {final _that = this;
switch (_that) {
case ProductReviewsSeeded() when seeded != null:
return seeded(_that.reviews);case ProductReviewsRefreshed() when refreshed != null:
return refreshed();case ProductReviewsSubmitted() when submitted != null:
return submitted(_that.rating,_that.text);case ProductReviewsMineDeleted() when mineDeleted != null:
return mineDeleted();case ProductReviewsReported() when reported != null:
return reported(_that.reviewUid,_that.reason,_that.block);case _:
  return null;

}
}

}

/// @nodoc


class ProductReviewsSeeded implements ProductReviewsEvent {
  const ProductReviewsSeeded({required this.reviews});
  

 final  ProductReviewsEntity reviews;

/// Create a copy of ProductReviewsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsSeededCopyWith<ProductReviewsSeeded> get copyWith => _$ProductReviewsSeededCopyWithImpl<ProductReviewsSeeded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsSeeded&&(identical(other.reviews, reviews) || other.reviews == reviews));
}


@override
int get hashCode => Object.hash(runtimeType,reviews);

@override
String toString() {
  return 'ProductReviewsEvent.seeded(reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsSeededCopyWith<$Res> implements $ProductReviewsEventCopyWith<$Res> {
  factory $ProductReviewsSeededCopyWith(ProductReviewsSeeded value, $Res Function(ProductReviewsSeeded) _then) = _$ProductReviewsSeededCopyWithImpl;
@useResult
$Res call({
 ProductReviewsEntity reviews
});




}
/// @nodoc
class _$ProductReviewsSeededCopyWithImpl<$Res>
    implements $ProductReviewsSeededCopyWith<$Res> {
  _$ProductReviewsSeededCopyWithImpl(this._self, this._then);

  final ProductReviewsSeeded _self;
  final $Res Function(ProductReviewsSeeded) _then;

/// Create a copy of ProductReviewsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reviews = null,}) {
  return _then(ProductReviewsSeeded(
reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ProductReviewsEntity,
  ));
}


}

/// @nodoc


class ProductReviewsRefreshed implements ProductReviewsEvent {
  const ProductReviewsRefreshed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsRefreshed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductReviewsEvent.refreshed()';
}


}




/// @nodoc


class ProductReviewsSubmitted implements ProductReviewsEvent {
  const ProductReviewsSubmitted({required this.rating, required this.text});
  

 final  int rating;
 final  String text;

/// Create a copy of ProductReviewsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsSubmittedCopyWith<ProductReviewsSubmitted> get copyWith => _$ProductReviewsSubmittedCopyWithImpl<ProductReviewsSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsSubmitted&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.text, text) || other.text == text));
}


@override
int get hashCode => Object.hash(runtimeType,rating,text);

@override
String toString() {
  return 'ProductReviewsEvent.submitted(rating: $rating, text: $text)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsSubmittedCopyWith<$Res> implements $ProductReviewsEventCopyWith<$Res> {
  factory $ProductReviewsSubmittedCopyWith(ProductReviewsSubmitted value, $Res Function(ProductReviewsSubmitted) _then) = _$ProductReviewsSubmittedCopyWithImpl;
@useResult
$Res call({
 int rating, String text
});




}
/// @nodoc
class _$ProductReviewsSubmittedCopyWithImpl<$Res>
    implements $ProductReviewsSubmittedCopyWith<$Res> {
  _$ProductReviewsSubmittedCopyWithImpl(this._self, this._then);

  final ProductReviewsSubmitted _self;
  final $Res Function(ProductReviewsSubmitted) _then;

/// Create a copy of ProductReviewsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rating = null,Object? text = null,}) {
  return _then(ProductReviewsSubmitted(
rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProductReviewsMineDeleted implements ProductReviewsEvent {
  const ProductReviewsMineDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsMineDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductReviewsEvent.mineDeleted()';
}


}




/// @nodoc


class ProductReviewsReported implements ProductReviewsEvent {
  const ProductReviewsReported({required this.reviewUid, required this.reason, required this.block});
  

 final  String reviewUid;
 final  ReviewReportReason reason;
 final  bool block;

/// Create a copy of ProductReviewsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsReportedCopyWith<ProductReviewsReported> get copyWith => _$ProductReviewsReportedCopyWithImpl<ProductReviewsReported>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsReported&&(identical(other.reviewUid, reviewUid) || other.reviewUid == reviewUid)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.block, block) || other.block == block));
}


@override
int get hashCode => Object.hash(runtimeType,reviewUid,reason,block);

@override
String toString() {
  return 'ProductReviewsEvent.reported(reviewUid: $reviewUid, reason: $reason, block: $block)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsReportedCopyWith<$Res> implements $ProductReviewsEventCopyWith<$Res> {
  factory $ProductReviewsReportedCopyWith(ProductReviewsReported value, $Res Function(ProductReviewsReported) _then) = _$ProductReviewsReportedCopyWithImpl;
@useResult
$Res call({
 String reviewUid, ReviewReportReason reason, bool block
});




}
/// @nodoc
class _$ProductReviewsReportedCopyWithImpl<$Res>
    implements $ProductReviewsReportedCopyWith<$Res> {
  _$ProductReviewsReportedCopyWithImpl(this._self, this._then);

  final ProductReviewsReported _self;
  final $Res Function(ProductReviewsReported) _then;

/// Create a copy of ProductReviewsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reviewUid = null,Object? reason = null,Object? block = null,}) {
  return _then(ProductReviewsReported(
reviewUid: null == reviewUid ? _self.reviewUid : reviewUid // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReviewReportReason,block: null == block ? _self.block : block // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ProductReviewsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductReviewsState()';
}


}

/// @nodoc
class $ProductReviewsStateCopyWith<$Res>  {
$ProductReviewsStateCopyWith(ProductReviewsState _, $Res Function(ProductReviewsState) __);
}


/// Adds pattern-matching-related methods to [ProductReviewsState].
extension ProductReviewsStatePatterns on ProductReviewsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductReviewsLoading value)?  loading,TResult Function( ProductReviewsLoaded value)?  loaded,TResult Function( ProductReviewsSubmitting value)?  submitting,TResult Function( ProductReviewsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductReviewsLoading() when loading != null:
return loading(_that);case ProductReviewsLoaded() when loaded != null:
return loaded(_that);case ProductReviewsSubmitting() when submitting != null:
return submitting(_that);case ProductReviewsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductReviewsLoading value)  loading,required TResult Function( ProductReviewsLoaded value)  loaded,required TResult Function( ProductReviewsSubmitting value)  submitting,required TResult Function( ProductReviewsError value)  error,}){
final _that = this;
switch (_that) {
case ProductReviewsLoading():
return loading(_that);case ProductReviewsLoaded():
return loaded(_that);case ProductReviewsSubmitting():
return submitting(_that);case ProductReviewsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductReviewsLoading value)?  loading,TResult? Function( ProductReviewsLoaded value)?  loaded,TResult? Function( ProductReviewsSubmitting value)?  submitting,TResult? Function( ProductReviewsError value)?  error,}){
final _that = this;
switch (_that) {
case ProductReviewsLoading() when loading != null:
return loading(_that);case ProductReviewsLoaded() when loaded != null:
return loaded(_that);case ProductReviewsSubmitting() when submitting != null:
return submitting(_that);case ProductReviewsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( ProductReviewsEntity reviews,  bool afterWrite,  bool afterReport)?  loaded,TResult Function( ProductReviewsEntity? reviews)?  submitting,TResult Function( String message,  ProductReviewsEntity? reviews,  bool shownInSheet)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductReviewsLoading() when loading != null:
return loading();case ProductReviewsLoaded() when loaded != null:
return loaded(_that.reviews,_that.afterWrite,_that.afterReport);case ProductReviewsSubmitting() when submitting != null:
return submitting(_that.reviews);case ProductReviewsError() when error != null:
return error(_that.message,_that.reviews,_that.shownInSheet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( ProductReviewsEntity reviews,  bool afterWrite,  bool afterReport)  loaded,required TResult Function( ProductReviewsEntity? reviews)  submitting,required TResult Function( String message,  ProductReviewsEntity? reviews,  bool shownInSheet)  error,}) {final _that = this;
switch (_that) {
case ProductReviewsLoading():
return loading();case ProductReviewsLoaded():
return loaded(_that.reviews,_that.afterWrite,_that.afterReport);case ProductReviewsSubmitting():
return submitting(_that.reviews);case ProductReviewsError():
return error(_that.message,_that.reviews,_that.shownInSheet);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( ProductReviewsEntity reviews,  bool afterWrite,  bool afterReport)?  loaded,TResult? Function( ProductReviewsEntity? reviews)?  submitting,TResult? Function( String message,  ProductReviewsEntity? reviews,  bool shownInSheet)?  error,}) {final _that = this;
switch (_that) {
case ProductReviewsLoading() when loading != null:
return loading();case ProductReviewsLoaded() when loaded != null:
return loaded(_that.reviews,_that.afterWrite,_that.afterReport);case ProductReviewsSubmitting() when submitting != null:
return submitting(_that.reviews);case ProductReviewsError() when error != null:
return error(_that.message,_that.reviews,_that.shownInSheet);case _:
  return null;

}
}

}

/// @nodoc


class ProductReviewsLoading implements ProductReviewsState {
  const ProductReviewsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductReviewsState.loading()';
}


}




/// @nodoc


class ProductReviewsLoaded implements ProductReviewsState {
  const ProductReviewsLoaded({required this.reviews, this.afterWrite = false, this.afterReport = false});
  

 final  ProductReviewsEntity reviews;
@JsonKey() final  bool afterWrite;
@JsonKey() final  bool afterReport;

/// Create a copy of ProductReviewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsLoadedCopyWith<ProductReviewsLoaded> get copyWith => _$ProductReviewsLoadedCopyWithImpl<ProductReviewsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsLoaded&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.afterWrite, afterWrite) || other.afterWrite == afterWrite)&&(identical(other.afterReport, afterReport) || other.afterReport == afterReport));
}


@override
int get hashCode => Object.hash(runtimeType,reviews,afterWrite,afterReport);

@override
String toString() {
  return 'ProductReviewsState.loaded(reviews: $reviews, afterWrite: $afterWrite, afterReport: $afterReport)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsLoadedCopyWith<$Res> implements $ProductReviewsStateCopyWith<$Res> {
  factory $ProductReviewsLoadedCopyWith(ProductReviewsLoaded value, $Res Function(ProductReviewsLoaded) _then) = _$ProductReviewsLoadedCopyWithImpl;
@useResult
$Res call({
 ProductReviewsEntity reviews, bool afterWrite, bool afterReport
});




}
/// @nodoc
class _$ProductReviewsLoadedCopyWithImpl<$Res>
    implements $ProductReviewsLoadedCopyWith<$Res> {
  _$ProductReviewsLoadedCopyWithImpl(this._self, this._then);

  final ProductReviewsLoaded _self;
  final $Res Function(ProductReviewsLoaded) _then;

/// Create a copy of ProductReviewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reviews = null,Object? afterWrite = null,Object? afterReport = null,}) {
  return _then(ProductReviewsLoaded(
reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ProductReviewsEntity,afterWrite: null == afterWrite ? _self.afterWrite : afterWrite // ignore: cast_nullable_to_non_nullable
as bool,afterReport: null == afterReport ? _self.afterReport : afterReport // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ProductReviewsSubmitting implements ProductReviewsState {
  const ProductReviewsSubmitting({this.reviews});
  

 final  ProductReviewsEntity? reviews;

/// Create a copy of ProductReviewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsSubmittingCopyWith<ProductReviewsSubmitting> get copyWith => _$ProductReviewsSubmittingCopyWithImpl<ProductReviewsSubmitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsSubmitting&&(identical(other.reviews, reviews) || other.reviews == reviews));
}


@override
int get hashCode => Object.hash(runtimeType,reviews);

@override
String toString() {
  return 'ProductReviewsState.submitting(reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsSubmittingCopyWith<$Res> implements $ProductReviewsStateCopyWith<$Res> {
  factory $ProductReviewsSubmittingCopyWith(ProductReviewsSubmitting value, $Res Function(ProductReviewsSubmitting) _then) = _$ProductReviewsSubmittingCopyWithImpl;
@useResult
$Res call({
 ProductReviewsEntity? reviews
});




}
/// @nodoc
class _$ProductReviewsSubmittingCopyWithImpl<$Res>
    implements $ProductReviewsSubmittingCopyWith<$Res> {
  _$ProductReviewsSubmittingCopyWithImpl(this._self, this._then);

  final ProductReviewsSubmitting _self;
  final $Res Function(ProductReviewsSubmitting) _then;

/// Create a copy of ProductReviewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reviews = freezed,}) {
  return _then(ProductReviewsSubmitting(
reviews: freezed == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ProductReviewsEntity?,
  ));
}


}

/// @nodoc


class ProductReviewsError implements ProductReviewsState {
  const ProductReviewsError({required this.message, this.reviews, this.shownInSheet = false});
  

 final  String message;
 final  ProductReviewsEntity? reviews;
@JsonKey() final  bool shownInSheet;

/// Create a copy of ProductReviewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewsErrorCopyWith<ProductReviewsError> get copyWith => _$ProductReviewsErrorCopyWithImpl<ProductReviewsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReviewsError&&(identical(other.message, message) || other.message == message)&&(identical(other.reviews, reviews) || other.reviews == reviews)&&(identical(other.shownInSheet, shownInSheet) || other.shownInSheet == shownInSheet));
}


@override
int get hashCode => Object.hash(runtimeType,message,reviews,shownInSheet);

@override
String toString() {
  return 'ProductReviewsState.error(message: $message, reviews: $reviews, shownInSheet: $shownInSheet)';
}


}

/// @nodoc
abstract mixin class $ProductReviewsErrorCopyWith<$Res> implements $ProductReviewsStateCopyWith<$Res> {
  factory $ProductReviewsErrorCopyWith(ProductReviewsError value, $Res Function(ProductReviewsError) _then) = _$ProductReviewsErrorCopyWithImpl;
@useResult
$Res call({
 String message, ProductReviewsEntity? reviews, bool shownInSheet
});




}
/// @nodoc
class _$ProductReviewsErrorCopyWithImpl<$Res>
    implements $ProductReviewsErrorCopyWith<$Res> {
  _$ProductReviewsErrorCopyWithImpl(this._self, this._then);

  final ProductReviewsError _self;
  final $Res Function(ProductReviewsError) _then;

/// Create a copy of ProductReviewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? reviews = freezed,Object? shownInSheet = null,}) {
  return _then(ProductReviewsError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,reviews: freezed == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as ProductReviewsEntity?,shownInSheet: null == shownInSheet ? _self.shownInSheet : shownInSheet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
