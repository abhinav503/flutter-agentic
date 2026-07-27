part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded({
    required List<NotificationSectionEntity> sections,
  }) = NotificationsLoaded;
  const factory NotificationsState.error({required String message}) =
      NotificationsError;
}
