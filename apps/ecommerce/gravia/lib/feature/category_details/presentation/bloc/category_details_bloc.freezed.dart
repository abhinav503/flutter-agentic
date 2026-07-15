// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryDetailsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryDetailsEvent()';
}


}

/// @nodoc
class $CategoryDetailsEventCopyWith<$Res>  {
$CategoryDetailsEventCopyWith(CategoryDetailsEvent _, $Res Function(CategoryDetailsEvent) __);
}


/// Adds pattern-matching-related methods to [CategoryDetailsEvent].
extension CategoryDetailsEventPatterns on CategoryDetailsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CategoryDetailsStarted value)?  started,TResult Function( CategoryDetailsSortChanged value)?  sortChanged,TResult Function( CategoryDetailsPriceFilterChanged value)?  priceFilterChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CategoryDetailsStarted() when started != null:
return started(_that);case CategoryDetailsSortChanged() when sortChanged != null:
return sortChanged(_that);case CategoryDetailsPriceFilterChanged() when priceFilterChanged != null:
return priceFilterChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CategoryDetailsStarted value)  started,required TResult Function( CategoryDetailsSortChanged value)  sortChanged,required TResult Function( CategoryDetailsPriceFilterChanged value)  priceFilterChanged,}){
final _that = this;
switch (_that) {
case CategoryDetailsStarted():
return started(_that);case CategoryDetailsSortChanged():
return sortChanged(_that);case CategoryDetailsPriceFilterChanged():
return priceFilterChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CategoryDetailsStarted value)?  started,TResult? Function( CategoryDetailsSortChanged value)?  sortChanged,TResult? Function( CategoryDetailsPriceFilterChanged value)?  priceFilterChanged,}){
final _that = this;
switch (_that) {
case CategoryDetailsStarted() when started != null:
return started(_that);case CategoryDetailsSortChanged() when sortChanged != null:
return sortChanged(_that);case CategoryDetailsPriceFilterChanged() when priceFilterChanged != null:
return priceFilterChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String categoryId,  String categoryName)?  started,TResult Function( ProductSortOption sort)?  sortChanged,TResult Function( ProductPriceFilter priceFilter)?  priceFilterChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CategoryDetailsStarted() when started != null:
return started(_that.categoryId,_that.categoryName);case CategoryDetailsSortChanged() when sortChanged != null:
return sortChanged(_that.sort);case CategoryDetailsPriceFilterChanged() when priceFilterChanged != null:
return priceFilterChanged(_that.priceFilter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String categoryId,  String categoryName)  started,required TResult Function( ProductSortOption sort)  sortChanged,required TResult Function( ProductPriceFilter priceFilter)  priceFilterChanged,}) {final _that = this;
switch (_that) {
case CategoryDetailsStarted():
return started(_that.categoryId,_that.categoryName);case CategoryDetailsSortChanged():
return sortChanged(_that.sort);case CategoryDetailsPriceFilterChanged():
return priceFilterChanged(_that.priceFilter);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String categoryId,  String categoryName)?  started,TResult? Function( ProductSortOption sort)?  sortChanged,TResult? Function( ProductPriceFilter priceFilter)?  priceFilterChanged,}) {final _that = this;
switch (_that) {
case CategoryDetailsStarted() when started != null:
return started(_that.categoryId,_that.categoryName);case CategoryDetailsSortChanged() when sortChanged != null:
return sortChanged(_that.sort);case CategoryDetailsPriceFilterChanged() when priceFilterChanged != null:
return priceFilterChanged(_that.priceFilter);case _:
  return null;

}
}

}

/// @nodoc


class CategoryDetailsStarted implements CategoryDetailsEvent {
  const CategoryDetailsStarted({required this.categoryId, required this.categoryName});
  

 final  String categoryId;
 final  String categoryName;

/// Create a copy of CategoryDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailsStartedCopyWith<CategoryDetailsStarted> get copyWith => _$CategoryDetailsStartedCopyWithImpl<CategoryDetailsStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsStarted&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName);

@override
String toString() {
  return 'CategoryDetailsEvent.started(categoryId: $categoryId, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $CategoryDetailsStartedCopyWith<$Res> implements $CategoryDetailsEventCopyWith<$Res> {
  factory $CategoryDetailsStartedCopyWith(CategoryDetailsStarted value, $Res Function(CategoryDetailsStarted) _then) = _$CategoryDetailsStartedCopyWithImpl;
@useResult
$Res call({
 String categoryId, String categoryName
});




}
/// @nodoc
class _$CategoryDetailsStartedCopyWithImpl<$Res>
    implements $CategoryDetailsStartedCopyWith<$Res> {
  _$CategoryDetailsStartedCopyWithImpl(this._self, this._then);

  final CategoryDetailsStarted _self;
  final $Res Function(CategoryDetailsStarted) _then;

/// Create a copy of CategoryDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,}) {
  return _then(CategoryDetailsStarted(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CategoryDetailsSortChanged implements CategoryDetailsEvent {
  const CategoryDetailsSortChanged({required this.sort});
  

 final  ProductSortOption sort;

/// Create a copy of CategoryDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailsSortChangedCopyWith<CategoryDetailsSortChanged> get copyWith => _$CategoryDetailsSortChangedCopyWithImpl<CategoryDetailsSortChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsSortChanged&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode => Object.hash(runtimeType,sort);

@override
String toString() {
  return 'CategoryDetailsEvent.sortChanged(sort: $sort)';
}


}

/// @nodoc
abstract mixin class $CategoryDetailsSortChangedCopyWith<$Res> implements $CategoryDetailsEventCopyWith<$Res> {
  factory $CategoryDetailsSortChangedCopyWith(CategoryDetailsSortChanged value, $Res Function(CategoryDetailsSortChanged) _then) = _$CategoryDetailsSortChangedCopyWithImpl;
@useResult
$Res call({
 ProductSortOption sort
});




}
/// @nodoc
class _$CategoryDetailsSortChangedCopyWithImpl<$Res>
    implements $CategoryDetailsSortChangedCopyWith<$Res> {
  _$CategoryDetailsSortChangedCopyWithImpl(this._self, this._then);

  final CategoryDetailsSortChanged _self;
  final $Res Function(CategoryDetailsSortChanged) _then;

/// Create a copy of CategoryDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sort = null,}) {
  return _then(CategoryDetailsSortChanged(
sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ProductSortOption,
  ));
}


}

/// @nodoc


class CategoryDetailsPriceFilterChanged implements CategoryDetailsEvent {
  const CategoryDetailsPriceFilterChanged({required this.priceFilter});
  

 final  ProductPriceFilter priceFilter;

/// Create a copy of CategoryDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailsPriceFilterChangedCopyWith<CategoryDetailsPriceFilterChanged> get copyWith => _$CategoryDetailsPriceFilterChangedCopyWithImpl<CategoryDetailsPriceFilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsPriceFilterChanged&&(identical(other.priceFilter, priceFilter) || other.priceFilter == priceFilter));
}


@override
int get hashCode => Object.hash(runtimeType,priceFilter);

@override
String toString() {
  return 'CategoryDetailsEvent.priceFilterChanged(priceFilter: $priceFilter)';
}


}

/// @nodoc
abstract mixin class $CategoryDetailsPriceFilterChangedCopyWith<$Res> implements $CategoryDetailsEventCopyWith<$Res> {
  factory $CategoryDetailsPriceFilterChangedCopyWith(CategoryDetailsPriceFilterChanged value, $Res Function(CategoryDetailsPriceFilterChanged) _then) = _$CategoryDetailsPriceFilterChangedCopyWithImpl;
@useResult
$Res call({
 ProductPriceFilter priceFilter
});




}
/// @nodoc
class _$CategoryDetailsPriceFilterChangedCopyWithImpl<$Res>
    implements $CategoryDetailsPriceFilterChangedCopyWith<$Res> {
  _$CategoryDetailsPriceFilterChangedCopyWithImpl(this._self, this._then);

  final CategoryDetailsPriceFilterChanged _self;
  final $Res Function(CategoryDetailsPriceFilterChanged) _then;

/// Create a copy of CategoryDetailsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? priceFilter = null,}) {
  return _then(CategoryDetailsPriceFilterChanged(
priceFilter: null == priceFilter ? _self.priceFilter : priceFilter // ignore: cast_nullable_to_non_nullable
as ProductPriceFilter,
  ));
}


}

/// @nodoc
mixin _$CategoryDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryDetailsState()';
}


}

/// @nodoc
class $CategoryDetailsStateCopyWith<$Res>  {
$CategoryDetailsStateCopyWith(CategoryDetailsState _, $Res Function(CategoryDetailsState) __);
}


/// Adds pattern-matching-related methods to [CategoryDetailsState].
extension CategoryDetailsStatePatterns on CategoryDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CategoryDetailsLoading value)?  loading,TResult Function( CategoryDetailsLoaded value)?  loaded,TResult Function( CategoryDetailsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CategoryDetailsLoading() when loading != null:
return loading(_that);case CategoryDetailsLoaded() when loaded != null:
return loaded(_that);case CategoryDetailsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CategoryDetailsLoading value)  loading,required TResult Function( CategoryDetailsLoaded value)  loaded,required TResult Function( CategoryDetailsError value)  error,}){
final _that = this;
switch (_that) {
case CategoryDetailsLoading():
return loading(_that);case CategoryDetailsLoaded():
return loaded(_that);case CategoryDetailsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CategoryDetailsLoading value)?  loading,TResult? Function( CategoryDetailsLoaded value)?  loaded,TResult? Function( CategoryDetailsError value)?  error,}){
final _that = this;
switch (_that) {
case CategoryDetailsLoading() when loading != null:
return loading(_that);case CategoryDetailsLoaded() when loaded != null:
return loaded(_that);case CategoryDetailsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String categoryName,  CategoryDetailsEntity details,  ProductSortOption sort,  ProductPriceFilter priceFilter)?  loaded,TResult Function( String message,  String categoryId,  String categoryName)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CategoryDetailsLoading() when loading != null:
return loading();case CategoryDetailsLoaded() when loaded != null:
return loaded(_that.categoryName,_that.details,_that.sort,_that.priceFilter);case CategoryDetailsError() when error != null:
return error(_that.message,_that.categoryId,_that.categoryName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String categoryName,  CategoryDetailsEntity details,  ProductSortOption sort,  ProductPriceFilter priceFilter)  loaded,required TResult Function( String message,  String categoryId,  String categoryName)  error,}) {final _that = this;
switch (_that) {
case CategoryDetailsLoading():
return loading();case CategoryDetailsLoaded():
return loaded(_that.categoryName,_that.details,_that.sort,_that.priceFilter);case CategoryDetailsError():
return error(_that.message,_that.categoryId,_that.categoryName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String categoryName,  CategoryDetailsEntity details,  ProductSortOption sort,  ProductPriceFilter priceFilter)?  loaded,TResult? Function( String message,  String categoryId,  String categoryName)?  error,}) {final _that = this;
switch (_that) {
case CategoryDetailsLoading() when loading != null:
return loading();case CategoryDetailsLoaded() when loaded != null:
return loaded(_that.categoryName,_that.details,_that.sort,_that.priceFilter);case CategoryDetailsError() when error != null:
return error(_that.message,_that.categoryId,_that.categoryName);case _:
  return null;

}
}

}

/// @nodoc


class CategoryDetailsLoading implements CategoryDetailsState {
  const CategoryDetailsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryDetailsState.loading()';
}


}




/// @nodoc


class CategoryDetailsLoaded implements CategoryDetailsState {
  const CategoryDetailsLoaded({required this.categoryName, required this.details, required this.sort, required this.priceFilter});
  

 final  String categoryName;
 final  CategoryDetailsEntity details;
 final  ProductSortOption sort;
 final  ProductPriceFilter priceFilter;

/// Create a copy of CategoryDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailsLoadedCopyWith<CategoryDetailsLoaded> get copyWith => _$CategoryDetailsLoadedCopyWithImpl<CategoryDetailsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsLoaded&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.details, details) || other.details == details)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.priceFilter, priceFilter) || other.priceFilter == priceFilter));
}


@override
int get hashCode => Object.hash(runtimeType,categoryName,details,sort,priceFilter);

@override
String toString() {
  return 'CategoryDetailsState.loaded(categoryName: $categoryName, details: $details, sort: $sort, priceFilter: $priceFilter)';
}


}

/// @nodoc
abstract mixin class $CategoryDetailsLoadedCopyWith<$Res> implements $CategoryDetailsStateCopyWith<$Res> {
  factory $CategoryDetailsLoadedCopyWith(CategoryDetailsLoaded value, $Res Function(CategoryDetailsLoaded) _then) = _$CategoryDetailsLoadedCopyWithImpl;
@useResult
$Res call({
 String categoryName, CategoryDetailsEntity details, ProductSortOption sort, ProductPriceFilter priceFilter
});




}
/// @nodoc
class _$CategoryDetailsLoadedCopyWithImpl<$Res>
    implements $CategoryDetailsLoadedCopyWith<$Res> {
  _$CategoryDetailsLoadedCopyWithImpl(this._self, this._then);

  final CategoryDetailsLoaded _self;
  final $Res Function(CategoryDetailsLoaded) _then;

/// Create a copy of CategoryDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? details = null,Object? sort = null,Object? priceFilter = null,}) {
  return _then(CategoryDetailsLoaded(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as CategoryDetailsEntity,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as ProductSortOption,priceFilter: null == priceFilter ? _self.priceFilter : priceFilter // ignore: cast_nullable_to_non_nullable
as ProductPriceFilter,
  ));
}


}

/// @nodoc


class CategoryDetailsError implements CategoryDetailsState {
  const CategoryDetailsError({required this.message, required this.categoryId, required this.categoryName});
  

 final  String message;
 final  String categoryId;
 final  String categoryName;

/// Create a copy of CategoryDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailsErrorCopyWith<CategoryDetailsError> get copyWith => _$CategoryDetailsErrorCopyWithImpl<CategoryDetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailsError&&(identical(other.message, message) || other.message == message)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName));
}


@override
int get hashCode => Object.hash(runtimeType,message,categoryId,categoryName);

@override
String toString() {
  return 'CategoryDetailsState.error(message: $message, categoryId: $categoryId, categoryName: $categoryName)';
}


}

/// @nodoc
abstract mixin class $CategoryDetailsErrorCopyWith<$Res> implements $CategoryDetailsStateCopyWith<$Res> {
  factory $CategoryDetailsErrorCopyWith(CategoryDetailsError value, $Res Function(CategoryDetailsError) _then) = _$CategoryDetailsErrorCopyWithImpl;
@useResult
$Res call({
 String message, String categoryId, String categoryName
});




}
/// @nodoc
class _$CategoryDetailsErrorCopyWithImpl<$Res>
    implements $CategoryDetailsErrorCopyWith<$Res> {
  _$CategoryDetailsErrorCopyWithImpl(this._self, this._then);

  final CategoryDetailsError _self;
  final $Res Function(CategoryDetailsError) _then;

/// Create a copy of CategoryDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? categoryId = null,Object? categoryName = null,}) {
  return _then(CategoryDetailsError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
