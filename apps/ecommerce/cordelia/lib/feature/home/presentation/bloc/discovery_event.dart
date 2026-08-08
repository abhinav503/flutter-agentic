part of 'discovery_bloc.dart';

@freezed
sealed class DiscoveryEvent with _$DiscoveryEvent {
  const factory DiscoveryEvent.started() = DiscoveryStarted;
  const factory DiscoveryEvent.queryChanged({required String query}) =
      DiscoveryQueryChanged;
  // Fired as the shopper leaves for a storefront, so the recents rail is
  // already reordered when discovery is returned to. Records the visit
  // locally — it never refetches.
  const factory DiscoveryEvent.storeOpened({required String storeId}) =
      DiscoveryStoreOpened;
}
