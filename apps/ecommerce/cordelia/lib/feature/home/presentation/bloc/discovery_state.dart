part of 'discovery_bloc.dart';

@freezed
sealed class DiscoveryState with _$DiscoveryState {
  const factory DiscoveryState.loading() = DiscoveryLoading;
  const factory DiscoveryState.loaded({
    required List<StoreEntity> stores,
    required String query,
  }) = DiscoveryLoaded;
  // Distinct from `loaded` with an empty list so the screen can show a real
  // "no stores match" EmptyState instead of a blank list flashing between
  // loading and content.
  const factory DiscoveryState.empty({required String query}) = DiscoveryEmpty;
  const factory DiscoveryState.error({
    required String message,
    required String query,
  }) = DiscoveryError;
}
