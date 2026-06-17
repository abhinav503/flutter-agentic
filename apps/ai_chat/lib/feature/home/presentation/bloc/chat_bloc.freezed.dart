// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent()';
}


}

/// @nodoc
class $ChatEventCopyWith<$Res>  {
$ChatEventCopyWith(ChatEvent _, $Res Function(ChatEvent) __);
}


/// Adds pattern-matching-related methods to [ChatEvent].
extension ChatEventPatterns on ChatEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatStarted value)?  started,TResult Function( ChatSendPressed value)?  sendPressed,TResult Function( ChatStopPressed value)?  stopPressed,TResult Function( ChatRetryPressed value)?  retryPressed,TResult Function( ChatModeChanged value)?  modeChanged,TResult Function( ChatApiKeySaved value)?  apiKeySaved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started(_that);case ChatSendPressed() when sendPressed != null:
return sendPressed(_that);case ChatStopPressed() when stopPressed != null:
return stopPressed(_that);case ChatRetryPressed() when retryPressed != null:
return retryPressed(_that);case ChatModeChanged() when modeChanged != null:
return modeChanged(_that);case ChatApiKeySaved() when apiKeySaved != null:
return apiKeySaved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatStarted value)  started,required TResult Function( ChatSendPressed value)  sendPressed,required TResult Function( ChatStopPressed value)  stopPressed,required TResult Function( ChatRetryPressed value)  retryPressed,required TResult Function( ChatModeChanged value)  modeChanged,required TResult Function( ChatApiKeySaved value)  apiKeySaved,}){
final _that = this;
switch (_that) {
case ChatStarted():
return started(_that);case ChatSendPressed():
return sendPressed(_that);case ChatStopPressed():
return stopPressed(_that);case ChatRetryPressed():
return retryPressed(_that);case ChatModeChanged():
return modeChanged(_that);case ChatApiKeySaved():
return apiKeySaved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatStarted value)?  started,TResult? Function( ChatSendPressed value)?  sendPressed,TResult? Function( ChatStopPressed value)?  stopPressed,TResult? Function( ChatRetryPressed value)?  retryPressed,TResult? Function( ChatModeChanged value)?  modeChanged,TResult? Function( ChatApiKeySaved value)?  apiKeySaved,}){
final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started(_that);case ChatSendPressed() when sendPressed != null:
return sendPressed(_that);case ChatStopPressed() when stopPressed != null:
return stopPressed(_that);case ChatRetryPressed() when retryPressed != null:
return retryPressed(_that);case ChatModeChanged() when modeChanged != null:
return modeChanged(_that);case ChatApiKeySaved() when apiKeySaved != null:
return apiKeySaved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String prompt)?  sendPressed,TResult Function()?  stopPressed,TResult Function()?  retryPressed,TResult Function( ChatMode mode)?  modeChanged,TResult Function( String apiKey)?  apiKeySaved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started();case ChatSendPressed() when sendPressed != null:
return sendPressed(_that.prompt);case ChatStopPressed() when stopPressed != null:
return stopPressed();case ChatRetryPressed() when retryPressed != null:
return retryPressed();case ChatModeChanged() when modeChanged != null:
return modeChanged(_that.mode);case ChatApiKeySaved() when apiKeySaved != null:
return apiKeySaved(_that.apiKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String prompt)  sendPressed,required TResult Function()  stopPressed,required TResult Function()  retryPressed,required TResult Function( ChatMode mode)  modeChanged,required TResult Function( String apiKey)  apiKeySaved,}) {final _that = this;
switch (_that) {
case ChatStarted():
return started();case ChatSendPressed():
return sendPressed(_that.prompt);case ChatStopPressed():
return stopPressed();case ChatRetryPressed():
return retryPressed();case ChatModeChanged():
return modeChanged(_that.mode);case ChatApiKeySaved():
return apiKeySaved(_that.apiKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String prompt)?  sendPressed,TResult? Function()?  stopPressed,TResult? Function()?  retryPressed,TResult? Function( ChatMode mode)?  modeChanged,TResult? Function( String apiKey)?  apiKeySaved,}) {final _that = this;
switch (_that) {
case ChatStarted() when started != null:
return started();case ChatSendPressed() when sendPressed != null:
return sendPressed(_that.prompt);case ChatStopPressed() when stopPressed != null:
return stopPressed();case ChatRetryPressed() when retryPressed != null:
return retryPressed();case ChatModeChanged() when modeChanged != null:
return modeChanged(_that.mode);case ChatApiKeySaved() when apiKeySaved != null:
return apiKeySaved(_that.apiKey);case _:
  return null;

}
}

}

/// @nodoc


class ChatStarted implements ChatEvent {
  const ChatStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.started()';
}


}




/// @nodoc


class ChatSendPressed implements ChatEvent {
  const ChatSendPressed({required this.prompt});
  

 final  String prompt;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSendPressedCopyWith<ChatSendPressed> get copyWith => _$ChatSendPressedCopyWithImpl<ChatSendPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSendPressed&&(identical(other.prompt, prompt) || other.prompt == prompt));
}


@override
int get hashCode => Object.hash(runtimeType,prompt);

@override
String toString() {
  return 'ChatEvent.sendPressed(prompt: $prompt)';
}


}

/// @nodoc
abstract mixin class $ChatSendPressedCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatSendPressedCopyWith(ChatSendPressed value, $Res Function(ChatSendPressed) _then) = _$ChatSendPressedCopyWithImpl;
@useResult
$Res call({
 String prompt
});




}
/// @nodoc
class _$ChatSendPressedCopyWithImpl<$Res>
    implements $ChatSendPressedCopyWith<$Res> {
  _$ChatSendPressedCopyWithImpl(this._self, this._then);

  final ChatSendPressed _self;
  final $Res Function(ChatSendPressed) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? prompt = null,}) {
  return _then(ChatSendPressed(
prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChatStopPressed implements ChatEvent {
  const ChatStopPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatStopPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.stopPressed()';
}


}




/// @nodoc


class ChatRetryPressed implements ChatEvent {
  const ChatRetryPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatRetryPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatEvent.retryPressed()';
}


}




/// @nodoc


class ChatModeChanged implements ChatEvent {
  const ChatModeChanged({required this.mode});
  

 final  ChatMode mode;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatModeChangedCopyWith<ChatModeChanged> get copyWith => _$ChatModeChangedCopyWithImpl<ChatModeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatModeChanged&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'ChatEvent.modeChanged(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $ChatModeChangedCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatModeChangedCopyWith(ChatModeChanged value, $Res Function(ChatModeChanged) _then) = _$ChatModeChangedCopyWithImpl;
@useResult
$Res call({
 ChatMode mode
});




}
/// @nodoc
class _$ChatModeChangedCopyWithImpl<$Res>
    implements $ChatModeChangedCopyWith<$Res> {
  _$ChatModeChangedCopyWithImpl(this._self, this._then);

  final ChatModeChanged _self;
  final $Res Function(ChatModeChanged) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(ChatModeChanged(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChatMode,
  ));
}


}

/// @nodoc


class ChatApiKeySaved implements ChatEvent {
  const ChatApiKeySaved({required this.apiKey});
  

 final  String apiKey;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatApiKeySavedCopyWith<ChatApiKeySaved> get copyWith => _$ChatApiKeySavedCopyWithImpl<ChatApiKeySaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatApiKeySaved&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}


@override
int get hashCode => Object.hash(runtimeType,apiKey);

@override
String toString() {
  return 'ChatEvent.apiKeySaved(apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class $ChatApiKeySavedCopyWith<$Res> implements $ChatEventCopyWith<$Res> {
  factory $ChatApiKeySavedCopyWith(ChatApiKeySaved value, $Res Function(ChatApiKeySaved) _then) = _$ChatApiKeySavedCopyWithImpl;
@useResult
$Res call({
 String apiKey
});




}
/// @nodoc
class _$ChatApiKeySavedCopyWithImpl<$Res>
    implements $ChatApiKeySavedCopyWith<$Res> {
  _$ChatApiKeySavedCopyWithImpl(this._self, this._then);

  final ChatApiKeySaved _self;
  final $Res Function(ChatApiKeySaved) _then;

/// Create a copy of ChatEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? apiKey = null,}) {
  return _then(ChatApiKeySaved(
apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ChatState {

 List<ChatMessageEntity> get messages; bool get isResponding; ChatMode get mode; String get apiKey;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.isResponding, isResponding) || other.isResponding == isResponding)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),isResponding,mode,apiKey);

@override
String toString() {
  return 'ChatState(messages: $messages, isResponding: $isResponding, mode: $mode, apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessageEntity> messages, bool isResponding, ChatMode mode, String apiKey
});




}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? isResponding = null,Object? mode = null,Object? apiKey = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageEntity>,isResponding: null == isResponding ? _self.isResponding : isResponding // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChatMode,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatState value)  $default,){
final _that = this;
switch (_that) {
case _ChatState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessageEntity> messages,  bool isResponding,  ChatMode mode,  String apiKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.isResponding,_that.mode,_that.apiKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessageEntity> messages,  bool isResponding,  ChatMode mode,  String apiKey)  $default,) {final _that = this;
switch (_that) {
case _ChatState():
return $default(_that.messages,_that.isResponding,_that.mode,_that.apiKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessageEntity> messages,  bool isResponding,  ChatMode mode,  String apiKey)?  $default,) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.messages,_that.isResponding,_that.mode,_that.apiKey);case _:
  return null;

}
}

}

/// @nodoc


class _ChatState extends ChatState {
  const _ChatState({final  List<ChatMessageEntity> messages = const <ChatMessageEntity>[], this.isResponding = false, this.mode = ChatMode.streaming, this.apiKey = ''}): _messages = messages,super._();
  

 final  List<ChatMessageEntity> _messages;
@override@JsonKey() List<ChatMessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool isResponding;
@override@JsonKey() final  ChatMode mode;
@override@JsonKey() final  String apiKey;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.isResponding, isResponding) || other.isResponding == isResponding)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),isResponding,mode,apiKey);

@override
String toString() {
  return 'ChatState(messages: $messages, isResponding: $isResponding, mode: $mode, apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessageEntity> messages, bool isResponding, ChatMode mode, String apiKey
});




}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? isResponding = null,Object? mode = null,Object? apiKey = null,}) {
  return _then(_ChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageEntity>,isResponding: null == isResponding ? _self.isResponding : isResponding // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChatMode,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
