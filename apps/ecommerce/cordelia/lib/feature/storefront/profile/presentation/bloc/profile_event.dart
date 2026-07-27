part of 'profile_bloc.dart';

@freezed
sealed class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = ProfileStarted;

  /// Dispatched when the Edit Profile form returns a result — replaces the
  /// loaded profile outright (unlike Address's list, there's only ever one).
  const factory ProfileEvent.saved({required ProfileEntity profile}) =
      ProfileSaved;
}
