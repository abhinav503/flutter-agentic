// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terminal_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TerminalEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TerminalEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TerminalEvent()';
  }
}

/// @nodoc
class $TerminalEventCopyWith<$Res> {
  $TerminalEventCopyWith(TerminalEvent _, $Res Function(TerminalEvent) __);
}

/// Adds pattern-matching-related methods to [TerminalEvent].
extension TerminalEventPatterns on TerminalEvent {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TerminalConnectRequested value)? connectRequested,
    TResult Function(TerminalInputSent value)? inputSent,
    TResult Function(TerminalResized value)? resized,
    TResult Function(TerminalAgentSelected value)? agentSelected,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TerminalConnectRequested() when connectRequested != null:
        return connectRequested(_that);
      case TerminalInputSent() when inputSent != null:
        return inputSent(_that);
      case TerminalResized() when resized != null:
        return resized(_that);
      case TerminalAgentSelected() when agentSelected != null:
        return agentSelected(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TerminalConnectRequested value) connectRequested,
    required TResult Function(TerminalInputSent value) inputSent,
    required TResult Function(TerminalResized value) resized,
    required TResult Function(TerminalAgentSelected value) agentSelected,
  }) {
    final _that = this;
    switch (_that) {
      case TerminalConnectRequested():
        return connectRequested(_that);
      case TerminalInputSent():
        return inputSent(_that);
      case TerminalResized():
        return resized(_that);
      case TerminalAgentSelected():
        return agentSelected(_that);
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TerminalConnectRequested value)? connectRequested,
    TResult? Function(TerminalInputSent value)? inputSent,
    TResult? Function(TerminalResized value)? resized,
    TResult? Function(TerminalAgentSelected value)? agentSelected,
  }) {
    final _that = this;
    switch (_that) {
      case TerminalConnectRequested() when connectRequested != null:
        return connectRequested(_that);
      case TerminalInputSent() when inputSent != null:
        return inputSent(_that);
      case TerminalResized() when resized != null:
        return resized(_that);
      case TerminalAgentSelected() when agentSelected != null:
        return agentSelected(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? connectRequested,
    TResult Function(String data)? inputSent,
    TResult Function(int cols, int rows)? resized,
    TResult Function(TerminalAgent agent)? agentSelected,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TerminalConnectRequested() when connectRequested != null:
        return connectRequested();
      case TerminalInputSent() when inputSent != null:
        return inputSent(_that.data);
      case TerminalResized() when resized != null:
        return resized(_that.cols, _that.rows);
      case TerminalAgentSelected() when agentSelected != null:
        return agentSelected(_that.agent);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() connectRequested,
    required TResult Function(String data) inputSent,
    required TResult Function(int cols, int rows) resized,
    required TResult Function(TerminalAgent agent) agentSelected,
  }) {
    final _that = this;
    switch (_that) {
      case TerminalConnectRequested():
        return connectRequested();
      case TerminalInputSent():
        return inputSent(_that.data);
      case TerminalResized():
        return resized(_that.cols, _that.rows);
      case TerminalAgentSelected():
        return agentSelected(_that.agent);
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? connectRequested,
    TResult? Function(String data)? inputSent,
    TResult? Function(int cols, int rows)? resized,
    TResult? Function(TerminalAgent agent)? agentSelected,
  }) {
    final _that = this;
    switch (_that) {
      case TerminalConnectRequested() when connectRequested != null:
        return connectRequested();
      case TerminalInputSent() when inputSent != null:
        return inputSent(_that.data);
      case TerminalResized() when resized != null:
        return resized(_that.cols, _that.rows);
      case TerminalAgentSelected() when agentSelected != null:
        return agentSelected(_that.agent);
      case _:
        return null;
    }
  }
}

/// @nodoc

class TerminalConnectRequested implements TerminalEvent {
  const TerminalConnectRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TerminalConnectRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TerminalEvent.connectRequested()';
  }
}

/// @nodoc

class TerminalInputSent implements TerminalEvent {
  const TerminalInputSent(this.data);

  final String data;

  /// Create a copy of TerminalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TerminalInputSentCopyWith<TerminalInputSent> get copyWith =>
      _$TerminalInputSentCopyWithImpl<TerminalInputSent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TerminalInputSent &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  @override
  String toString() {
    return 'TerminalEvent.inputSent(data: $data)';
  }
}

/// @nodoc
abstract mixin class $TerminalInputSentCopyWith<$Res>
    implements $TerminalEventCopyWith<$Res> {
  factory $TerminalInputSentCopyWith(
          TerminalInputSent value, $Res Function(TerminalInputSent) _then) =
      _$TerminalInputSentCopyWithImpl;
  @useResult
  $Res call({String data});
}

/// @nodoc
class _$TerminalInputSentCopyWithImpl<$Res>
    implements $TerminalInputSentCopyWith<$Res> {
  _$TerminalInputSentCopyWithImpl(this._self, this._then);

  final TerminalInputSent _self;
  final $Res Function(TerminalInputSent) _then;

  /// Create a copy of TerminalEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? data = null,
  }) {
    return _then(TerminalInputSent(
      null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class TerminalResized implements TerminalEvent {
  const TerminalResized(this.cols, this.rows);

  final int cols;
  final int rows;

  /// Create a copy of TerminalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TerminalResizedCopyWith<TerminalResized> get copyWith =>
      _$TerminalResizedCopyWithImpl<TerminalResized>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TerminalResized &&
            (identical(other.cols, cols) || other.cols == cols) &&
            (identical(other.rows, rows) || other.rows == rows));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cols, rows);

  @override
  String toString() {
    return 'TerminalEvent.resized(cols: $cols, rows: $rows)';
  }
}

/// @nodoc
abstract mixin class $TerminalResizedCopyWith<$Res>
    implements $TerminalEventCopyWith<$Res> {
  factory $TerminalResizedCopyWith(
          TerminalResized value, $Res Function(TerminalResized) _then) =
      _$TerminalResizedCopyWithImpl;
  @useResult
  $Res call({int cols, int rows});
}

/// @nodoc
class _$TerminalResizedCopyWithImpl<$Res>
    implements $TerminalResizedCopyWith<$Res> {
  _$TerminalResizedCopyWithImpl(this._self, this._then);

  final TerminalResized _self;
  final $Res Function(TerminalResized) _then;

  /// Create a copy of TerminalEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cols = null,
    Object? rows = null,
  }) {
    return _then(TerminalResized(
      null == cols
          ? _self.cols
          : cols // ignore: cast_nullable_to_non_nullable
              as int,
      null == rows
          ? _self.rows
          : rows // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class TerminalAgentSelected implements TerminalEvent {
  const TerminalAgentSelected(this.agent);

  final TerminalAgent agent;

  /// Create a copy of TerminalEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TerminalAgentSelectedCopyWith<TerminalAgentSelected> get copyWith =>
      _$TerminalAgentSelectedCopyWithImpl<TerminalAgentSelected>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TerminalAgentSelected &&
            (identical(other.agent, agent) || other.agent == agent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, agent);

  @override
  String toString() {
    return 'TerminalEvent.agentSelected(agent: $agent)';
  }
}

/// @nodoc
abstract mixin class $TerminalAgentSelectedCopyWith<$Res>
    implements $TerminalEventCopyWith<$Res> {
  factory $TerminalAgentSelectedCopyWith(TerminalAgentSelected value,
          $Res Function(TerminalAgentSelected) _then) =
      _$TerminalAgentSelectedCopyWithImpl;
  @useResult
  $Res call({TerminalAgent agent});
}

/// @nodoc
class _$TerminalAgentSelectedCopyWithImpl<$Res>
    implements $TerminalAgentSelectedCopyWith<$Res> {
  _$TerminalAgentSelectedCopyWithImpl(this._self, this._then);

  final TerminalAgentSelected _self;
  final $Res Function(TerminalAgentSelected) _then;

  /// Create a copy of TerminalEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? agent = null,
  }) {
    return _then(TerminalAgentSelected(
      null == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as TerminalAgent,
    ));
  }
}

/// @nodoc
mixin _$TerminalState {
  Terminal get terminal;
  TerminalStatus get status;
  TerminalAgent get agent;
  String? get message;

  /// Create a copy of TerminalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TerminalStateCopyWith<TerminalState> get copyWith =>
      _$TerminalStateCopyWithImpl<TerminalState>(
          this as TerminalState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TerminalState &&
            (identical(other.terminal, terminal) ||
                other.terminal == terminal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, terminal, status, agent, message);

  @override
  String toString() {
    return 'TerminalState(terminal: $terminal, status: $status, agent: $agent, message: $message)';
  }
}

/// @nodoc
abstract mixin class $TerminalStateCopyWith<$Res> {
  factory $TerminalStateCopyWith(
          TerminalState value, $Res Function(TerminalState) _then) =
      _$TerminalStateCopyWithImpl;
  @useResult
  $Res call(
      {Terminal terminal,
      TerminalStatus status,
      TerminalAgent agent,
      String? message});
}

/// @nodoc
class _$TerminalStateCopyWithImpl<$Res>
    implements $TerminalStateCopyWith<$Res> {
  _$TerminalStateCopyWithImpl(this._self, this._then);

  final TerminalState _self;
  final $Res Function(TerminalState) _then;

  /// Create a copy of TerminalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terminal = null,
    Object? status = null,
    Object? agent = null,
    Object? message = freezed,
  }) {
    return _then(_self.copyWith(
      terminal: null == terminal
          ? _self.terminal
          : terminal // ignore: cast_nullable_to_non_nullable
              as Terminal,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as TerminalStatus,
      agent: null == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as TerminalAgent,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TerminalState].
extension TerminalStatePatterns on TerminalState {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TerminalState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TerminalState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TerminalState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TerminalState():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TerminalState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TerminalState() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(Terminal terminal, TerminalStatus status,
            TerminalAgent agent, String? message)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TerminalState() when $default != null:
        return $default(
            _that.terminal, _that.status, _that.agent, _that.message);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(Terminal terminal, TerminalStatus status,
            TerminalAgent agent, String? message)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TerminalState():
        return $default(
            _that.terminal, _that.status, _that.agent, _that.message);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(Terminal terminal, TerminalStatus status,
            TerminalAgent agent, String? message)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TerminalState() when $default != null:
        return $default(
            _that.terminal, _that.status, _that.agent, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TerminalState implements TerminalState {
  const _TerminalState(
      {required this.terminal,
      this.status = TerminalStatus.connecting,
      this.agent = TerminalAgent.claude,
      this.message});

  @override
  final Terminal terminal;
  @override
  @JsonKey()
  final TerminalStatus status;
  @override
  @JsonKey()
  final TerminalAgent agent;
  @override
  final String? message;

  /// Create a copy of TerminalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TerminalStateCopyWith<_TerminalState> get copyWith =>
      __$TerminalStateCopyWithImpl<_TerminalState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TerminalState &&
            (identical(other.terminal, terminal) ||
                other.terminal == terminal) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, terminal, status, agent, message);

  @override
  String toString() {
    return 'TerminalState(terminal: $terminal, status: $status, agent: $agent, message: $message)';
  }
}

/// @nodoc
abstract mixin class _$TerminalStateCopyWith<$Res>
    implements $TerminalStateCopyWith<$Res> {
  factory _$TerminalStateCopyWith(
          _TerminalState value, $Res Function(_TerminalState) _then) =
      __$TerminalStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Terminal terminal,
      TerminalStatus status,
      TerminalAgent agent,
      String? message});
}

/// @nodoc
class __$TerminalStateCopyWithImpl<$Res>
    implements _$TerminalStateCopyWith<$Res> {
  __$TerminalStateCopyWithImpl(this._self, this._then);

  final _TerminalState _self;
  final $Res Function(_TerminalState) _then;

  /// Create a copy of TerminalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? terminal = null,
    Object? status = null,
    Object? agent = null,
    Object? message = freezed,
  }) {
    return _then(_TerminalState(
      terminal: null == terminal
          ? _self.terminal
          : terminal // ignore: cast_nullable_to_non_nullable
              as Terminal,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as TerminalStatus,
      agent: null == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as TerminalAgent,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
