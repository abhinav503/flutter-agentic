// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppUpdateEvent {

 String get installedVersion;
/// Create a copy of AppUpdateEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateEventCopyWith<AppUpdateEvent> get copyWith => _$AppUpdateEventCopyWithImpl<AppUpdateEvent>(this as AppUpdateEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateEvent&&(identical(other.installedVersion, installedVersion) || other.installedVersion == installedVersion));
}


@override
int get hashCode => Object.hash(runtimeType,installedVersion);

@override
String toString() {
  return 'AppUpdateEvent(installedVersion: $installedVersion)';
}


}

/// @nodoc
abstract mixin class $AppUpdateEventCopyWith<$Res>  {
  factory $AppUpdateEventCopyWith(AppUpdateEvent value, $Res Function(AppUpdateEvent) _then) = _$AppUpdateEventCopyWithImpl;
@useResult
$Res call({
 String installedVersion
});




}
/// @nodoc
class _$AppUpdateEventCopyWithImpl<$Res>
    implements $AppUpdateEventCopyWith<$Res> {
  _$AppUpdateEventCopyWithImpl(this._self, this._then);

  final AppUpdateEvent _self;
  final $Res Function(AppUpdateEvent) _then;

/// Create a copy of AppUpdateEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? installedVersion = null,}) {
  return _then(_self.copyWith(
installedVersion: null == installedVersion ? _self.installedVersion : installedVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUpdateEvent].
extension AppUpdateEventPatterns on AppUpdateEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AppUpdateStarted value)?  started,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AppUpdateStarted() when started != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AppUpdateStarted value)  started,}){
final _that = this;
switch (_that) {
case AppUpdateStarted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AppUpdateStarted value)?  started,}){
final _that = this;
switch (_that) {
case AppUpdateStarted() when started != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String installedVersion)?  started,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AppUpdateStarted() when started != null:
return started(_that.installedVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String installedVersion)  started,}) {final _that = this;
switch (_that) {
case AppUpdateStarted():
return started(_that.installedVersion);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String installedVersion)?  started,}) {final _that = this;
switch (_that) {
case AppUpdateStarted() when started != null:
return started(_that.installedVersion);case _:
  return null;

}
}

}

/// @nodoc


class AppUpdateStarted implements AppUpdateEvent {
  const AppUpdateStarted({required this.installedVersion});
  

@override final  String installedVersion;

/// Create a copy of AppUpdateEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateStartedCopyWith<AppUpdateStarted> get copyWith => _$AppUpdateStartedCopyWithImpl<AppUpdateStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateStarted&&(identical(other.installedVersion, installedVersion) || other.installedVersion == installedVersion));
}


@override
int get hashCode => Object.hash(runtimeType,installedVersion);

@override
String toString() {
  return 'AppUpdateEvent.started(installedVersion: $installedVersion)';
}


}

/// @nodoc
abstract mixin class $AppUpdateStartedCopyWith<$Res> implements $AppUpdateEventCopyWith<$Res> {
  factory $AppUpdateStartedCopyWith(AppUpdateStarted value, $Res Function(AppUpdateStarted) _then) = _$AppUpdateStartedCopyWithImpl;
@override @useResult
$Res call({
 String installedVersion
});




}
/// @nodoc
class _$AppUpdateStartedCopyWithImpl<$Res>
    implements $AppUpdateStartedCopyWith<$Res> {
  _$AppUpdateStartedCopyWithImpl(this._self, this._then);

  final AppUpdateStarted _self;
  final $Res Function(AppUpdateStarted) _then;

/// Create a copy of AppUpdateEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? installedVersion = null,}) {
  return _then(AppUpdateStarted(
installedVersion: null == installedVersion ? _self.installedVersion : installedVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AppUpdateState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppUpdateState()';
}


}

/// @nodoc
class $AppUpdateStateCopyWith<$Res>  {
$AppUpdateStateCopyWith(AppUpdateState _, $Res Function(AppUpdateState) __);
}


/// Adds pattern-matching-related methods to [AppUpdateState].
extension AppUpdateStatePatterns on AppUpdateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AppUpdateChecking value)?  checking,TResult Function( AppUpdateProceed value)?  proceed,TResult Function( AppUpdateRequired value)?  updateRequired,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AppUpdateChecking() when checking != null:
return checking(_that);case AppUpdateProceed() when proceed != null:
return proceed(_that);case AppUpdateRequired() when updateRequired != null:
return updateRequired(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AppUpdateChecking value)  checking,required TResult Function( AppUpdateProceed value)  proceed,required TResult Function( AppUpdateRequired value)  updateRequired,}){
final _that = this;
switch (_that) {
case AppUpdateChecking():
return checking(_that);case AppUpdateProceed():
return proceed(_that);case AppUpdateRequired():
return updateRequired(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AppUpdateChecking value)?  checking,TResult? Function( AppUpdateProceed value)?  proceed,TResult? Function( AppUpdateRequired value)?  updateRequired,}){
final _that = this;
switch (_that) {
case AppUpdateChecking() when checking != null:
return checking(_that);case AppUpdateProceed() when proceed != null:
return proceed(_that);case AppUpdateRequired() when updateRequired != null:
return updateRequired(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function()?  proceed,TResult Function( AppUpdateRequirementEntity requirement)?  updateRequired,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AppUpdateChecking() when checking != null:
return checking();case AppUpdateProceed() when proceed != null:
return proceed();case AppUpdateRequired() when updateRequired != null:
return updateRequired(_that.requirement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function()  proceed,required TResult Function( AppUpdateRequirementEntity requirement)  updateRequired,}) {final _that = this;
switch (_that) {
case AppUpdateChecking():
return checking();case AppUpdateProceed():
return proceed();case AppUpdateRequired():
return updateRequired(_that.requirement);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function()?  proceed,TResult? Function( AppUpdateRequirementEntity requirement)?  updateRequired,}) {final _that = this;
switch (_that) {
case AppUpdateChecking() when checking != null:
return checking();case AppUpdateProceed() when proceed != null:
return proceed();case AppUpdateRequired() when updateRequired != null:
return updateRequired(_that.requirement);case _:
  return null;

}
}

}

/// @nodoc


class AppUpdateChecking implements AppUpdateState {
  const AppUpdateChecking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateChecking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppUpdateState.checking()';
}


}




/// @nodoc


class AppUpdateProceed implements AppUpdateState {
  const AppUpdateProceed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateProceed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppUpdateState.proceed()';
}


}




/// @nodoc


class AppUpdateRequired implements AppUpdateState {
  const AppUpdateRequired({required this.requirement});
  

 final  AppUpdateRequirementEntity requirement;

/// Create a copy of AppUpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateRequiredCopyWith<AppUpdateRequired> get copyWith => _$AppUpdateRequiredCopyWithImpl<AppUpdateRequired>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateRequired&&(identical(other.requirement, requirement) || other.requirement == requirement));
}


@override
int get hashCode => Object.hash(runtimeType,requirement);

@override
String toString() {
  return 'AppUpdateState.updateRequired(requirement: $requirement)';
}


}

/// @nodoc
abstract mixin class $AppUpdateRequiredCopyWith<$Res> implements $AppUpdateStateCopyWith<$Res> {
  factory $AppUpdateRequiredCopyWith(AppUpdateRequired value, $Res Function(AppUpdateRequired) _then) = _$AppUpdateRequiredCopyWithImpl;
@useResult
$Res call({
 AppUpdateRequirementEntity requirement
});




}
/// @nodoc
class _$AppUpdateRequiredCopyWithImpl<$Res>
    implements $AppUpdateRequiredCopyWith<$Res> {
  _$AppUpdateRequiredCopyWithImpl(this._self, this._then);

  final AppUpdateRequired _self;
  final $Res Function(AppUpdateRequired) _then;

/// Create a copy of AppUpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? requirement = null,}) {
  return _then(AppUpdateRequired(
requirement: null == requirement ? _self.requirement : requirement // ignore: cast_nullable_to_non_nullable
as AppUpdateRequirementEntity,
  ));
}


}

// dart format on
