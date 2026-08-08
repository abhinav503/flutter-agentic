import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';

/// `SharedPreferenceService` key for the ids of the stores this shopper has
/// opened, most-recent first. Ids only — never a serialized store: the
/// discovery list is already on screen when the rail renders, so a name or
/// logo is looked up from live data instead of going stale in a cache.
const kRecentStoreIdsPrefKey = 'recent_store_ids';

/// How many stores the rail remembers. Enough to cover a shopper's regular
/// handful without the rail turning into a second copy of the full list.
const kRecentStoresLimit = 6;

/// Reads the recent ids, newest first. Ids of stores that have since been
/// removed are harmless — the screen resolves ids against the loaded list and
/// silently drops the ones that no longer match.
List<String> readRecentStoreIds() =>
    SharedPreferenceService.instance.getStringList(kRecentStoreIdsPrefKey) ??
    const [];

/// Moves [storeId] to the front (re-opening a store promotes it rather than
/// duplicating it) and trims to [kRecentStoresLimit].
Future<List<String>> recordRecentStore(String storeId) async {
  final updated = [
    storeId,
    ...readRecentStoreIds().where((id) => id != storeId),
  ].take(kRecentStoresLimit).toList();

  await SharedPreferenceService.instance.setStringList(
    kRecentStoreIdsPrefKey,
    updated,
  );
  return updated;
}

/// Cleared on sign-out and account deletion — which stores someone shops is
/// personal, and the next account signing in on this device must not inherit
/// the previous one's rail.
Future<void> clearRecentStores() =>
    SharedPreferenceService.instance.remove(kRecentStoreIdsPrefKey);
