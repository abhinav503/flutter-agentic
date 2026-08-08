part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded({
    required List<NotificationSectionEntity> sections,
  }) = NotificationsLoaded;

  /// The OS is not letting the app notify, so the screen offers to turn that
  /// on before it shows a centre nothing is being delivered to.
  const factory NotificationsState.permissionRequired({
    /// The OS dialog is up (or the request is in flight) — the CTA shows its
    /// loading state rather than accepting a second tap.
    @Default(false) bool requesting,

    /// The request came back denied *without* a dialog: the shopper already
    /// said no, and only the device settings can change it now. Carried on
    /// the state rather than emitted as a one-off so the screen decides how
    /// to say so — every template sends it to a snackbar.
    @Default(false) bool blocked,
  }) = NotificationsPermissionRequired;

  /// No extra retry context needed — the bloc holds the store/template it was
  /// constructed with, so retry is a parameterless re-dispatch of
  /// [NotificationsStarted].
  const factory NotificationsState.error({required String message}) =
      NotificationsError;
}
