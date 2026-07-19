// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileEvent {

 String get name; String get mobile;
/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileEventCopyWith<EditProfileEvent> get copyWith => _$EditProfileEventCopyWithImpl<EditProfileEvent>(this as EditProfileEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEvent&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile));
}


@override
int get hashCode => Object.hash(runtimeType,name,mobile);

@override
String toString() {
  return 'EditProfileEvent(name: $name, mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class $EditProfileEventCopyWith<$Res>  {
  factory $EditProfileEventCopyWith(EditProfileEvent value, $Res Function(EditProfileEvent) _then) = _$EditProfileEventCopyWithImpl;
@useResult
$Res call({
 String name, String mobile
});




}
/// @nodoc
class _$EditProfileEventCopyWithImpl<$Res>
    implements $EditProfileEventCopyWith<$Res> {
  _$EditProfileEventCopyWithImpl(this._self, this._then);

  final EditProfileEvent _self;
  final $Res Function(EditProfileEvent) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? mobile = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileEvent].
extension EditProfileEventPatterns on EditProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProfileSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProfileSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case EditProfileSubmitted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProfileSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name,  String mobile)?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
return submitted(_that.name,_that.mobile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name,  String mobile)  submitted,}) {final _that = this;
switch (_that) {
case EditProfileSubmitted():
return submitted(_that.name,_that.mobile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name,  String mobile)?  submitted,}) {final _that = this;
switch (_that) {
case EditProfileSubmitted() when submitted != null:
return submitted(_that.name,_that.mobile);case _:
  return null;

}
}

}

/// @nodoc


class EditProfileSubmitted implements EditProfileEvent {
  const EditProfileSubmitted({required this.name, required this.mobile});
  

@override final  String name;
@override final  String mobile;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileSubmittedCopyWith<EditProfileSubmitted> get copyWith => _$EditProfileSubmittedCopyWithImpl<EditProfileSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSubmitted&&(identical(other.name, name) || other.name == name)&&(identical(other.mobile, mobile) || other.mobile == mobile));
}


@override
int get hashCode => Object.hash(runtimeType,name,mobile);

@override
String toString() {
  return 'EditProfileEvent.submitted(name: $name, mobile: $mobile)';
}


}

/// @nodoc
abstract mixin class $EditProfileSubmittedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory $EditProfileSubmittedCopyWith(EditProfileSubmitted value, $Res Function(EditProfileSubmitted) _then) = _$EditProfileSubmittedCopyWithImpl;
@override @useResult
$Res call({
 String name, String mobile
});




}
/// @nodoc
class _$EditProfileSubmittedCopyWithImpl<$Res>
    implements $EditProfileSubmittedCopyWith<$Res> {
  _$EditProfileSubmittedCopyWithImpl(this._self, this._then);

  final EditProfileSubmitted _self;
  final $Res Function(EditProfileSubmitted) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? mobile = null,}) {
  return _then(EditProfileSubmitted(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EditProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState()';
}


}

/// @nodoc
class $EditProfileStateCopyWith<$Res>  {
$EditProfileStateCopyWith(EditProfileState _, $Res Function(EditProfileState) __);
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( EditProfileInitial value)?  initial,TResult Function( EditProfileSaving value)?  saving,TResult Function( EditProfileSuccess value)?  success,TResult Function( EditProfileError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial(_that);case EditProfileSaving() when saving != null:
return saving(_that);case EditProfileSuccess() when success != null:
return success(_that);case EditProfileError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( EditProfileInitial value)  initial,required TResult Function( EditProfileSaving value)  saving,required TResult Function( EditProfileSuccess value)  success,required TResult Function( EditProfileError value)  error,}){
final _that = this;
switch (_that) {
case EditProfileInitial():
return initial(_that);case EditProfileSaving():
return saving(_that);case EditProfileSuccess():
return success(_that);case EditProfileError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( EditProfileInitial value)?  initial,TResult? Function( EditProfileSaving value)?  saving,TResult? Function( EditProfileSuccess value)?  success,TResult? Function( EditProfileError value)?  error,}){
final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial(_that);case EditProfileSaving() when saving != null:
return saving(_that);case EditProfileSuccess() when success != null:
return success(_that);case EditProfileError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  saving,TResult Function( UserEntity user)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial();case EditProfileSaving() when saving != null:
return saving();case EditProfileSuccess() when success != null:
return success(_that.user);case EditProfileError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  saving,required TResult Function( UserEntity user)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case EditProfileInitial():
return initial();case EditProfileSaving():
return saving();case EditProfileSuccess():
return success(_that.user);case EditProfileError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  saving,TResult? Function( UserEntity user)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case EditProfileInitial() when initial != null:
return initial();case EditProfileSaving() when saving != null:
return saving();case EditProfileSuccess() when success != null:
return success(_that.user);case EditProfileError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class EditProfileInitial implements EditProfileState {
  const EditProfileInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState.initial()';
}


}




/// @nodoc


class EditProfileSaving implements EditProfileState {
  const EditProfileSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileState.saving()';
}


}




/// @nodoc


class EditProfileSuccess implements EditProfileState {
  const EditProfileSuccess({required this.user});
  

 final  UserEntity user;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileSuccessCopyWith<EditProfileSuccess> get copyWith => _$EditProfileSuccessCopyWithImpl<EditProfileSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileSuccess&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'EditProfileState.success(user: $user)';
}


}

/// @nodoc
abstract mixin class $EditProfileSuccessCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileSuccessCopyWith(EditProfileSuccess value, $Res Function(EditProfileSuccess) _then) = _$EditProfileSuccessCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class _$EditProfileSuccessCopyWithImpl<$Res>
    implements $EditProfileSuccessCopyWith<$Res> {
  _$EditProfileSuccessCopyWithImpl(this._self, this._then);

  final EditProfileSuccess _self;
  final $Res Function(EditProfileSuccess) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(EditProfileSuccess(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class EditProfileError implements EditProfileState {
  const EditProfileError({required this.message});
  

 final  String message;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileErrorCopyWith<EditProfileError> get copyWith => _$EditProfileErrorCopyWithImpl<EditProfileError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'EditProfileState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $EditProfileErrorCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory $EditProfileErrorCopyWith(EditProfileError value, $Res Function(EditProfileError) _then) = _$EditProfileErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$EditProfileErrorCopyWithImpl<$Res>
    implements $EditProfileErrorCopyWith<$Res> {
  _$EditProfileErrorCopyWithImpl(this._self, this._then);

  final EditProfileError _self;
  final $Res Function(EditProfileError) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(EditProfileError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
