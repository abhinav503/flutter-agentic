part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded({
    required List<NotificationSectionEntity> sections,
  }) = NotificationsLoaded;

  /// No extra retry context needed — the bloc holds the store/template it was
  /// constructed with, so retry is a parameterless re-dispatch of
  /// [NotificationsStarted].
  const factory NotificationsState.error({required String message}) =
      NotificationsError;
}
