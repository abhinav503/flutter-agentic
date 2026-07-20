import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import type { RecentSearch } from "./types";

// Newest-first, deduped by (type, id), capped — enough for the Search
// screen's "Recent Search" list; older taps just age out.
const MAX_RECENT_SEARCHES = 10;

// Admin SDK for the same reason as cart.ts: per-user data with no shopper
// auth yet, so reads/writes go through the trusted server path. Mirrors the
// carts layout: users/{uid}/recentSearches/{storeId}, whole-doc replace.
function recentSearchesDocRef(uid: string, storeId: string) {
  return adminDb
    .collection("users")
    .doc(uid)
    .collection("recentSearches")
    .doc(storeId);
}

export async function getRecentSearches(
  uid: string,
  storeId: string,
): Promise<RecentSearch[]> {
  const snap = await recentSearchesDocRef(uid, storeId).get();
  if (!snap.exists) return [];
  return (snap.data()?.items as RecentSearch[] | undefined) ?? [];
}

export async function addRecentSearch(
  uid: string,
  storeId: string,
  item: RecentSearch,
): Promise<RecentSearch[]> {
  const existing = await getRecentSearches(uid, storeId);
  const items = [
    item,
    ...existing.filter((r) => !(r.type === item.type && r.id === item.id)),
  ].slice(0, MAX_RECENT_SEARCHES);
  await recentSearchesDocRef(uid, storeId).set({
    items,
    updatedAt: FieldValue.serverTimestamp(),
  });
  return items;
}

export async function removeRecentSearch(
  uid: string,
  storeId: string,
  type: RecentSearch["type"],
  id: string,
): Promise<RecentSearch[]> {
  const existing = await getRecentSearches(uid, storeId);
  const items = existing.filter((r) => !(r.type === type && r.id === id));
  await recentSearchesDocRef(uid, storeId).set({
    items,
    updatedAt: FieldValue.serverTimestamp(),
  });
  return items;
}
