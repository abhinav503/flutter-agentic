part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.started() = NotificationsStarted;

  /// The shopper tapped "Enable notifications" — raises the OS dialog and,
  /// if the answer is yes, loads the feed that was behind it.
  const factory NotificationsEvent.permissionRequested() =
      NotificationsPermissionRequested;
}
