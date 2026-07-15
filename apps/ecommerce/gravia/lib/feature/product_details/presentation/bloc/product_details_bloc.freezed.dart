// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailsEvent()';
}


}

/// @nodoc
class $ProductDetailsEventCopyWith<$Res>  {
$ProductDetailsEventCopyWith(ProductDetailsEvent _, $Res Function(ProductDetailsEvent) __);
}


/// Adds pattern-matching-related methods to [ProductDetailsEvent].
extension ProductDetailsEventPatterns on ProductDetailsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductDetailsStarted value)?  started,TResult Function( ProductDetailsFavouriteToggled value)?  favouriteToggled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductDetailsStarted() when started != null:
return started(_that);case ProductDetailsFavouriteToggled() when favouriteToggled != null:
return favouriteToggled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductDetailsStarted value)  started,required TResult Function( ProductDetailsFavouriteToggled value)  favouriteToggled,}){
final _that = this;
switch (_that) {
case ProductDetailsStarted():
return started(_that);case ProductDetailsFavouriteToggled():
return favouriteToggled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductDetailsStarted value)?  started,TResult? Function( ProductDetailsFavouriteToggled value)?  favouriteToggled,}){
final _that = this;
switch (_that) {
case ProductDetailsStarted() when started != null:
return started(_that);case ProductDetailsFavouriteToggled() when favouriteToggled != null:
return favouriteToggled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String productId)?  started,TResult Function()?  favouriteToggled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductDetailsStarted() when started != null:
return started(_that.productId);case ProductDetailsFavouriteToggled() when favouriteToggled != null:
return favouriteToggled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String productId)  started,required TResult Function()  favouriteToggled,}) {final _that = this;
switch (_that) {
case ProductDetailsStarted():
return started(_that.productId);case ProductDetailsFavouriteToggled():
return favouriteToggled();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String productId)?  started,TResult? Function()?  favouriteToggled,}) {final _that = this;
switch (_that) {
case ProductDetailsStarted() when started != null:
return started(_that.productId);case ProductDetailsFavouriteToggled() when favouriteToggled != null:
return favouriteToggled();case _:
  return null;

}
}

}

/// @nodoc


class ProductDetailsStarted implements ProductDetailsEvent {
  const ProductDetailsStarted({required this.productId});
  

 final  String productId;

/// Create a copy of ProductDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailsStartedCopyWith<ProductDetailsStarted> get copyWith => _$ProductDetailsStartedCopyWithImpl<ProductDetailsStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsStarted&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'ProductDetailsEvent.started(productId: $productId)';
}


}

/// @nodoc
abstract mixin class $ProductDetailsStartedCopyWith<$Res> implements $ProductDetailsEventCopyWith<$Res> {
  factory $ProductDetailsStartedCopyWith(ProductDetailsStarted value, $Res Function(ProductDetailsStarted) _then) = _$ProductDetailsStartedCopyWithImpl;
@useResult
$Res call({
 String productId
});




}
/// @nodoc
class _$ProductDetailsStartedCopyWithImpl<$Res>
    implements $ProductDetailsStartedCopyWith<$Res> {
  _$ProductDetailsStartedCopyWithImpl(this._self, this._then);

  final ProductDetailsStarted _self;
  final $Res Function(ProductDetailsStarted) _then;

/// Create a copy of ProductDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(ProductDetailsStarted(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProductDetailsFavouriteToggled implements ProductDetailsEvent {
  const ProductDetailsFavouriteToggled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsFavouriteToggled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailsEvent.favouriteToggled()';
}


}




/// @nodoc
mixin _$ProductDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailsState()';
}


}

/// @nodoc
class $ProductDetailsStateCopyWith<$Res>  {
$ProductDetailsStateCopyWith(ProductDetailsState _, $Res Function(ProductDetailsState) __);
}


/// Adds pattern-matching-related methods to [ProductDetailsState].
extension ProductDetailsStatePatterns on ProductDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductDetailsLoading value)?  loading,TResult Function( ProductDetailsLoaded value)?  loaded,TResult Function( ProductDetailsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductDetailsLoading() when loading != null:
return loading(_that);case ProductDetailsLoaded() when loaded != null:
return loaded(_that);case ProductDetailsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductDetailsLoading value)  loading,required TResult Function( ProductDetailsLoaded value)  loaded,required TResult Function( ProductDetailsError value)  error,}){
final _that = this;
switch (_that) {
case ProductDetailsLoading():
return loading(_that);case ProductDetailsLoaded():
return loaded(_that);case ProductDetailsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductDetailsLoading value)?  loading,TResult? Function( ProductDetailsLoaded value)?  loaded,TResult? Function( ProductDetailsError value)?  error,}){
final _that = this;
switch (_that) {
case ProductDetailsLoading() when loading != null:
return loading(_that);case ProductDetailsLoaded() when loaded != null:
return loaded(_that);case ProductDetailsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( ProductDetailEntity detail)?  loaded,TResult Function( String message,  String productId)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductDetailsLoading() when loading != null:
return loading();case ProductDetailsLoaded() when loaded != null:
return loaded(_that.detail);case ProductDetailsError() when error != null:
return error(_that.message,_that.productId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( ProductDetailEntity detail)  loaded,required TResult Function( String message,  String productId)  error,}) {final _that = this;
switch (_that) {
case ProductDetailsLoading():
return loading();case ProductDetailsLoaded():
return loaded(_that.detail);case ProductDetailsError():
return error(_that.message,_that.productId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( ProductDetailEntity detail)?  loaded,TResult? Function( String message,  String productId)?  error,}) {final _that = this;
switch (_that) {
case ProductDetailsLoading() when loading != null:
return loading();case ProductDetailsLoaded() when loaded != null:
return loaded(_that.detail);case ProductDetailsError() when error != null:
return error(_that.message,_that.productId);case _:
  return null;

}
}

}

/// @nodoc


class ProductDetailsLoading implements ProductDetailsState {
  const ProductDetailsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailsState.loading()';
}


}




/// @nodoc


class ProductDetailsLoaded implements ProductDetailsState {
  const ProductDetailsLoaded({required this.detail});
  

 final  ProductDetailEntity detail;

/// Create a copy of ProductDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailsLoadedCopyWith<ProductDetailsLoaded> get copyWith => _$ProductDetailsLoadedCopyWithImpl<ProductDetailsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsLoaded&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,detail);

@override
String toString() {
  return 'ProductDetailsState.loaded(detail: $detail)';
}


}

/// @nodoc
abstract mixin class $ProductDetailsLoadedCopyWith<$Res> implements $ProductDetailsStateCopyWith<$Res> {
  factory $ProductDetailsLoadedCopyWith(ProductDetailsLoaded value, $Res Function(ProductDetailsLoaded) _then) = _$ProductDetailsLoadedCopyWithImpl;
@useResult
$Res call({
 ProductDetailEntity detail
});




}
/// @nodoc
class _$ProductDetailsLoadedCopyWithImpl<$Res>
    implements $ProductDetailsLoadedCopyWith<$Res> {
  _$ProductDetailsLoadedCopyWithImpl(this._self, this._then);

  final ProductDetailsLoaded _self;
  final $Res Function(ProductDetailsLoaded) _then;

/// Create a copy of ProductDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? detail = null,}) {
  return _then(ProductDetailsLoaded(
detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as ProductDetailEntity,
  ));
}


}

/// @nodoc


class ProductDetailsError implements ProductDetailsState {
  const ProductDetailsError({required this.message, required this.productId});
  

 final  String message;
 final  String productId;

/// Create a copy of ProductDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailsErrorCopyWith<ProductDetailsError> get copyWith => _$ProductDetailsErrorCopyWithImpl<ProductDetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailsError&&(identical(other.message, message) || other.message == message)&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,message,productId);

@override
String toString() {
  return 'ProductDetailsState.error(message: $message, productId: $productId)';
}


}

/// @nodoc
abstract mixin class $ProductDetailsErrorCopyWith<$Res> implements $ProductDetailsStateCopyWith<$Res> {
  factory $ProductDetailsErrorCopyWith(ProductDetailsError value, $Res Function(ProductDetailsError) _then) = _$ProductDetailsErrorCopyWithImpl;
@useResult
$Res call({
 String message, String productId
});




}
/// @nodoc
class _$ProductDetailsErrorCopyWithImpl<$Res>
    implements $ProductDetailsErrorCopyWith<$Res> {
  _$ProductDetailsErrorCopyWithImpl(this._self, this._then);

  final ProductDetailsError _self;
  final $Res Function(ProductDetailsError) _then;

/// Create a copy of ProductDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? productId = null,}) {
  return _then(ProductDetailsError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
