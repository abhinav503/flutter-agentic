// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {

 String get storeId;
/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeEventCopyWith<HomeEvent> get copyWith => _$HomeEventCopyWithImpl<HomeEvent>(this as HomeEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'HomeEvent(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class $HomeEventCopyWith<$Res>  {
  factory $HomeEventCopyWith(HomeEvent value, $Res Function(HomeEvent) _then) = _$HomeEventCopyWithImpl;
@useResult
$Res call({
 String storeId
});




}
/// @nodoc
class _$HomeEventCopyWithImpl<$Res>
    implements $HomeEventCopyWith<$Res> {
  _$HomeEventCopyWithImpl(this._self, this._then);

  final HomeEvent _self;
  final $Res Function(HomeEvent) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = null,}) {
  return _then(_self.copyWith(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeStarted value)?  started,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeStarted() when started != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeStarted value)  started,}){
final _that = this;
switch (_that) {
case HomeStarted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeStarted value)?  started,}){
final _that = this;
switch (_that) {
case HomeStarted() when started != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String storeId)?  started,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeStarted() when started != null:
return started(_that.storeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String storeId)  started,}) {final _that = this;
switch (_that) {
case HomeStarted():
return started(_that.storeId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String storeId)?  started,}) {final _that = this;
switch (_that) {
case HomeStarted() when started != null:
return started(_that.storeId);case _:
  return null;

}
}

}

/// @nodoc


class HomeStarted implements HomeEvent {
  const HomeStarted({required this.storeId});
  

@override final  String storeId;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStartedCopyWith<HomeStarted> get copyWith => _$HomeStartedCopyWithImpl<HomeStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStarted&&(identical(other.storeId, storeId) || other.storeId == storeId));
}


@override
int get hashCode => Object.hash(runtimeType,storeId);

@override
String toString() {
  return 'HomeEvent.started(storeId: $storeId)';
}


}

/// @nodoc
abstract mixin class $HomeStartedCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $HomeStartedCopyWith(HomeStarted value, $Res Function(HomeStarted) _then) = _$HomeStartedCopyWithImpl;
@override @useResult
$Res call({
 String storeId
});




}
/// @nodoc
class _$HomeStartedCopyWithImpl<$Res>
    implements $HomeStartedCopyWith<$Res> {
  _$HomeStartedCopyWithImpl(this._self, this._then);

  final HomeStarted _self;
  final $Res Function(HomeStarted) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = null,}) {
  return _then(HomeStarted(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeLoading value)?  loading,TResult Function( HomeLoaded value)?  loaded,TResult Function( HomeError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading(_that);case HomeLoaded() when loaded != null:
return loaded(_that);case HomeError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeLoading value)  loading,required TResult Function( HomeLoaded value)  loaded,required TResult Function( HomeError value)  error,}){
final _that = this;
switch (_that) {
case HomeLoading():
return loading(_that);case HomeLoaded():
return loaded(_that);case HomeError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeLoading value)?  loading,TResult? Function( HomeLoaded value)?  loaded,TResult? Function( HomeError value)?  error,}){
final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading(_that);case HomeLoaded() when loaded != null:
return loaded(_that);case HomeError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( HomeEntity home,  bool refreshFailed)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading();case HomeLoaded() when loaded != null:
return loaded(_that.home,_that.refreshFailed);case HomeError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( HomeEntity home,  bool refreshFailed)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case HomeLoading():
return loading();case HomeLoaded():
return loaded(_that.home,_that.refreshFailed);case HomeError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( HomeEntity home,  bool refreshFailed)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading();case HomeLoaded() when loaded != null:
return loaded(_that.home,_that.refreshFailed);case HomeError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class HomeLoading implements HomeState {
  const HomeLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.loading()';
}


}




/// @nodoc


class HomeLoaded implements HomeState {
  const HomeLoaded({required this.home, this.refreshFailed = false});
  

 final  HomeEntity home;
// True only when a silent background refresh (a warm start seeded from
// HomeBloc's cached data) fails — the already-visible cached content
// stays on screen; the listener surfaces this via a snackbar instead of
// replacing it with the error view.
@JsonKey() final  bool refreshFailed;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeLoadedCopyWith<HomeLoaded> get copyWith => _$HomeLoadedCopyWithImpl<HomeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoaded&&(identical(other.home, home) || other.home == home)&&(identical(other.refreshFailed, refreshFailed) || other.refreshFailed == refreshFailed));
}


@override
int get hashCode => Object.hash(runtimeType,home,refreshFailed);

@override
String toString() {
  return 'HomeState.loaded(home: $home, refreshFailed: $refreshFailed)';
}


}

/// @nodoc
abstract mixin class $HomeLoadedCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeLoadedCopyWith(HomeLoaded value, $Res Function(HomeLoaded) _then) = _$HomeLoadedCopyWithImpl;
@useResult
$Res call({
 HomeEntity home, bool refreshFailed
});




}
/// @nodoc
class _$HomeLoadedCopyWithImpl<$Res>
    implements $HomeLoadedCopyWith<$Res> {
  _$HomeLoadedCopyWithImpl(this._self, this._then);

  final HomeLoaded _self;
  final $Res Function(HomeLoaded) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? home = null,Object? refreshFailed = null,}) {
  return _then(HomeLoaded(
home: null == home ? _self.home : home // ignore: cast_nullable_to_non_nullable
as HomeEntity,refreshFailed: null == refreshFailed ? _self.refreshFailed : refreshFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class HomeError implements HomeState {
  const HomeError({required this.message});
  

 final  String message;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeErrorCopyWith<HomeError> get copyWith => _$HomeErrorCopyWithImpl<HomeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HomeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $HomeErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeErrorCopyWith(HomeError value, $Res Function(HomeError) _then) = _$HomeErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HomeErrorCopyWithImpl<$Res>
    implements $HomeErrorCopyWith<$Res> {
  _$HomeErrorCopyWithImpl(this._self, this._then);

  final HomeError _self;
  final $Res Function(HomeError) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HomeError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
