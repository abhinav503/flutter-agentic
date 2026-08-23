part of 'app_update_bloc.dart';

@freezed
sealed class AppUpdateEvent with _$AppUpdateEvent {
  const factory AppUpdateEvent.started({required String installedVersion}) =
      AppUpdateStarted;
}
