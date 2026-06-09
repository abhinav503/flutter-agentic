// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JokeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeEvent()';
}


}

/// @nodoc
class $JokeEventCopyWith<$Res>  {
$JokeEventCopyWith(JokeEvent _, $Res Function(JokeEvent) __);
}


/// Adds pattern-matching-related methods to [JokeEvent].
extension JokeEventPatterns on JokeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JokeFetched value)?  fetched,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JokeFetched() when fetched != null:
return fetched(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JokeFetched value)  fetched,}){
final _that = this;
switch (_that) {
case JokeFetched():
return fetched(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JokeFetched value)?  fetched,}){
final _that = this;
switch (_that) {
case JokeFetched() when fetched != null:
return fetched(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetched,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JokeFetched() when fetched != null:
return fetched();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetched,}) {final _that = this;
switch (_that) {
case JokeFetched():
return fetched();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetched,}) {final _that = this;
switch (_that) {
case JokeFetched() when fetched != null:
return fetched();case _:
  return null;

}
}

}

/// @nodoc


class JokeFetched implements JokeEvent {
  const JokeFetched();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeFetched);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeEvent.fetched()';
}


}




/// @nodoc
mixin _$JokeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeState()';
}


}

/// @nodoc
class $JokeStateCopyWith<$Res>  {
$JokeStateCopyWith(JokeState _, $Res Function(JokeState) __);
}


/// Adds pattern-matching-related methods to [JokeState].
extension JokeStatePatterns on JokeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JokeInitial value)?  initial,TResult Function( JokeLoading value)?  loading,TResult Function( JokeLoaded value)?  loaded,TResult Function( JokeError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JokeInitial() when initial != null:
return initial(_that);case JokeLoading() when loading != null:
return loading(_that);case JokeLoaded() when loaded != null:
return loaded(_that);case JokeError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JokeInitial value)  initial,required TResult Function( JokeLoading value)  loading,required TResult Function( JokeLoaded value)  loaded,required TResult Function( JokeError value)  error,}){
final _that = this;
switch (_that) {
case JokeInitial():
return initial(_that);case JokeLoading():
return loading(_that);case JokeLoaded():
return loaded(_that);case JokeError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JokeInitial value)?  initial,TResult? Function( JokeLoading value)?  loading,TResult? Function( JokeLoaded value)?  loaded,TResult? Function( JokeError value)?  error,}){
final _that = this;
switch (_that) {
case JokeInitial() when initial != null:
return initial(_that);case JokeLoading() when loading != null:
return loading(_that);case JokeLoaded() when loaded != null:
return loaded(_that);case JokeError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( JokeEntity joke)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JokeInitial() when initial != null:
return initial();case JokeLoading() when loading != null:
return loading();case JokeLoaded() when loaded != null:
return loaded(_that.joke);case JokeError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( JokeEntity joke)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case JokeInitial():
return initial();case JokeLoading():
return loading();case JokeLoaded():
return loaded(_that.joke);case JokeError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( JokeEntity joke)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case JokeInitial() when initial != null:
return initial();case JokeLoading() when loading != null:
return loading();case JokeLoaded() when loaded != null:
return loaded(_that.joke);case JokeError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class JokeInitial implements JokeState {
  const JokeInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeState.initial()';
}


}




/// @nodoc


class JokeLoading implements JokeState {
  const JokeLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeState.loading()';
}


}




/// @nodoc


class JokeLoaded implements JokeState {
  const JokeLoaded({required this.joke});
  

 final  JokeEntity joke;

/// Create a copy of JokeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeLoadedCopyWith<JokeLoaded> get copyWith => _$JokeLoadedCopyWithImpl<JokeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeLoaded&&(identical(other.joke, joke) || other.joke == joke));
}


@override
int get hashCode => Object.hash(runtimeType,joke);

@override
String toString() {
  return 'JokeState.loaded(joke: $joke)';
}


}

/// @nodoc
abstract mixin class $JokeLoadedCopyWith<$Res> implements $JokeStateCopyWith<$Res> {
  factory $JokeLoadedCopyWith(JokeLoaded value, $Res Function(JokeLoaded) _then) = _$JokeLoadedCopyWithImpl;
@useResult
$Res call({
 JokeEntity joke
});




}
/// @nodoc
class _$JokeLoadedCopyWithImpl<$Res>
    implements $JokeLoadedCopyWith<$Res> {
  _$JokeLoadedCopyWithImpl(this._self, this._then);

  final JokeLoaded _self;
  final $Res Function(JokeLoaded) _then;

/// Create a copy of JokeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? joke = null,}) {
  return _then(JokeLoaded(
joke: null == joke ? _self.joke : joke // ignore: cast_nullable_to_non_nullable
as JokeEntity,
  ));
}


}

/// @nodoc


class JokeError implements JokeState {
  const JokeError({required this.message});
  

 final  String message;

/// Create a copy of JokeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeErrorCopyWith<JokeError> get copyWith => _$JokeErrorCopyWithImpl<JokeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JokeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $JokeErrorCopyWith<$Res> implements $JokeStateCopyWith<$Res> {
  factory $JokeErrorCopyWith(JokeError value, $Res Function(JokeError) _then) = _$JokeErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$JokeErrorCopyWithImpl<$Res>
    implements $JokeErrorCopyWith<$Res> {
  _$JokeErrorCopyWithImpl(this._self, this._then);

  final JokeError _self;
  final $Res Function(JokeError) _then;

/// Create a copy of JokeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(JokeError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
