part of 'app_update_bloc.dart';

@freezed
sealed class AppUpdateState with _$AppUpdateState {
  const factory AppUpdateState.checking() = AppUpdateChecking;
  const factory AppUpdateState.proceed() = AppUpdateProceed;
  const factory AppUpdateState.updateRequired({
    required AppUpdateRequirementEntity requirement,
  }) = AppUpdateRequired;
}
