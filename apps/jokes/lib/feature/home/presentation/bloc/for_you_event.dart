part of 'for_you_bloc.dart';

@freezed
sealed class ForYouEvent with _$ForYouEvent {
  const factory ForYouEvent.started() = ForYouStarted;
  const factory ForYouEvent.nextRequested() = ForYouNextRequested;
}
