// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddressEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent()';
}


}

/// @nodoc
class $AddressEventCopyWith<$Res>  {
$AddressEventCopyWith(AddressEvent _, $Res Function(AddressEvent) __);
}


/// Adds pattern-matching-related methods to [AddressEvent].
extension AddressEventPatterns on AddressEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressStarted value)?  started,TResult Function( AddressSelected value)?  selected,TResult Function( AddressSaved value)?  saved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressStarted() when started != null:
return started(_that);case AddressSelected() when selected != null:
return selected(_that);case AddressSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressStarted value)  started,required TResult Function( AddressSelected value)  selected,required TResult Function( AddressSaved value)  saved,}){
final _that = this;
switch (_that) {
case AddressStarted():
return started(_that);case AddressSelected():
return selected(_that);case AddressSaved():
return saved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressStarted value)?  started,TResult? Function( AddressSelected value)?  selected,TResult? Function( AddressSaved value)?  saved,}){
final _that = this;
switch (_that) {
case AddressStarted() when started != null:
return started(_that);case AddressSelected() when selected != null:
return selected(_that);case AddressSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String addressId)?  selected,TResult Function( AddressEntity address)?  saved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressStarted() when started != null:
return started();case AddressSelected() when selected != null:
return selected(_that.addressId);case AddressSaved() when saved != null:
return saved(_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String addressId)  selected,required TResult Function( AddressEntity address)  saved,}) {final _that = this;
switch (_that) {
case AddressStarted():
return started();case AddressSelected():
return selected(_that.addressId);case AddressSaved():
return saved(_that.address);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String addressId)?  selected,TResult? Function( AddressEntity address)?  saved,}) {final _that = this;
switch (_that) {
case AddressStarted() when started != null:
return started();case AddressSelected() when selected != null:
return selected(_that.addressId);case AddressSaved() when saved != null:
return saved(_that.address);case _:
  return null;

}
}

}

/// @nodoc


class AddressStarted implements AddressEvent {
  const AddressStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressEvent.started()';
}


}




/// @nodoc


class AddressSelected implements AddressEvent {
  const AddressSelected({required this.addressId});
  

 final  String addressId;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressSelectedCopyWith<AddressSelected> get copyWith => _$AddressSelectedCopyWithImpl<AddressSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressSelected&&(identical(other.addressId, addressId) || other.addressId == addressId));
}


@override
int get hashCode => Object.hash(runtimeType,addressId);

@override
String toString() {
  return 'AddressEvent.selected(addressId: $addressId)';
}


}

/// @nodoc
abstract mixin class $AddressSelectedCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory $AddressSelectedCopyWith(AddressSelected value, $Res Function(AddressSelected) _then) = _$AddressSelectedCopyWithImpl;
@useResult
$Res call({
 String addressId
});




}
/// @nodoc
class _$AddressSelectedCopyWithImpl<$Res>
    implements $AddressSelectedCopyWith<$Res> {
  _$AddressSelectedCopyWithImpl(this._self, this._then);

  final AddressSelected _self;
  final $Res Function(AddressSelected) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addressId = null,}) {
  return _then(AddressSelected(
addressId: null == addressId ? _self.addressId : addressId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddressSaved implements AddressEvent {
  const AddressSaved({required this.address});
  

 final  AddressEntity address;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressSavedCopyWith<AddressSaved> get copyWith => _$AddressSavedCopyWithImpl<AddressSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressSaved&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AddressEvent.saved(address: $address)';
}


}

/// @nodoc
abstract mixin class $AddressSavedCopyWith<$Res> implements $AddressEventCopyWith<$Res> {
  factory $AddressSavedCopyWith(AddressSaved value, $Res Function(AddressSaved) _then) = _$AddressSavedCopyWithImpl;
@useResult
$Res call({
 AddressEntity address
});




}
/// @nodoc
class _$AddressSavedCopyWithImpl<$Res>
    implements $AddressSavedCopyWith<$Res> {
  _$AddressSavedCopyWithImpl(this._self, this._then);

  final AddressSaved _self;
  final $Res Function(AddressSaved) _then;

/// Create a copy of AddressEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,}) {
  return _then(AddressSaved(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as AddressEntity,
  ));
}


}

/// @nodoc
mixin _$AddressState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressState()';
}


}

/// @nodoc
class $AddressStateCopyWith<$Res>  {
$AddressStateCopyWith(AddressState _, $Res Function(AddressState) __);
}


/// Adds pattern-matching-related methods to [AddressState].
extension AddressStatePatterns on AddressState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AddressLoading value)?  loading,TResult Function( AddressLoaded value)?  loaded,TResult Function( AddressError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AddressLoading() when loading != null:
return loading(_that);case AddressLoaded() when loaded != null:
return loaded(_that);case AddressError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AddressLoading value)  loading,required TResult Function( AddressLoaded value)  loaded,required TResult Function( AddressError value)  error,}){
final _that = this;
switch (_that) {
case AddressLoading():
return loading(_that);case AddressLoaded():
return loaded(_that);case AddressError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AddressLoading value)?  loading,TResult? Function( AddressLoaded value)?  loaded,TResult? Function( AddressError value)?  error,}){
final _that = this;
switch (_that) {
case AddressLoading() when loading != null:
return loading(_that);case AddressLoaded() when loaded != null:
return loaded(_that);case AddressError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<AddressEntity> addresses,  String selectedAddressId)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AddressLoading() when loading != null:
return loading();case AddressLoaded() when loaded != null:
return loaded(_that.addresses,_that.selectedAddressId);case AddressError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<AddressEntity> addresses,  String selectedAddressId)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AddressLoading():
return loading();case AddressLoaded():
return loaded(_that.addresses,_that.selectedAddressId);case AddressError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<AddressEntity> addresses,  String selectedAddressId)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AddressLoading() when loading != null:
return loading();case AddressLoaded() when loaded != null:
return loaded(_that.addresses,_that.selectedAddressId);case AddressError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AddressLoading implements AddressState {
  const AddressLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AddressState.loading()';
}


}




/// @nodoc


class AddressLoaded implements AddressState {
  const AddressLoaded({required final  List<AddressEntity> addresses, required this.selectedAddressId}): _addresses = addresses;
  

 final  List<AddressEntity> _addresses;
 List<AddressEntity> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

 final  String selectedAddressId;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressLoadedCopyWith<AddressLoaded> get copyWith => _$AddressLoadedCopyWithImpl<AddressLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressLoaded&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.selectedAddressId, selectedAddressId) || other.selectedAddressId == selectedAddressId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_addresses),selectedAddressId);

@override
String toString() {
  return 'AddressState.loaded(addresses: $addresses, selectedAddressId: $selectedAddressId)';
}


}

/// @nodoc
abstract mixin class $AddressLoadedCopyWith<$Res> implements $AddressStateCopyWith<$Res> {
  factory $AddressLoadedCopyWith(AddressLoaded value, $Res Function(AddressLoaded) _then) = _$AddressLoadedCopyWithImpl;
@useResult
$Res call({
 List<AddressEntity> addresses, String selectedAddressId
});




}
/// @nodoc
class _$AddressLoadedCopyWithImpl<$Res>
    implements $AddressLoadedCopyWith<$Res> {
  _$AddressLoadedCopyWithImpl(this._self, this._then);

  final AddressLoaded _self;
  final $Res Function(AddressLoaded) _then;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addresses = null,Object? selectedAddressId = null,}) {
  return _then(AddressLoaded(
addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<AddressEntity>,selectedAddressId: null == selectedAddressId ? _self.selectedAddressId : selectedAddressId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AddressError implements AddressState {
  const AddressError({required this.message});
  

 final  String message;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressErrorCopyWith<AddressError> get copyWith => _$AddressErrorCopyWithImpl<AddressError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AddressState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AddressErrorCopyWith<$Res> implements $AddressStateCopyWith<$Res> {
  factory $AddressErrorCopyWith(AddressError value, $Res Function(AddressError) _then) = _$AddressErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AddressErrorCopyWithImpl<$Res>
    implements $AddressErrorCopyWith<$Res> {
  _$AddressErrorCopyWithImpl(this._self, this._then);

  final AddressError _self;
  final $Res Function(AddressError) _then;

/// Create a copy of AddressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AddressError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
