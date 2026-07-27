// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoriesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoriesEvent()';
}


}

/// @nodoc
class $CategoriesEventCopyWith<$Res>  {
$CategoriesEventCopyWith(CategoriesEvent _, $Res Function(CategoriesEvent) __);
}


/// Adds pattern-matching-related methods to [CategoriesEvent].
extension CategoriesEventPatterns on CategoriesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CategoriesStarted value)?  started,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CategoriesStarted() when started != null:
return started(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CategoriesStarted value)  started,}){
final _that = this;
switch (_that) {
case CategoriesStarted():
return started(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CategoriesStarted value)?  started,}){
final _that = this;
switch (_that) {
case CategoriesStarted() when started != null:
return started(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CategoriesStarted() when started != null:
return started();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,}) {final _that = this;
switch (_that) {
case CategoriesStarted():
return started();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,}) {final _that = this;
switch (_that) {
case CategoriesStarted() when started != null:
return started();case _:
  return null;

}
}

}

/// @nodoc


class CategoriesStarted implements CategoriesEvent {
  const CategoriesStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoriesEvent.started()';
}


}




/// @nodoc
mixin _$CategoriesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoriesState()';
}


}

/// @nodoc
class $CategoriesStateCopyWith<$Res>  {
$CategoriesStateCopyWith(CategoriesState _, $Res Function(CategoriesState) __);
}


/// Adds pattern-matching-related methods to [CategoriesState].
extension CategoriesStatePatterns on CategoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CategoriesLoading value)?  loading,TResult Function( CategoriesLoaded value)?  loaded,TResult Function( CategoriesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CategoriesLoading() when loading != null:
return loading(_that);case CategoriesLoaded() when loaded != null:
return loaded(_that);case CategoriesError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CategoriesLoading value)  loading,required TResult Function( CategoriesLoaded value)  loaded,required TResult Function( CategoriesError value)  error,}){
final _that = this;
switch (_that) {
case CategoriesLoading():
return loading(_that);case CategoriesLoaded():
return loaded(_that);case CategoriesError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CategoriesLoading value)?  loading,TResult? Function( CategoriesLoaded value)?  loaded,TResult? Function( CategoriesError value)?  error,}){
final _that = this;
switch (_that) {
case CategoriesLoading() when loading != null:
return loading(_that);case CategoriesLoaded() when loaded != null:
return loaded(_that);case CategoriesError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( CategoriesEntity categories,  bool refreshFailed)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CategoriesLoading() when loading != null:
return loading();case CategoriesLoaded() when loaded != null:
return loaded(_that.categories,_that.refreshFailed);case CategoriesError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( CategoriesEntity categories,  bool refreshFailed)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CategoriesLoading():
return loading();case CategoriesLoaded():
return loaded(_that.categories,_that.refreshFailed);case CategoriesError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( CategoriesEntity categories,  bool refreshFailed)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CategoriesLoading() when loading != null:
return loading();case CategoriesLoaded() when loaded != null:
return loaded(_that.categories,_that.refreshFailed);case CategoriesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CategoriesLoading implements CategoriesState {
  const CategoriesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoriesState.loading()';
}


}




/// @nodoc


class CategoriesLoaded implements CategoriesState {
  const CategoriesLoaded({required this.categories, this.refreshFailed = false});
  

 final  CategoriesEntity categories;
// True only when a silent background refresh (a warm start seeded from
// CategoriesBloc's cached data) fails — the already-visible cached
// content stays on screen; the listener surfaces this via a snackbar
// instead of replacing it with the error view.
@JsonKey() final  bool refreshFailed;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesLoadedCopyWith<CategoriesLoaded> get copyWith => _$CategoriesLoadedCopyWithImpl<CategoriesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesLoaded&&(identical(other.categories, categories) || other.categories == categories)&&(identical(other.refreshFailed, refreshFailed) || other.refreshFailed == refreshFailed));
}


@override
int get hashCode => Object.hash(runtimeType,categories,refreshFailed);

@override
String toString() {
  return 'CategoriesState.loaded(categories: $categories, refreshFailed: $refreshFailed)';
}


}

/// @nodoc
abstract mixin class $CategoriesLoadedCopyWith<$Res> implements $CategoriesStateCopyWith<$Res> {
  factory $CategoriesLoadedCopyWith(CategoriesLoaded value, $Res Function(CategoriesLoaded) _then) = _$CategoriesLoadedCopyWithImpl;
@useResult
$Res call({
 CategoriesEntity categories, bool refreshFailed
});




}
/// @nodoc
class _$CategoriesLoadedCopyWithImpl<$Res>
    implements $CategoriesLoadedCopyWith<$Res> {
  _$CategoriesLoadedCopyWithImpl(this._self, this._then);

  final CategoriesLoaded _self;
  final $Res Function(CategoriesLoaded) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? refreshFailed = null,}) {
  return _then(CategoriesLoaded(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as CategoriesEntity,refreshFailed: null == refreshFailed ? _self.refreshFailed : refreshFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CategoriesError implements CategoriesState {
  const CategoriesError({required this.message});
  

 final  String message;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesErrorCopyWith<CategoriesError> get copyWith => _$CategoriesErrorCopyWithImpl<CategoriesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CategoriesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CategoriesErrorCopyWith<$Res> implements $CategoriesStateCopyWith<$Res> {
  factory $CategoriesErrorCopyWith(CategoriesError value, $Res Function(CategoriesError) _then) = _$CategoriesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CategoriesErrorCopyWithImpl<$Res>
    implements $CategoriesErrorCopyWith<$Res> {
  _$CategoriesErrorCopyWithImpl(this._self, this._then);

  final CategoriesError _self;
  final $Res Function(CategoriesError) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CategoriesError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
