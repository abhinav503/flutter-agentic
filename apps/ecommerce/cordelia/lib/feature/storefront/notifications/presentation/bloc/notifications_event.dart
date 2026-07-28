part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsEvent with _$NotificationsEvent {
  /// [template] picks which pack's list to load. Each template's own
  /// `NotificationsPage` passes its own value, so it is a compile-time
  /// constant at every call site — including the screen's retry.
  const factory NotificationsEvent.started({
    required StorefrontTemplate template,
  }) = NotificationsStarted;
}
