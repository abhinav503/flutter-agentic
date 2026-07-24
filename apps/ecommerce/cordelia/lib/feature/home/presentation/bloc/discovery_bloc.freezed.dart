// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryEvent()';
}


}

/// @nodoc
class $DiscoveryEventCopyWith<$Res>  {
$DiscoveryEventCopyWith(DiscoveryEvent _, $Res Function(DiscoveryEvent) __);
}


/// Adds pattern-matching-related methods to [DiscoveryEvent].
extension DiscoveryEventPatterns on DiscoveryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DiscoveryStarted value)?  started,TResult Function( DiscoveryQueryChanged value)?  queryChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DiscoveryStarted() when started != null:
return started(_that);case DiscoveryQueryChanged() when queryChanged != null:
return queryChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DiscoveryStarted value)  started,required TResult Function( DiscoveryQueryChanged value)  queryChanged,}){
final _that = this;
switch (_that) {
case DiscoveryStarted():
return started(_that);case DiscoveryQueryChanged():
return queryChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DiscoveryStarted value)?  started,TResult? Function( DiscoveryQueryChanged value)?  queryChanged,}){
final _that = this;
switch (_that) {
case DiscoveryStarted() when started != null:
return started(_that);case DiscoveryQueryChanged() when queryChanged != null:
return queryChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String query)?  queryChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DiscoveryStarted() when started != null:
return started();case DiscoveryQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String query)  queryChanged,}) {final _that = this;
switch (_that) {
case DiscoveryStarted():
return started();case DiscoveryQueryChanged():
return queryChanged(_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String query)?  queryChanged,}) {final _that = this;
switch (_that) {
case DiscoveryStarted() when started != null:
return started();case DiscoveryQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case _:
  return null;

}
}

}

/// @nodoc


class DiscoveryStarted implements DiscoveryEvent {
  const DiscoveryStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryEvent.started()';
}


}




/// @nodoc


class DiscoveryQueryChanged implements DiscoveryEvent {
  const DiscoveryQueryChanged({required this.query});
  

 final  String query;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryQueryChangedCopyWith<DiscoveryQueryChanged> get copyWith => _$DiscoveryQueryChangedCopyWithImpl<DiscoveryQueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryQueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'DiscoveryEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $DiscoveryQueryChangedCopyWith<$Res> implements $DiscoveryEventCopyWith<$Res> {
  factory $DiscoveryQueryChangedCopyWith(DiscoveryQueryChanged value, $Res Function(DiscoveryQueryChanged) _then) = _$DiscoveryQueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$DiscoveryQueryChangedCopyWithImpl<$Res>
    implements $DiscoveryQueryChangedCopyWith<$Res> {
  _$DiscoveryQueryChangedCopyWithImpl(this._self, this._then);

  final DiscoveryQueryChanged _self;
  final $Res Function(DiscoveryQueryChanged) _then;

/// Create a copy of DiscoveryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(DiscoveryQueryChanged(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$DiscoveryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryState()';
}


}

/// @nodoc
class $DiscoveryStateCopyWith<$Res>  {
$DiscoveryStateCopyWith(DiscoveryState _, $Res Function(DiscoveryState) __);
}


/// Adds pattern-matching-related methods to [DiscoveryState].
extension DiscoveryStatePatterns on DiscoveryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DiscoveryLoading value)?  loading,TResult Function( DiscoveryLoaded value)?  loaded,TResult Function( DiscoveryEmpty value)?  empty,TResult Function( DiscoveryError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DiscoveryLoading() when loading != null:
return loading(_that);case DiscoveryLoaded() when loaded != null:
return loaded(_that);case DiscoveryEmpty() when empty != null:
return empty(_that);case DiscoveryError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DiscoveryLoading value)  loading,required TResult Function( DiscoveryLoaded value)  loaded,required TResult Function( DiscoveryEmpty value)  empty,required TResult Function( DiscoveryError value)  error,}){
final _that = this;
switch (_that) {
case DiscoveryLoading():
return loading(_that);case DiscoveryLoaded():
return loaded(_that);case DiscoveryEmpty():
return empty(_that);case DiscoveryError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DiscoveryLoading value)?  loading,TResult? Function( DiscoveryLoaded value)?  loaded,TResult? Function( DiscoveryEmpty value)?  empty,TResult? Function( DiscoveryError value)?  error,}){
final _that = this;
switch (_that) {
case DiscoveryLoading() when loading != null:
return loading(_that);case DiscoveryLoaded() when loaded != null:
return loaded(_that);case DiscoveryEmpty() when empty != null:
return empty(_that);case DiscoveryError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<StoreEntity> stores,  String query)?  loaded,TResult Function( String query)?  empty,TResult Function( String message,  String query)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DiscoveryLoading() when loading != null:
return loading();case DiscoveryLoaded() when loaded != null:
return loaded(_that.stores,_that.query);case DiscoveryEmpty() when empty != null:
return empty(_that.query);case DiscoveryError() when error != null:
return error(_that.message,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<StoreEntity> stores,  String query)  loaded,required TResult Function( String query)  empty,required TResult Function( String message,  String query)  error,}) {final _that = this;
switch (_that) {
case DiscoveryLoading():
return loading();case DiscoveryLoaded():
return loaded(_that.stores,_that.query);case DiscoveryEmpty():
return empty(_that.query);case DiscoveryError():
return error(_that.message,_that.query);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<StoreEntity> stores,  String query)?  loaded,TResult? Function( String query)?  empty,TResult? Function( String message,  String query)?  error,}) {final _that = this;
switch (_that) {
case DiscoveryLoading() when loading != null:
return loading();case DiscoveryLoaded() when loaded != null:
return loaded(_that.stores,_that.query);case DiscoveryEmpty() when empty != null:
return empty(_that.query);case DiscoveryError() when error != null:
return error(_that.message,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class DiscoveryLoading implements DiscoveryState {
  const DiscoveryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscoveryState.loading()';
}


}




/// @nodoc


class DiscoveryLoaded implements DiscoveryState {
  const DiscoveryLoaded({required final  List<StoreEntity> stores, required this.query}): _stores = stores;
  

 final  List<StoreEntity> _stores;
 List<StoreEntity> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}

 final  String query;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryLoadedCopyWith<DiscoveryLoaded> get copyWith => _$DiscoveryLoadedCopyWithImpl<DiscoveryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryLoaded&&const DeepCollectionEquality().equals(other._stores, _stores)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stores),query);

@override
String toString() {
  return 'DiscoveryState.loaded(stores: $stores, query: $query)';
}


}

/// @nodoc
abstract mixin class $DiscoveryLoadedCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory $DiscoveryLoadedCopyWith(DiscoveryLoaded value, $Res Function(DiscoveryLoaded) _then) = _$DiscoveryLoadedCopyWithImpl;
@useResult
$Res call({
 List<StoreEntity> stores, String query
});




}
/// @nodoc
class _$DiscoveryLoadedCopyWithImpl<$Res>
    implements $DiscoveryLoadedCopyWith<$Res> {
  _$DiscoveryLoadedCopyWithImpl(this._self, this._then);

  final DiscoveryLoaded _self;
  final $Res Function(DiscoveryLoaded) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stores = null,Object? query = null,}) {
  return _then(DiscoveryLoaded(
stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<StoreEntity>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DiscoveryEmpty implements DiscoveryState {
  const DiscoveryEmpty({required this.query});
  

 final  String query;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryEmptyCopyWith<DiscoveryEmpty> get copyWith => _$DiscoveryEmptyCopyWithImpl<DiscoveryEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryEmpty&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'DiscoveryState.empty(query: $query)';
}


}

/// @nodoc
abstract mixin class $DiscoveryEmptyCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory $DiscoveryEmptyCopyWith(DiscoveryEmpty value, $Res Function(DiscoveryEmpty) _then) = _$DiscoveryEmptyCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$DiscoveryEmptyCopyWithImpl<$Res>
    implements $DiscoveryEmptyCopyWith<$Res> {
  _$DiscoveryEmptyCopyWithImpl(this._self, this._then);

  final DiscoveryEmpty _self;
  final $Res Function(DiscoveryEmpty) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(DiscoveryEmpty(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DiscoveryError implements DiscoveryState {
  const DiscoveryError({required this.message, required this.query});
  

 final  String message;
 final  String query;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryErrorCopyWith<DiscoveryError> get copyWith => _$DiscoveryErrorCopyWithImpl<DiscoveryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryError&&(identical(other.message, message) || other.message == message)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,message,query);

@override
String toString() {
  return 'DiscoveryState.error(message: $message, query: $query)';
}


}

/// @nodoc
abstract mixin class $DiscoveryErrorCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory $DiscoveryErrorCopyWith(DiscoveryError value, $Res Function(DiscoveryError) _then) = _$DiscoveryErrorCopyWithImpl;
@useResult
$Res call({
 String message, String query
});




}
/// @nodoc
class _$DiscoveryErrorCopyWithImpl<$Res>
    implements $DiscoveryErrorCopyWith<$Res> {
  _$DiscoveryErrorCopyWithImpl(this._self, this._then);

  final DiscoveryError _self;
  final $Res Function(DiscoveryError) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? query = null,}) {
  return _then(DiscoveryError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
