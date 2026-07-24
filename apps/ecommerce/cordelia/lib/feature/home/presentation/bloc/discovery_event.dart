part of 'discovery_bloc.dart';

@freezed
sealed class DiscoveryEvent with _$DiscoveryEvent {
  const factory DiscoveryEvent.started() = DiscoveryStarted;
  const factory DiscoveryEvent.queryChanged({required String query}) =
      DiscoveryQueryChanged;
}
