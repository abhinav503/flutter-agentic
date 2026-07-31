part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded({
    required List<NotificationSectionEntity> sections,
  }) = NotificationsLoaded;
  const factory NotificationsState.error({
    required String message,

    /// Retry context — enough to re-dispatch [NotificationsStarted] without
    /// the screen reaching back into prior state.
    required StorefrontTemplate template,
  }) = NotificationsError;
}
