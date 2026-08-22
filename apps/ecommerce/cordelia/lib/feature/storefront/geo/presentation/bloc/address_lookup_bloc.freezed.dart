// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_lookup_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressLookupEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressLookupEvent()';
}


}

/// @nodoc
class $AddressLookupEventCopyWith<$Res>  {
$AddressLookupEventCopyWith(AddressLookupEvent _, $Res Function(AddressLookupEvent) __);
}


/// Adds pattern-matching-related methods to [AddressLookupEvent].
extension AddressLookupEventPatterns on AddressLookupEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressLookupLocationRequested value)?  locationRequested,TResult Function( AddressLookupPincodeEntered value)?  pincodeEntered,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressLookupLocationRequested() when locationRequested != null:
return locationRequested(_that);case AddressLookupPincodeEntered() when pincodeEntered != null:
return pincodeEntered(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressLookupLocationRequested value)  locationRequested,required TResult Function( AddressLookupPincodeEntered value)  pincodeEntered,}){
final _that = this;
switch (_that) {
case AddressLookupLocationRequested():
return locationRequested(_that);case AddressLookupPincodeEntered():
return pincodeEntered(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressLookupLocationRequested value)?  locationRequested,TResult? Function( AddressLookupPincodeEntered value)?  pincodeEntered,}){
final _that = this;
switch (_that) {
case AddressLookupLocationRequested() when locationRequested != null:
return locationRequested(_that);case AddressLookupPincodeEntered() when pincodeEntered != null:
return pincodeEntered(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  locationRequested,TResult Function( String pincode)?  pincodeEntered,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressLookupLocationRequested() when locationRequested != null:
return locationRequested();case AddressLookupPincodeEntered() when pincodeEntered != null:
return pincodeEntered(_that.pincode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  locationRequested,required TResult Function( String pincode)  pincodeEntered,}) {final _that = this;
switch (_that) {
case AddressLookupLocationRequested():
return locationRequested();case AddressLookupPincodeEntered():
return pincodeEntered(_that.pincode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  locationRequested,TResult? Function( String pincode)?  pincodeEntered,}) {final _that = this;
switch (_that) {
case AddressLookupLocationRequested() when locationRequested != null:
return locationRequested();case AddressLookupPincodeEntered() when pincodeEntered != null:
return pincodeEntered(_that.pincode);case _:
  return null;

}
}

}

/// @nodoc


class AddressLookupLocationRequested implements AddressLookupEvent {
  const AddressLookupLocationRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupLocationRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressLookupEvent.locationRequested()';
}


}




/// @nodoc


class AddressLookupPincodeEntered implements AddressLookupEvent {
  const AddressLookupPincodeEntered({required this.pincode});
  

 final  String pincode;

/// Create a copy of AddressLookupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressLookupPincodeEnteredCopyWith<AddressLookupPincodeEntered> get copyWith => _$AddressLookupPincodeEnteredCopyWithImpl<AddressLookupPincodeEntered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupPincodeEntered&&(identical(other.pincode, pincode) || other.pincode == pincode));
}


@override
int get hashCode => Object.hash(runtimeType,pincode);

@override
String toString() {
  return 'AddressLookupEvent.pincodeEntered(pincode: $pincode)';
}


}

/// @nodoc
abstract mixin class $AddressLookupPincodeEnteredCopyWith<$Res> implements $AddressLookupEventCopyWith<$Res> {
  factory $AddressLookupPincodeEnteredCopyWith(AddressLookupPincodeEntered value, $Res Function(AddressLookupPincodeEntered) _then) = _$AddressLookupPincodeEnteredCopyWithImpl;
@useResult
$Res call({
 String pincode
});




}
/// @nodoc
class _$AddressLookupPincodeEnteredCopyWithImpl<$Res>
    implements $AddressLookupPincodeEnteredCopyWith<$Res> {
  _$AddressLookupPincodeEnteredCopyWithImpl(this._self, this._then);

  final AddressLookupPincodeEntered _self;
  final $Res Function(AddressLookupPincodeEntered) _then;

/// Create a copy of AddressLookupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pincode = null,}) {
  return _then(AddressLookupPincodeEntered(
pincode: null == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AddressLookupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressLookupState()';
}


}

/// @nodoc
class $AddressLookupStateCopyWith<$Res>  {
$AddressLookupStateCopyWith(AddressLookupState _, $Res Function(AddressLookupState) __);
}


/// Adds pattern-matching-related methods to [AddressLookupState].
extension AddressLookupStatePatterns on AddressLookupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressLookupIdle value)?  idle,TResult Function( AddressLookupLocating value)?  locating,TResult Function( AddressLookupPrefillReady value)?  prefillReady,TResult Function( AddressLookupPincodeReady value)?  pincodeReady,TResult Function( AddressLookupError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressLookupIdle() when idle != null:
return idle(_that);case AddressLookupLocating() when locating != null:
return locating(_that);case AddressLookupPrefillReady() when prefillReady != null:
return prefillReady(_that);case AddressLookupPincodeReady() when pincodeReady != null:
return pincodeReady(_that);case AddressLookupError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressLookupIdle value)  idle,required TResult Function( AddressLookupLocating value)  locating,required TResult Function( AddressLookupPrefillReady value)  prefillReady,required TResult Function( AddressLookupPincodeReady value)  pincodeReady,required TResult Function( AddressLookupError value)  error,}){
final _that = this;
switch (_that) {
case AddressLookupIdle():
return idle(_that);case AddressLookupLocating():
return locating(_that);case AddressLookupPrefillReady():
return prefillReady(_that);case AddressLookupPincodeReady():
return pincodeReady(_that);case AddressLookupError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressLookupIdle value)?  idle,TResult? Function( AddressLookupLocating value)?  locating,TResult? Function( AddressLookupPrefillReady value)?  prefillReady,TResult? Function( AddressLookupPincodeReady value)?  pincodeReady,TResult? Function( AddressLookupError value)?  error,}){
final _that = this;
switch (_that) {
case AddressLookupIdle() when idle != null:
return idle(_that);case AddressLookupLocating() when locating != null:
return locating(_that);case AddressLookupPrefillReady() when prefillReady != null:
return prefillReady(_that);case AddressLookupPincodeReady() when pincodeReady != null:
return pincodeReady(_that);case AddressLookupError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  locating,TResult Function( GeoAddressEntity address)?  prefillReady,TResult Function( PincodeInfoEntity info)?  pincodeReady,TResult Function( String message,  bool isLocation)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressLookupIdle() when idle != null:
return idle();case AddressLookupLocating() when locating != null:
return locating();case AddressLookupPrefillReady() when prefillReady != null:
return prefillReady(_that.address);case AddressLookupPincodeReady() when pincodeReady != null:
return pincodeReady(_that.info);case AddressLookupError() when error != null:
return error(_that.message,_that.isLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  locating,required TResult Function( GeoAddressEntity address)  prefillReady,required TResult Function( PincodeInfoEntity info)  pincodeReady,required TResult Function( String message,  bool isLocation)  error,}) {final _that = this;
switch (_that) {
case AddressLookupIdle():
return idle();case AddressLookupLocating():
return locating();case AddressLookupPrefillReady():
return prefillReady(_that.address);case AddressLookupPincodeReady():
return pincodeReady(_that.info);case AddressLookupError():
return error(_that.message,_that.isLocation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  locating,TResult? Function( GeoAddressEntity address)?  prefillReady,TResult? Function( PincodeInfoEntity info)?  pincodeReady,TResult? Function( String message,  bool isLocation)?  error,}) {final _that = this;
switch (_that) {
case AddressLookupIdle() when idle != null:
return idle();case AddressLookupLocating() when locating != null:
return locating();case AddressLookupPrefillReady() when prefillReady != null:
return prefillReady(_that.address);case AddressLookupPincodeReady() when pincodeReady != null:
return pincodeReady(_that.info);case AddressLookupError() when error != null:
return error(_that.message,_that.isLocation);case _:
  return null;

}
}

}

/// @nodoc


class AddressLookupIdle implements AddressLookupState {
  const AddressLookupIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressLookupState.idle()';
}


}




/// @nodoc


class AddressLookupLocating implements AddressLookupState {
  const AddressLookupLocating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupLocating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressLookupState.locating()';
}


}




/// @nodoc


class AddressLookupPrefillReady implements AddressLookupState {
  const AddressLookupPrefillReady({required this.address});
  

 final  GeoAddressEntity address;

/// Create a copy of AddressLookupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressLookupPrefillReadyCopyWith<AddressLookupPrefillReady> get copyWith => _$AddressLookupPrefillReadyCopyWithImpl<AddressLookupPrefillReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupPrefillReady&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AddressLookupState.prefillReady(address: $address)';
}


}

/// @nodoc
abstract mixin class $AddressLookupPrefillReadyCopyWith<$Res> implements $AddressLookupStateCopyWith<$Res> {
  factory $AddressLookupPrefillReadyCopyWith(AddressLookupPrefillReady value, $Res Function(AddressLookupPrefillReady) _then) = _$AddressLookupPrefillReadyCopyWithImpl;
@useResult
$Res call({
 GeoAddressEntity address
});




}
/// @nodoc
class _$AddressLookupPrefillReadyCopyWithImpl<$Res>
    implements $AddressLookupPrefillReadyCopyWith<$Res> {
  _$AddressLookupPrefillReadyCopyWithImpl(this._self, this._then);

  final AddressLookupPrefillReady _self;
  final $Res Function(AddressLookupPrefillReady) _then;

/// Create a copy of AddressLookupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,}) {
  return _then(AddressLookupPrefillReady(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as GeoAddressEntity,
  ));
}


}

/// @nodoc


class AddressLookupPincodeReady implements AddressLookupState {
  const AddressLookupPincodeReady({required this.info});
  

 final  PincodeInfoEntity info;

/// Create a copy of AddressLookupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressLookupPincodeReadyCopyWith<AddressLookupPincodeReady> get copyWith => _$AddressLookupPincodeReadyCopyWithImpl<AddressLookupPincodeReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupPincodeReady&&(identical(other.info, info) || other.info == info));
}


@override
int get hashCode => Object.hash(runtimeType,info);

@override
String toString() {
  return 'AddressLookupState.pincodeReady(info: $info)';
}


}

/// @nodoc
abstract mixin class $AddressLookupPincodeReadyCopyWith<$Res> implements $AddressLookupStateCopyWith<$Res> {
  factory $AddressLookupPincodeReadyCopyWith(AddressLookupPincodeReady value, $Res Function(AddressLookupPincodeReady) _then) = _$AddressLookupPincodeReadyCopyWithImpl;
@useResult
$Res call({
 PincodeInfoEntity info
});




}
/// @nodoc
class _$AddressLookupPincodeReadyCopyWithImpl<$Res>
    implements $AddressLookupPincodeReadyCopyWith<$Res> {
  _$AddressLookupPincodeReadyCopyWithImpl(this._self, this._then);

  final AddressLookupPincodeReady _self;
  final $Res Function(AddressLookupPincodeReady) _then;

/// Create a copy of AddressLookupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,}) {
  return _then(AddressLookupPincodeReady(
info: null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as PincodeInfoEntity,
  ));
}


}

/// @nodoc


class AddressLookupError implements AddressLookupState {
  const AddressLookupError({required this.message, required this.isLocation});
  

 final  String message;
 final  bool isLocation;

/// Create a copy of AddressLookupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressLookupErrorCopyWith<AddressLookupError> get copyWith => _$AddressLookupErrorCopyWithImpl<AddressLookupError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLookupError&&(identical(other.message, message) || other.message == message)&&(identical(other.isLocation, isLocation) || other.isLocation == isLocation));
}


@override
int get hashCode => Object.hash(runtimeType,message,isLocation);

@override
String toString() {
  return 'AddressLookupState.error(message: $message, isLocation: $isLocation)';
}


}

/// @nodoc
abstract mixin class $AddressLookupErrorCopyWith<$Res> implements $AddressLookupStateCopyWith<$Res> {
  factory $AddressLookupErrorCopyWith(AddressLookupError value, $Res Function(AddressLookupError) _then) = _$AddressLookupErrorCopyWithImpl;
@useResult
$Res call({
 String message, bool isLocation
});




}
/// @nodoc
class _$AddressLookupErrorCopyWithImpl<$Res>
    implements $AddressLookupErrorCopyWith<$Res> {
  _$AddressLookupErrorCopyWithImpl(this._self, this._then);

  final AddressLookupError _self;
  final $Res Function(AddressLookupError) _then;

/// Create a copy of AddressLookupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? isLocation = null,}) {
  return _then(AddressLookupError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,isLocation: null == isLocation ? _self.isLocation : isLocation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
