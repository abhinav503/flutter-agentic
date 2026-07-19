// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChangePasswordEvent {

 String get currentPassword; String get newPassword;
/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordEventCopyWith<ChangePasswordEvent> get copyWith => _$ChangePasswordEventCopyWithImpl<ChangePasswordEvent>(this as ChangePasswordEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordEvent&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}


@override
int get hashCode => Object.hash(runtimeType,currentPassword,newPassword);

@override
String toString() {
  return 'ChangePasswordEvent(currentPassword: $currentPassword, newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordEventCopyWith<$Res>  {
  factory $ChangePasswordEventCopyWith(ChangePasswordEvent value, $Res Function(ChangePasswordEvent) _then) = _$ChangePasswordEventCopyWithImpl;
@useResult
$Res call({
 String currentPassword, String newPassword
});




}
/// @nodoc
class _$ChangePasswordEventCopyWithImpl<$Res>
    implements $ChangePasswordEventCopyWith<$Res> {
  _$ChangePasswordEventCopyWithImpl(this._self, this._then);

  final ChangePasswordEvent _self;
  final $Res Function(ChangePasswordEvent) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPassword = null,Object? newPassword = null,}) {
  return _then(_self.copyWith(
currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChangePasswordEvent].
extension ChangePasswordEventPatterns on ChangePasswordEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChangePasswordSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChangePasswordSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChangePasswordSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case ChangePasswordSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChangePasswordSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case ChangePasswordSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String currentPassword,  String newPassword)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChangePasswordSubmitted() when submitted != null:
return submitted(_that.currentPassword,_that.newPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String currentPassword,  String newPassword)  submitted,}) {final _that = this;
switch (_that) {
case ChangePasswordSubmitted():
return submitted(_that.currentPassword,_that.newPassword);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String currentPassword,  String newPassword)?  submitted,}) {final _that = this;
switch (_that) {
case ChangePasswordSubmitted() when submitted != null:
return submitted(_that.currentPassword,_that.newPassword);case _:
  return null;

}
}

}

/// @nodoc


class ChangePasswordSubmitted implements ChangePasswordEvent {
  const ChangePasswordSubmitted({required this.currentPassword, required this.newPassword});
  

@override final  String currentPassword;
@override final  String newPassword;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordSubmittedCopyWith<ChangePasswordSubmitted> get copyWith => _$ChangePasswordSubmittedCopyWithImpl<ChangePasswordSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordSubmitted&&(identical(other.currentPassword, currentPassword) || other.currentPassword == currentPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword));
}


@override
int get hashCode => Object.hash(runtimeType,currentPassword,newPassword);

@override
String toString() {
  return 'ChangePasswordEvent.submitted(currentPassword: $currentPassword, newPassword: $newPassword)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordSubmittedCopyWith<$Res> implements $ChangePasswordEventCopyWith<$Res> {
  factory $ChangePasswordSubmittedCopyWith(ChangePasswordSubmitted value, $Res Function(ChangePasswordSubmitted) _then) = _$ChangePasswordSubmittedCopyWithImpl;
@override @useResult
$Res call({
 String currentPassword, String newPassword
});




}
/// @nodoc
class _$ChangePasswordSubmittedCopyWithImpl<$Res>
    implements $ChangePasswordSubmittedCopyWith<$Res> {
  _$ChangePasswordSubmittedCopyWithImpl(this._self, this._then);

  final ChangePasswordSubmitted _self;
  final $Res Function(ChangePasswordSubmitted) _then;

/// Create a copy of ChangePasswordEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPassword = null,Object? newPassword = null,}) {
  return _then(ChangePasswordSubmitted(
currentPassword: null == currentPassword ? _self.currentPassword : currentPassword // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChangePasswordState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePasswordState()';
}


}

/// @nodoc
class $ChangePasswordStateCopyWith<$Res>  {
$ChangePasswordStateCopyWith(ChangePasswordState _, $Res Function(ChangePasswordState) __);
}


/// Adds pattern-matching-related methods to [ChangePasswordState].
extension ChangePasswordStatePatterns on ChangePasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChangePasswordInitial value)?  initial,TResult Function( ChangePasswordSaving value)?  saving,TResult Function( ChangePasswordSuccess value)?  success,TResult Function( ChangePasswordError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChangePasswordInitial() when initial != null:
return initial(_that);case ChangePasswordSaving() when saving != null:
return saving(_that);case ChangePasswordSuccess() when success != null:
return success(_that);case ChangePasswordError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChangePasswordInitial value)  initial,required TResult Function( ChangePasswordSaving value)  saving,required TResult Function( ChangePasswordSuccess value)  success,required TResult Function( ChangePasswordError value)  error,}){
final _that = this;
switch (_that) {
case ChangePasswordInitial():
return initial(_that);case ChangePasswordSaving():
return saving(_that);case ChangePasswordSuccess():
return success(_that);case ChangePasswordError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChangePasswordInitial value)?  initial,TResult? Function( ChangePasswordSaving value)?  saving,TResult? Function( ChangePasswordSuccess value)?  success,TResult? Function( ChangePasswordError value)?  error,}){
final _that = this;
switch (_that) {
case ChangePasswordInitial() when initial != null:
return initial(_that);case ChangePasswordSaving() when saving != null:
return saving(_that);case ChangePasswordSuccess() when success != null:
return success(_that);case ChangePasswordError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  saving,TResult Function()?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChangePasswordInitial() when initial != null:
return initial();case ChangePasswordSaving() when saving != null:
return saving();case ChangePasswordSuccess() when success != null:
return success();case ChangePasswordError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  saving,required TResult Function()  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ChangePasswordInitial():
return initial();case ChangePasswordSaving():
return saving();case ChangePasswordSuccess():
return success();case ChangePasswordError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  saving,TResult? Function()?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ChangePasswordInitial() when initial != null:
return initial();case ChangePasswordSaving() when saving != null:
return saving();case ChangePasswordSuccess() when success != null:
return success();case ChangePasswordError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChangePasswordInitial implements ChangePasswordState {
  const ChangePasswordInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePasswordState.initial()';
}


}




/// @nodoc


class ChangePasswordSaving implements ChangePasswordState {
  const ChangePasswordSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePasswordState.saving()';
}


}




/// @nodoc


class ChangePasswordSuccess implements ChangePasswordState {
  const ChangePasswordSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChangePasswordState.success()';
}


}




/// @nodoc


class ChangePasswordError implements ChangePasswordState {
  const ChangePasswordError({required this.message});
  

 final  String message;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePasswordErrorCopyWith<ChangePasswordError> get copyWith => _$ChangePasswordErrorCopyWithImpl<ChangePasswordError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePasswordError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ChangePasswordState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChangePasswordErrorCopyWith<$Res> implements $ChangePasswordStateCopyWith<$Res> {
  factory $ChangePasswordErrorCopyWith(ChangePasswordError value, $Res Function(ChangePasswordError) _then) = _$ChangePasswordErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChangePasswordErrorCopyWithImpl<$Res>
    implements $ChangePasswordErrorCopyWith<$Res> {
  _$ChangePasswordErrorCopyWithImpl(this._self, this._then);

  final ChangePasswordError _self;
  final $Res Function(ChangePasswordError) _then;

/// Create a copy of ChangePasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChangePasswordError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
