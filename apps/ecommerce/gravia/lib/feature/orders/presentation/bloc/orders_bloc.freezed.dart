// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orders_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrdersEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent()';
}


}

/// @nodoc
class $OrdersEventCopyWith<$Res>  {
$OrdersEventCopyWith(OrdersEvent _, $Res Function(OrdersEvent) __);
}


/// Adds pattern-matching-related methods to [OrdersEvent].
extension OrdersEventPatterns on OrdersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrdersStarted value)?  started,TResult Function( OrdersTabChanged value)?  tabChanged,TResult Function( OrdersCancelled value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrdersStarted() when started != null:
return started(_that);case OrdersTabChanged() when tabChanged != null:
return tabChanged(_that);case OrdersCancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrdersStarted value)  started,required TResult Function( OrdersTabChanged value)  tabChanged,required TResult Function( OrdersCancelled value)  cancelled,}){
final _that = this;
switch (_that) {
case OrdersStarted():
return started(_that);case OrdersTabChanged():
return tabChanged(_that);case OrdersCancelled():
return cancelled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrdersStarted value)?  started,TResult? Function( OrdersTabChanged value)?  tabChanged,TResult? Function( OrdersCancelled value)?  cancelled,}){
final _that = this;
switch (_that) {
case OrdersStarted() when started != null:
return started(_that);case OrdersTabChanged() when tabChanged != null:
return tabChanged(_that);case OrdersCancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( OrdersTab tab)?  tabChanged,TResult Function( String orderId)?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrdersStarted() when started != null:
return started();case OrdersTabChanged() when tabChanged != null:
return tabChanged(_that.tab);case OrdersCancelled() when cancelled != null:
return cancelled(_that.orderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( OrdersTab tab)  tabChanged,required TResult Function( String orderId)  cancelled,}) {final _that = this;
switch (_that) {
case OrdersStarted():
return started();case OrdersTabChanged():
return tabChanged(_that.tab);case OrdersCancelled():
return cancelled(_that.orderId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( OrdersTab tab)?  tabChanged,TResult? Function( String orderId)?  cancelled,}) {final _that = this;
switch (_that) {
case OrdersStarted() when started != null:
return started();case OrdersTabChanged() when tabChanged != null:
return tabChanged(_that.tab);case OrdersCancelled() when cancelled != null:
return cancelled(_that.orderId);case _:
  return null;

}
}

}

/// @nodoc


class OrdersStarted implements OrdersEvent {
  const OrdersStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersEvent.started()';
}


}




/// @nodoc


class OrdersTabChanged implements OrdersEvent {
  const OrdersTabChanged({required this.tab});
  

 final  OrdersTab tab;

/// Create a copy of OrdersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersTabChangedCopyWith<OrdersTabChanged> get copyWith => _$OrdersTabChangedCopyWithImpl<OrdersTabChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersTabChanged&&(identical(other.tab, tab) || other.tab == tab));
}


@override
int get hashCode => Object.hash(runtimeType,tab);

@override
String toString() {
  return 'OrdersEvent.tabChanged(tab: $tab)';
}


}

/// @nodoc
abstract mixin class $OrdersTabChangedCopyWith<$Res> implements $OrdersEventCopyWith<$Res> {
  factory $OrdersTabChangedCopyWith(OrdersTabChanged value, $Res Function(OrdersTabChanged) _then) = _$OrdersTabChangedCopyWithImpl;
@useResult
$Res call({
 OrdersTab tab
});




}
/// @nodoc
class _$OrdersTabChangedCopyWithImpl<$Res>
    implements $OrdersTabChangedCopyWith<$Res> {
  _$OrdersTabChangedCopyWithImpl(this._self, this._then);

  final OrdersTabChanged _self;
  final $Res Function(OrdersTabChanged) _then;

/// Create a copy of OrdersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tab = null,}) {
  return _then(OrdersTabChanged(
tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc


class OrdersCancelled implements OrdersEvent {
  const OrdersCancelled({required this.orderId});
  

 final  String orderId;

/// Create a copy of OrdersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersCancelledCopyWith<OrdersCancelled> get copyWith => _$OrdersCancelledCopyWithImpl<OrdersCancelled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersCancelled&&(identical(other.orderId, orderId) || other.orderId == orderId));
}


@override
int get hashCode => Object.hash(runtimeType,orderId);

@override
String toString() {
  return 'OrdersEvent.cancelled(orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $OrdersCancelledCopyWith<$Res> implements $OrdersEventCopyWith<$Res> {
  factory $OrdersCancelledCopyWith(OrdersCancelled value, $Res Function(OrdersCancelled) _then) = _$OrdersCancelledCopyWithImpl;
@useResult
$Res call({
 String orderId
});




}
/// @nodoc
class _$OrdersCancelledCopyWithImpl<$Res>
    implements $OrdersCancelledCopyWith<$Res> {
  _$OrdersCancelledCopyWithImpl(this._self, this._then);

  final OrdersCancelled _self;
  final $Res Function(OrdersCancelled) _then;

/// Create a copy of OrdersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = null,}) {
  return _then(OrdersCancelled(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OrdersState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState()';
}


}

/// @nodoc
class $OrdersStateCopyWith<$Res>  {
$OrdersStateCopyWith(OrdersState _, $Res Function(OrdersState) __);
}


/// Adds pattern-matching-related methods to [OrdersState].
extension OrdersStatePatterns on OrdersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OrdersLoading value)?  loading,TResult Function( OrdersLoaded value)?  loaded,TResult Function( OrdersError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading(_that);case OrdersLoaded() when loaded != null:
return loaded(_that);case OrdersError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OrdersLoading value)  loading,required TResult Function( OrdersLoaded value)  loaded,required TResult Function( OrdersError value)  error,}){
final _that = this;
switch (_that) {
case OrdersLoading():
return loading(_that);case OrdersLoaded():
return loaded(_that);case OrdersError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OrdersLoading value)?  loading,TResult? Function( OrdersLoaded value)?  loaded,TResult? Function( OrdersError value)?  error,}){
final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading(_that);case OrdersLoaded() when loaded != null:
return loaded(_that);case OrdersError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<OrderEntity> orders,  OrdersTab selectedTab)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading();case OrdersLoaded() when loaded != null:
return loaded(_that.orders,_that.selectedTab);case OrdersError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<OrderEntity> orders,  OrdersTab selectedTab)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case OrdersLoading():
return loading();case OrdersLoaded():
return loaded(_that.orders,_that.selectedTab);case OrdersError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<OrderEntity> orders,  OrdersTab selectedTab)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case OrdersLoading() when loading != null:
return loading();case OrdersLoaded() when loaded != null:
return loaded(_that.orders,_that.selectedTab);case OrdersError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class OrdersLoading implements OrdersState {
  const OrdersLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrdersState.loading()';
}


}




/// @nodoc


class OrdersLoaded implements OrdersState {
  const OrdersLoaded({required final  List<OrderEntity> orders, required this.selectedTab}): _orders = orders;
  

 final  List<OrderEntity> _orders;
 List<OrderEntity> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

 final  OrdersTab selectedTab;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersLoadedCopyWith<OrdersLoaded> get copyWith => _$OrdersLoadedCopyWithImpl<OrdersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersLoaded&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.selectedTab, selectedTab) || other.selectedTab == selectedTab));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders),selectedTab);

@override
String toString() {
  return 'OrdersState.loaded(orders: $orders, selectedTab: $selectedTab)';
}


}

/// @nodoc
abstract mixin class $OrdersLoadedCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory $OrdersLoadedCopyWith(OrdersLoaded value, $Res Function(OrdersLoaded) _then) = _$OrdersLoadedCopyWithImpl;
@useResult
$Res call({
 List<OrderEntity> orders, OrdersTab selectedTab
});




}
/// @nodoc
class _$OrdersLoadedCopyWithImpl<$Res>
    implements $OrdersLoadedCopyWith<$Res> {
  _$OrdersLoadedCopyWithImpl(this._self, this._then);

  final OrdersLoaded _self;
  final $Res Function(OrdersLoaded) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orders = null,Object? selectedTab = null,}) {
  return _then(OrdersLoaded(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<OrderEntity>,selectedTab: null == selectedTab ? _self.selectedTab : selectedTab // ignore: cast_nullable_to_non_nullable
as OrdersTab,
  ));
}


}

/// @nodoc


class OrdersError implements OrdersState {
  const OrdersError({required this.message});
  

 final  String message;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdersErrorCopyWith<OrdersError> get copyWith => _$OrdersErrorCopyWithImpl<OrdersError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdersError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OrdersState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $OrdersErrorCopyWith<$Res> implements $OrdersStateCopyWith<$Res> {
  factory $OrdersErrorCopyWith(OrdersError value, $Res Function(OrdersError) _then) = _$OrdersErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OrdersErrorCopyWithImpl<$Res>
    implements $OrdersErrorCopyWith<$Res> {
  _$OrdersErrorCopyWithImpl(this._self, this._then);

  final OrdersError _self;
  final $Res Function(OrdersError) _then;

/// Create a copy of OrdersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(OrdersError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
