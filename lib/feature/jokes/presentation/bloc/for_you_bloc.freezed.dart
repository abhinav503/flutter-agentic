// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'for_you_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForYouEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForYouEvent()';
}


}

/// @nodoc
class $ForYouEventCopyWith<$Res>  {
$ForYouEventCopyWith(ForYouEvent _, $Res Function(ForYouEvent) __);
}


/// Adds pattern-matching-related methods to [ForYouEvent].
extension ForYouEventPatterns on ForYouEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ForYouStarted value)?  started,TResult Function( ForYouNextRequested value)?  nextRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ForYouStarted() when started != null:
return started(_that);case ForYouNextRequested() when nextRequested != null:
return nextRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ForYouStarted value)  started,required TResult Function( ForYouNextRequested value)  nextRequested,}){
final _that = this;
switch (_that) {
case ForYouStarted():
return started(_that);case ForYouNextRequested():
return nextRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ForYouStarted value)?  started,TResult? Function( ForYouNextRequested value)?  nextRequested,}){
final _that = this;
switch (_that) {
case ForYouStarted() when started != null:
return started(_that);case ForYouNextRequested() when nextRequested != null:
return nextRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  nextRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ForYouStarted() when started != null:
return started();case ForYouNextRequested() when nextRequested != null:
return nextRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  nextRequested,}) {final _that = this;
switch (_that) {
case ForYouStarted():
return started();case ForYouNextRequested():
return nextRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  nextRequested,}) {final _that = this;
switch (_that) {
case ForYouStarted() when started != null:
return started();case ForYouNextRequested() when nextRequested != null:
return nextRequested();case _:
  return null;

}
}

}

/// @nodoc


class ForYouStarted implements ForYouEvent {
  const ForYouStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForYouEvent.started()';
}


}




/// @nodoc


class ForYouNextRequested implements ForYouEvent {
  const ForYouNextRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouNextRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForYouEvent.nextRequested()';
}


}




/// @nodoc
mixin _$ForYouState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForYouState()';
}


}

/// @nodoc
class $ForYouStateCopyWith<$Res>  {
$ForYouStateCopyWith(ForYouState _, $Res Function(ForYouState) __);
}


/// Adds pattern-matching-related methods to [ForYouState].
extension ForYouStatePatterns on ForYouState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ForYouLoading value)?  loading,TResult Function( ForYouLoaded value)?  loaded,TResult Function( ForYouNextFetchFailed value)?  nextFetchFailed,TResult Function( ForYouError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ForYouLoading() when loading != null:
return loading(_that);case ForYouLoaded() when loaded != null:
return loaded(_that);case ForYouNextFetchFailed() when nextFetchFailed != null:
return nextFetchFailed(_that);case ForYouError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ForYouLoading value)  loading,required TResult Function( ForYouLoaded value)  loaded,required TResult Function( ForYouNextFetchFailed value)  nextFetchFailed,required TResult Function( ForYouError value)  error,}){
final _that = this;
switch (_that) {
case ForYouLoading():
return loading(_that);case ForYouLoaded():
return loaded(_that);case ForYouNextFetchFailed():
return nextFetchFailed(_that);case ForYouError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ForYouLoading value)?  loading,TResult? Function( ForYouLoaded value)?  loaded,TResult? Function( ForYouNextFetchFailed value)?  nextFetchFailed,TResult? Function( ForYouError value)?  error,}){
final _that = this;
switch (_that) {
case ForYouLoading() when loading != null:
return loading(_that);case ForYouLoaded() when loaded != null:
return loaded(_that);case ForYouNextFetchFailed() when nextFetchFailed != null:
return nextFetchFailed(_that);case ForYouError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( JokeEntity joke,  bool isFetchingNext)?  loaded,TResult Function( JokeEntity currentJoke,  String message)?  nextFetchFailed,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ForYouLoading() when loading != null:
return loading();case ForYouLoaded() when loaded != null:
return loaded(_that.joke,_that.isFetchingNext);case ForYouNextFetchFailed() when nextFetchFailed != null:
return nextFetchFailed(_that.currentJoke,_that.message);case ForYouError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( JokeEntity joke,  bool isFetchingNext)  loaded,required TResult Function( JokeEntity currentJoke,  String message)  nextFetchFailed,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ForYouLoading():
return loading();case ForYouLoaded():
return loaded(_that.joke,_that.isFetchingNext);case ForYouNextFetchFailed():
return nextFetchFailed(_that.currentJoke,_that.message);case ForYouError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( JokeEntity joke,  bool isFetchingNext)?  loaded,TResult? Function( JokeEntity currentJoke,  String message)?  nextFetchFailed,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ForYouLoading() when loading != null:
return loading();case ForYouLoaded() when loaded != null:
return loaded(_that.joke,_that.isFetchingNext);case ForYouNextFetchFailed() when nextFetchFailed != null:
return nextFetchFailed(_that.currentJoke,_that.message);case ForYouError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ForYouLoading implements ForYouState {
  const ForYouLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ForYouState.loading()';
}


}




/// @nodoc


class ForYouLoaded implements ForYouState {
  const ForYouLoaded({required this.joke, this.isFetchingNext = false});
  

 final  JokeEntity joke;
@JsonKey() final  bool isFetchingNext;

/// Create a copy of ForYouState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForYouLoadedCopyWith<ForYouLoaded> get copyWith => _$ForYouLoadedCopyWithImpl<ForYouLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouLoaded&&(identical(other.joke, joke) || other.joke == joke)&&(identical(other.isFetchingNext, isFetchingNext) || other.isFetchingNext == isFetchingNext));
}


@override
int get hashCode => Object.hash(runtimeType,joke,isFetchingNext);

@override
String toString() {
  return 'ForYouState.loaded(joke: $joke, isFetchingNext: $isFetchingNext)';
}


}

/// @nodoc
abstract mixin class $ForYouLoadedCopyWith<$Res> implements $ForYouStateCopyWith<$Res> {
  factory $ForYouLoadedCopyWith(ForYouLoaded value, $Res Function(ForYouLoaded) _then) = _$ForYouLoadedCopyWithImpl;
@useResult
$Res call({
 JokeEntity joke, bool isFetchingNext
});




}
/// @nodoc
class _$ForYouLoadedCopyWithImpl<$Res>
    implements $ForYouLoadedCopyWith<$Res> {
  _$ForYouLoadedCopyWithImpl(this._self, this._then);

  final ForYouLoaded _self;
  final $Res Function(ForYouLoaded) _then;

/// Create a copy of ForYouState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? joke = null,Object? isFetchingNext = null,}) {
  return _then(ForYouLoaded(
joke: null == joke ? _self.joke : joke // ignore: cast_nullable_to_non_nullable
as JokeEntity,isFetchingNext: null == isFetchingNext ? _self.isFetchingNext : isFetchingNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ForYouNextFetchFailed implements ForYouState {
  const ForYouNextFetchFailed({required this.currentJoke, required this.message});
  

 final  JokeEntity currentJoke;
 final  String message;

/// Create a copy of ForYouState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForYouNextFetchFailedCopyWith<ForYouNextFetchFailed> get copyWith => _$ForYouNextFetchFailedCopyWithImpl<ForYouNextFetchFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouNextFetchFailed&&(identical(other.currentJoke, currentJoke) || other.currentJoke == currentJoke)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,currentJoke,message);

@override
String toString() {
  return 'ForYouState.nextFetchFailed(currentJoke: $currentJoke, message: $message)';
}


}

/// @nodoc
abstract mixin class $ForYouNextFetchFailedCopyWith<$Res> implements $ForYouStateCopyWith<$Res> {
  factory $ForYouNextFetchFailedCopyWith(ForYouNextFetchFailed value, $Res Function(ForYouNextFetchFailed) _then) = _$ForYouNextFetchFailedCopyWithImpl;
@useResult
$Res call({
 JokeEntity currentJoke, String message
});




}
/// @nodoc
class _$ForYouNextFetchFailedCopyWithImpl<$Res>
    implements $ForYouNextFetchFailedCopyWith<$Res> {
  _$ForYouNextFetchFailedCopyWithImpl(this._self, this._then);

  final ForYouNextFetchFailed _self;
  final $Res Function(ForYouNextFetchFailed) _then;

/// Create a copy of ForYouState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentJoke = null,Object? message = null,}) {
  return _then(ForYouNextFetchFailed(
currentJoke: null == currentJoke ? _self.currentJoke : currentJoke // ignore: cast_nullable_to_non_nullable
as JokeEntity,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ForYouError implements ForYouState {
  const ForYouError({required this.message});
  

 final  String message;

/// Create a copy of ForYouState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForYouErrorCopyWith<ForYouError> get copyWith => _$ForYouErrorCopyWithImpl<ForYouError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForYouError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ForYouState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ForYouErrorCopyWith<$Res> implements $ForYouStateCopyWith<$Res> {
  factory $ForYouErrorCopyWith(ForYouError value, $Res Function(ForYouError) _then) = _$ForYouErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ForYouErrorCopyWithImpl<$Res>
    implements $ForYouErrorCopyWith<$Res> {
  _$ForYouErrorCopyWithImpl(this._self, this._then);

  final ForYouError _self;
  final $Res Function(ForYouError) _then;

/// Create a copy of ForYouState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ForYouError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
