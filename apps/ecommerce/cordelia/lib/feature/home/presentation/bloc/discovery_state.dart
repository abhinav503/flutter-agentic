part of 'discovery_bloc.dart';

@freezed
sealed class DiscoveryState with _$DiscoveryState {
  const factory DiscoveryState.loading() = DiscoveryLoading;
  const factory DiscoveryState.loaded({
    required List<StoreEntity> stores,
    required String query,
    // The stores behind the locally-remembered recent ids, newest first,
    // resolved against [stores] so a renamed or removed store can't show a
    // stale card. Always empty while a search is active — [stores] is the
    // filtered result then, and a recents rail would be answering a question
    // the shopper didn't ask.
    required List<StoreEntity> recentStores,
    // Which segment is active. `live` — discovery opens on what a shopper
    // would see, and an owner switches to All to find their own in-progress
    // stores. Worth knowing: an owner whose stores are *all* still drafts
    // opens on an empty list plus the "no stores match" line, with the tabs
    // right above it. The tabs aren't rendered at all unless the shopper
    // owns something unpublished, so for everyone else this never moves.
    @Default(StoreFilter.live) StoreFilter filter,
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
