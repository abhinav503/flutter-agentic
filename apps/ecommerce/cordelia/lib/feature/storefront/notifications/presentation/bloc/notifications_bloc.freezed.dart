// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsEvent()';
}


}

/// @nodoc
class $NotificationsEventCopyWith<$Res>  {
$NotificationsEventCopyWith(NotificationsEvent _, $Res Function(NotificationsEvent) __);
}


/// Adds pattern-matching-related methods to [NotificationsEvent].
extension NotificationsEventPatterns on NotificationsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationsStarted value)?  started,TResult Function( NotificationsPermissionRequested value)?  permissionRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationsStarted() when started != null:
return started(_that);case NotificationsPermissionRequested() when permissionRequested != null:
return permissionRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationsStarted value)  started,required TResult Function( NotificationsPermissionRequested value)  permissionRequested,}){
final _that = this;
switch (_that) {
case NotificationsStarted():
return started(_that);case NotificationsPermissionRequested():
return permissionRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationsStarted value)?  started,TResult? Function( NotificationsPermissionRequested value)?  permissionRequested,}){
final _that = this;
switch (_that) {
case NotificationsStarted() when started != null:
return started(_that);case NotificationsPermissionRequested() when permissionRequested != null:
return permissionRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  permissionRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationsStarted() when started != null:
return started();case NotificationsPermissionRequested() when permissionRequested != null:
return permissionRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  permissionRequested,}) {final _that = this;
switch (_that) {
case NotificationsStarted():
return started();case NotificationsPermissionRequested():
return permissionRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  permissionRequested,}) {final _that = this;
switch (_that) {
case NotificationsStarted() when started != null:
return started();case NotificationsPermissionRequested() when permissionRequested != null:
return permissionRequested();case _:
  return null;

}
}

}

/// @nodoc


class NotificationsStarted implements NotificationsEvent {
  const NotificationsStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsEvent.started()';
}


}




/// @nodoc


class NotificationsPermissionRequested implements NotificationsEvent {
  const NotificationsPermissionRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsPermissionRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsEvent.permissionRequested()';
}


}




/// @nodoc
mixin _$NotificationsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState()';
}


}

/// @nodoc
class $NotificationsStateCopyWith<$Res>  {
$NotificationsStateCopyWith(NotificationsState _, $Res Function(NotificationsState) __);
}


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns on NotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NotificationsLoading value)?  loading,TResult Function( NotificationsLoaded value)?  loaded,TResult Function( NotificationsPermissionRequired value)?  permissionRequired,TResult Function( NotificationsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NotificationsLoading() when loading != null:
return loading(_that);case NotificationsLoaded() when loaded != null:
return loaded(_that);case NotificationsPermissionRequired() when permissionRequired != null:
return permissionRequired(_that);case NotificationsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NotificationsLoading value)  loading,required TResult Function( NotificationsLoaded value)  loaded,required TResult Function( NotificationsPermissionRequired value)  permissionRequired,required TResult Function( NotificationsError value)  error,}){
final _that = this;
switch (_that) {
case NotificationsLoading():
return loading(_that);case NotificationsLoaded():
return loaded(_that);case NotificationsPermissionRequired():
return permissionRequired(_that);case NotificationsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NotificationsLoading value)?  loading,TResult? Function( NotificationsLoaded value)?  loaded,TResult? Function( NotificationsPermissionRequired value)?  permissionRequired,TResult? Function( NotificationsError value)?  error,}){
final _that = this;
switch (_that) {
case NotificationsLoading() when loading != null:
return loading(_that);case NotificationsLoaded() when loaded != null:
return loaded(_that);case NotificationsPermissionRequired() when permissionRequired != null:
return permissionRequired(_that);case NotificationsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<NotificationSectionEntity> sections)?  loaded,TResult Function( bool requesting,  bool blocked)?  permissionRequired,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NotificationsLoading() when loading != null:
return loading();case NotificationsLoaded() when loaded != null:
return loaded(_that.sections);case NotificationsPermissionRequired() when permissionRequired != null:
return permissionRequired(_that.requesting,_that.blocked);case NotificationsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<NotificationSectionEntity> sections)  loaded,required TResult Function( bool requesting,  bool blocked)  permissionRequired,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case NotificationsLoading():
return loading();case NotificationsLoaded():
return loaded(_that.sections);case NotificationsPermissionRequired():
return permissionRequired(_that.requesting,_that.blocked);case NotificationsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<NotificationSectionEntity> sections)?  loaded,TResult? Function( bool requesting,  bool blocked)?  permissionRequired,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case NotificationsLoading() when loading != null:
return loading();case NotificationsLoaded() when loaded != null:
return loaded(_that.sections);case NotificationsPermissionRequired() when permissionRequired != null:
return permissionRequired(_that.requesting,_that.blocked);case NotificationsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NotificationsLoading implements NotificationsState {
  const NotificationsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState.loading()';
}


}




/// @nodoc


class NotificationsLoaded implements NotificationsState {
  const NotificationsLoaded({required final  List<NotificationSectionEntity> sections}): _sections = sections;
  

 final  List<NotificationSectionEntity> _sections;
 List<NotificationSectionEntity> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsLoadedCopyWith<NotificationsLoaded> get copyWith => _$NotificationsLoadedCopyWithImpl<NotificationsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsLoaded&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'NotificationsState.loaded(sections: $sections)';
}


}

/// @nodoc
abstract mixin class $NotificationsLoadedCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory $NotificationsLoadedCopyWith(NotificationsLoaded value, $Res Function(NotificationsLoaded) _then) = _$NotificationsLoadedCopyWithImpl;
@useResult
$Res call({
 List<NotificationSectionEntity> sections
});




}
/// @nodoc
class _$NotificationsLoadedCopyWithImpl<$Res>
    implements $NotificationsLoadedCopyWith<$Res> {
  _$NotificationsLoadedCopyWithImpl(this._self, this._then);

  final NotificationsLoaded _self;
  final $Res Function(NotificationsLoaded) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sections = null,}) {
  return _then(NotificationsLoaded(
sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<NotificationSectionEntity>,
  ));
}


}

/// @nodoc


class NotificationsPermissionRequired implements NotificationsState {
  const NotificationsPermissionRequired({this.requesting = false, this.blocked = false});
  

/// The OS dialog is up (or the request is in flight) — the CTA shows its
/// loading state rather than accepting a second tap.
@JsonKey() final  bool requesting;
/// The request came back denied *without* a dialog: the shopper already
/// said no, and only the device settings can change it now. Carried on
/// the state rather than emitted as a one-off so the screen decides how
/// to say so — every template sends it to a snackbar.
@JsonKey() final  bool blocked;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsPermissionRequiredCopyWith<NotificationsPermissionRequired> get copyWith => _$NotificationsPermissionRequiredCopyWithImpl<NotificationsPermissionRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsPermissionRequired&&(identical(other.requesting, requesting) || other.requesting == requesting)&&(identical(other.blocked, blocked) || other.blocked == blocked));
}


@override
int get hashCode => Object.hash(runtimeType,requesting,blocked);

@override
String toString() {
  return 'NotificationsState.permissionRequired(requesting: $requesting, blocked: $blocked)';
}


}

/// @nodoc
abstract mixin class $NotificationsPermissionRequiredCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory $NotificationsPermissionRequiredCopyWith(NotificationsPermissionRequired value, $Res Function(NotificationsPermissionRequired) _then) = _$NotificationsPermissionRequiredCopyWithImpl;
@useResult
$Res call({
 bool requesting, bool blocked
});




}
/// @nodoc
class _$NotificationsPermissionRequiredCopyWithImpl<$Res>
    implements $NotificationsPermissionRequiredCopyWith<$Res> {
  _$NotificationsPermissionRequiredCopyWithImpl(this._self, this._then);

  final NotificationsPermissionRequired _self;
  final $Res Function(NotificationsPermissionRequired) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requesting = null,Object? blocked = null,}) {
  return _then(NotificationsPermissionRequired(
requesting: null == requesting ? _self.requesting : requesting // ignore: cast_nullable_to_non_nullable
as bool,blocked: null == blocked ? _self.blocked : blocked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class NotificationsError implements NotificationsState {
  const NotificationsError({required this.message});
  

 final  String message;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsErrorCopyWith<NotificationsError> get copyWith => _$NotificationsErrorCopyWithImpl<NotificationsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationsErrorCopyWith<$Res> implements $NotificationsStateCopyWith<$Res> {
  factory $NotificationsErrorCopyWith(NotificationsError value, $Res Function(NotificationsError) _then) = _$NotificationsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NotificationsErrorCopyWithImpl<$Res>
    implements $NotificationsErrorCopyWith<$Res> {
  _$NotificationsErrorCopyWithImpl(this._self, this._then);

  final NotificationsError _self;
  final $Res Function(NotificationsError) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NotificationsError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
