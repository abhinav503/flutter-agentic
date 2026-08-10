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
  // Chip row over the store list. Filters what's already loaded — no
  // refetch, since the server has already decided which stores this shopper
  // may see and the filter only narrows that.
  const factory DiscoveryEvent.filterChanged({required StoreFilter filter}) =
      DiscoveryFilterChanged;
}
