// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_section_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSectionModel {

 String get title; List<NotificationModel> get notifications;
/// Create a copy of NotificationSectionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSectionModelCopyWith<NotificationSectionModel> get copyWith => _$NotificationSectionModelCopyWithImpl<NotificationSectionModel>(this as NotificationSectionModel, _$identity);

  /// Serializes this NotificationSectionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSectionModel&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.notifications, notifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(notifications));

@override
String toString() {
  return 'NotificationSectionModel(title: $title, notifications: $notifications)';
}


}

/// @nodoc
abstract mixin class $NotificationSectionModelCopyWith<$Res>  {
  factory $NotificationSectionModelCopyWith(NotificationSectionModel value, $Res Function(NotificationSectionModel) _then) = _$NotificationSectionModelCopyWithImpl;
@useResult
$Res call({
 String title, List<NotificationModel> notifications
});




}
/// @nodoc
class _$NotificationSectionModelCopyWithImpl<$Res>
    implements $NotificationSectionModelCopyWith<$Res> {
  _$NotificationSectionModelCopyWithImpl(this._self, this._then);

  final NotificationSectionModel _self;
  final $Res Function(NotificationSectionModel) _then;

/// Create a copy of NotificationSectionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? notifications = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSectionModel].
extension NotificationSectionModelPatterns on NotificationSectionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSectionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSectionModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSectionModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSectionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSectionModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSectionModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<NotificationModel> notifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSectionModel() when $default != null:
return $default(_that.title,_that.notifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<NotificationModel> notifications)  $default,) {final _that = this;
switch (_that) {
case _NotificationSectionModel():
return $default(_that.title,_that.notifications);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<NotificationModel> notifications)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSectionModel() when $default != null:
return $default(_that.title,_that.notifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationSectionModel extends NotificationSectionModel {
  const _NotificationSectionModel({required this.title, required final  List<NotificationModel> notifications}): _notifications = notifications,super._();
  factory _NotificationSectionModel.fromJson(Map<String, dynamic> json) => _$NotificationSectionModelFromJson(json);

@override final  String title;
 final  List<NotificationModel> _notifications;
@override List<NotificationModel> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}


/// Create a copy of NotificationSectionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSectionModelCopyWith<_NotificationSectionModel> get copyWith => __$NotificationSectionModelCopyWithImpl<_NotificationSectionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationSectionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSectionModel&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._notifications, _notifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_notifications));

@override
String toString() {
  return 'NotificationSectionModel(title: $title, notifications: $notifications)';
}


}

/// @nodoc
abstract mixin class _$NotificationSectionModelCopyWith<$Res> implements $NotificationSectionModelCopyWith<$Res> {
  factory _$NotificationSectionModelCopyWith(_NotificationSectionModel value, $Res Function(_NotificationSectionModel) _then) = __$NotificationSectionModelCopyWithImpl;
@override @useResult
$Res call({
 String title, List<NotificationModel> notifications
});




}
/// @nodoc
class __$NotificationSectionModelCopyWithImpl<$Res>
    implements _$NotificationSectionModelCopyWith<$Res> {
  __$NotificationSectionModelCopyWithImpl(this._self, this._then);

  final _NotificationSectionModel _self;
  final $Res Function(_NotificationSectionModel) _then;

/// Create a copy of NotificationSectionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? notifications = null,}) {
  return _then(_NotificationSectionModel(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,
  ));
}


}

// dart format on
