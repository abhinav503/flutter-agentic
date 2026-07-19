// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthStarted value)?  started,TResult Function( AuthSignUpRequested value)?  signUpRequested,TResult Function( AuthLoginRequested value)?  loginRequested,TResult Function( AuthResendVerificationRequested value)?  resendVerificationRequested,TResult Function( AuthForgotPasswordRequested value)?  forgotPasswordRequested,TResult Function( AuthVerificationTicked value)?  verificationTicked,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthSignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that);case AuthResendVerificationRequested() when resendVerificationRequested != null:
return resendVerificationRequested(_that);case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
return forgotPasswordRequested(_that);case AuthVerificationTicked() when verificationTicked != null:
return verificationTicked(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthStarted value)  started,required TResult Function( AuthSignUpRequested value)  signUpRequested,required TResult Function( AuthLoginRequested value)  loginRequested,required TResult Function( AuthResendVerificationRequested value)  resendVerificationRequested,required TResult Function( AuthForgotPasswordRequested value)  forgotPasswordRequested,required TResult Function( AuthVerificationTicked value)  verificationTicked,}){
final _that = this;
switch (_that) {
case AuthStarted():
return started(_that);case AuthSignUpRequested():
return signUpRequested(_that);case AuthLoginRequested():
return loginRequested(_that);case AuthResendVerificationRequested():
return resendVerificationRequested(_that);case AuthForgotPasswordRequested():
return forgotPasswordRequested(_that);case AuthVerificationTicked():
return verificationTicked(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthStarted value)?  started,TResult? Function( AuthSignUpRequested value)?  signUpRequested,TResult? Function( AuthLoginRequested value)?  loginRequested,TResult? Function( AuthResendVerificationRequested value)?  resendVerificationRequested,TResult? Function( AuthForgotPasswordRequested value)?  forgotPasswordRequested,TResult? Function( AuthVerificationTicked value)?  verificationTicked,}){
final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started(_that);case AuthSignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that);case AuthResendVerificationRequested() when resendVerificationRequested != null:
return resendVerificationRequested(_that);case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
return forgotPasswordRequested(_that);case AuthVerificationTicked() when verificationTicked != null:
return verificationTicked(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String name,  String email,  String mobile,  String password)?  signUpRequested,TResult Function( String email,  String password)?  loginRequested,TResult Function()?  resendVerificationRequested,TResult Function( String email)?  forgotPasswordRequested,TResult Function()?  verificationTicked,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthSignUpRequested() when signUpRequested != null:
return signUpRequested(_that.name,_that.email,_that.mobile,_that.password);case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password);case AuthResendVerificationRequested() when resendVerificationRequested != null:
return resendVerificationRequested();case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
return forgotPasswordRequested(_that.email);case AuthVerificationTicked() when verificationTicked != null:
return verificationTicked();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String name,  String email,  String mobile,  String password)  signUpRequested,required TResult Function( String email,  String password)  loginRequested,required TResult Function()  resendVerificationRequested,required TResult Function( String email)  forgotPasswordRequested,required TResult Function()  verificationTicked,}) {final _that = this;
switch (_that) {
case AuthStarted():
return started();case AuthSignUpRequested():
return signUpRequested(_that.name,_that.email,_that.mobile,_that.password);case AuthLoginRequested():
return loginRequested(_that.email,_that.password);case AuthResendVerificationRequested():
return resendVerificationRequested();case AuthForgotPasswordRequested():
return forgotPasswordRequested(_that.email);case AuthVerificationTicked():
return verificationTicked();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String name,  String email,  String mobile,  String password)?  signUpRequested,TResult? Function( String email,  String password)?  loginRequested,TResult? Function()?  resendVerificationRequested,TResult? Function( String email)?  forgotPasswordRequested,TResult? Function()?  verificationTicked,}) {final _that = this;
switch (_that) {
case AuthStarted() when started != null:
return started();case AuthSignUpRequested() when signUpRequested != null:
return signUpRequested(_that.name,_that.email,_that.mobile,_that.password);case AuthLoginRequested() when loginRequested != null:
return loginRequested(_that.email,_that.password);case AuthResendVerificationRequested() when resendVerificationRequested != null:
return resendVerificationRequested();case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
return forgotPasswordRequested(_that.email);case AuthVerificationTicked() when verificationTicked != null:
return verificationTicked();case _:
  return null;

}
}

}

/// @nodoc


class AuthStarted implements AuthEvent {
  const AuthStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.started()';
}


}




/// @nodoc


class AuthSignUpRequested implements AuthEvent {
  const AuthSignUpRequested({required this.name, required this.email, required this.mobile, required this.password});
  

 final  String name;
 final  String email;
 final  String mobile;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthSignUpRequestedCopyWith<AuthSignUpRequested> get copyWith => _$AuthSignUpRequestedCopyWithImpl<AuthSignUpRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthSignUpRequested&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.mobile, mobile) || other.mobile == mobile)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,mobile,password);

@override
String toString() {
  return 'AuthEvent.signUpRequested(name: $name, email: $email, mobile: $mobile, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthSignUpRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthSignUpRequestedCopyWith(AuthSignUpRequested value, $Res Function(AuthSignUpRequested) _then) = _$AuthSignUpRequestedCopyWithImpl;
@useResult
$Res call({
 String name, String email, String mobile, String password
});




}
/// @nodoc
class _$AuthSignUpRequestedCopyWithImpl<$Res>
    implements $AuthSignUpRequestedCopyWith<$Res> {
  _$AuthSignUpRequestedCopyWithImpl(this._self, this._then);

  final AuthSignUpRequested _self;
  final $Res Function(AuthSignUpRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? mobile = null,Object? password = null,}) {
  return _then(AuthSignUpRequested(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,mobile: null == mobile ? _self.mobile : mobile // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthLoginRequested implements AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthLoginRequestedCopyWith<AuthLoginRequested> get copyWith => _$AuthLoginRequestedCopyWithImpl<AuthLoginRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoginRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.loginRequested(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthLoginRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthLoginRequestedCopyWith(AuthLoginRequested value, $Res Function(AuthLoginRequested) _then) = _$AuthLoginRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$AuthLoginRequestedCopyWithImpl<$Res>
    implements $AuthLoginRequestedCopyWith<$Res> {
  _$AuthLoginRequestedCopyWithImpl(this._self, this._then);

  final AuthLoginRequested _self;
  final $Res Function(AuthLoginRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(AuthLoginRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthResendVerificationRequested implements AuthEvent {
  const AuthResendVerificationRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthResendVerificationRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.resendVerificationRequested()';
}


}




/// @nodoc


class AuthForgotPasswordRequested implements AuthEvent {
  const AuthForgotPasswordRequested({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthForgotPasswordRequestedCopyWith<AuthForgotPasswordRequested> get copyWith => _$AuthForgotPasswordRequestedCopyWithImpl<AuthForgotPasswordRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthForgotPasswordRequested&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.forgotPasswordRequested(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthForgotPasswordRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthForgotPasswordRequestedCopyWith(AuthForgotPasswordRequested value, $Res Function(AuthForgotPasswordRequested) _then) = _$AuthForgotPasswordRequestedCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthForgotPasswordRequestedCopyWithImpl<$Res>
    implements $AuthForgotPasswordRequestedCopyWith<$Res> {
  _$AuthForgotPasswordRequestedCopyWithImpl(this._self, this._then);

  final AuthForgotPasswordRequested _self;
  final $Res Function(AuthForgotPasswordRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthForgotPasswordRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthVerificationTicked implements AuthEvent {
  const AuthVerificationTicked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthVerificationTicked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.verificationTicked()';
}


}




/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInitial value)?  initial,TResult Function( AuthLoading value)?  loading,TResult Function( AuthAwaitingVerification value)?  awaitingVerification,TResult Function( AuthAuthenticated value)?  authenticated,TResult Function( AuthUnauthenticated value)?  unauthenticated,TResult Function( AuthPasswordResetEmailSent value)?  passwordResetEmailSent,TResult Function( AuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case AuthAwaitingVerification() when awaitingVerification != null:
return awaitingVerification(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case AuthError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInitial value)  initial,required TResult Function( AuthLoading value)  loading,required TResult Function( AuthAwaitingVerification value)  awaitingVerification,required TResult Function( AuthAuthenticated value)  authenticated,required TResult Function( AuthUnauthenticated value)  unauthenticated,required TResult Function( AuthPasswordResetEmailSent value)  passwordResetEmailSent,required TResult Function( AuthError value)  error,}){
final _that = this;
switch (_that) {
case AuthInitial():
return initial(_that);case AuthLoading():
return loading(_that);case AuthAwaitingVerification():
return awaitingVerification(_that);case AuthAuthenticated():
return authenticated(_that);case AuthUnauthenticated():
return unauthenticated(_that);case AuthPasswordResetEmailSent():
return passwordResetEmailSent(_that);case AuthError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInitial value)?  initial,TResult? Function( AuthLoading value)?  loading,TResult? Function( AuthAwaitingVerification value)?  awaitingVerification,TResult? Function( AuthAuthenticated value)?  authenticated,TResult? Function( AuthUnauthenticated value)?  unauthenticated,TResult? Function( AuthPasswordResetEmailSent value)?  passwordResetEmailSent,TResult? Function( AuthError value)?  error,}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case AuthAwaitingVerification() when awaitingVerification != null:
return awaitingVerification(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that);case AuthError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String email)?  awaitingVerification,TResult Function( UserEntity user)?  authenticated,TResult Function()?  unauthenticated,TResult Function( String email)?  passwordResetEmailSent,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case AuthAwaitingVerification() when awaitingVerification != null:
return awaitingVerification(_that.email);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that.email);case AuthError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String email)  awaitingVerification,required TResult Function( UserEntity user)  authenticated,required TResult Function()  unauthenticated,required TResult Function( String email)  passwordResetEmailSent,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AuthInitial():
return initial();case AuthLoading():
return loading();case AuthAwaitingVerification():
return awaitingVerification(_that.email);case AuthAuthenticated():
return authenticated(_that.user);case AuthUnauthenticated():
return unauthenticated();case AuthPasswordResetEmailSent():
return passwordResetEmailSent(_that.email);case AuthError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String email)?  awaitingVerification,TResult? Function( UserEntity user)?  authenticated,TResult? Function()?  unauthenticated,TResult? Function( String email)?  passwordResetEmailSent,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case AuthAwaitingVerification() when awaitingVerification != null:
return awaitingVerification(_that.email);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthPasswordResetEmailSent() when passwordResetEmailSent != null:
return passwordResetEmailSent(_that.email);case AuthError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthInitial implements AuthState {
  const AuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class AuthLoading implements AuthState {
  const AuthLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class AuthAwaitingVerification implements AuthState {
  const AuthAwaitingVerification({required this.email});
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAwaitingVerificationCopyWith<AuthAwaitingVerification> get copyWith => _$AuthAwaitingVerificationCopyWithImpl<AuthAwaitingVerification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAwaitingVerification&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthState.awaitingVerification(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthAwaitingVerificationCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAwaitingVerificationCopyWith(AuthAwaitingVerification value, $Res Function(AuthAwaitingVerification) _then) = _$AuthAwaitingVerificationCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthAwaitingVerificationCopyWithImpl<$Res>
    implements $AuthAwaitingVerificationCopyWith<$Res> {
  _$AuthAwaitingVerificationCopyWithImpl(this._self, this._then);

  final AuthAwaitingVerification _self;
  final $Res Function(AuthAwaitingVerification) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthAwaitingVerification(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthAuthenticated implements AuthState {
  const AuthAuthenticated({required this.user});
  

 final  UserEntity user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith => _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAuthenticated&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) = _$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserEntity user
});




}
/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(AuthAuthenticated(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserEntity,
  ));
}


}

/// @nodoc


class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class AuthPasswordResetEmailSent implements AuthState {
  const AuthPasswordResetEmailSent({required this.email});
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthPasswordResetEmailSentCopyWith<AuthPasswordResetEmailSent> get copyWith => _$AuthPasswordResetEmailSentCopyWithImpl<AuthPasswordResetEmailSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthPasswordResetEmailSent&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthState.passwordResetEmailSent(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthPasswordResetEmailSentCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthPasswordResetEmailSentCopyWith(AuthPasswordResetEmailSent value, $Res Function(AuthPasswordResetEmailSent) _then) = _$AuthPasswordResetEmailSentCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthPasswordResetEmailSentCopyWithImpl<$Res>
    implements $AuthPasswordResetEmailSentCopyWith<$Res> {
  _$AuthPasswordResetEmailSentCopyWithImpl(this._self, this._then);

  final AuthPasswordResetEmailSent _self;
  final $Res Function(AuthPasswordResetEmailSent) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthPasswordResetEmailSent(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthError implements AuthState {
  const AuthError({required this.message});
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
