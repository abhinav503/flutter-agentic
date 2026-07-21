import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";

// Admin SDK for the same reason as cart.ts/recent-searches.ts: per-user data
// with no shopper auth yet. Mirrors their layout — users/{uid}/favourites/{storeId}
// — but the doc holds only product ids, not snapshots: unlike a recent
// search (a point-in-time record of what was tapped), a favourite must track
// the *live* catalog entry, so the API resolves full Product objects from
// these ids on every read rather than trusting a stored copy.
function favouritesDocRef(uid: string, storeId: string) {
  return adminDb.collection("users").doc(uid).collection("favourites").doc(storeId);
}

export async function getFavouriteIds(
  uid: string,
  storeId: string,
): Promise<string[]> {
  const snap = await favouritesDocRef(uid, storeId).get();
  if (!snap.exists) return [];
  return (snap.data()?.productIds as string[] | undefined) ?? [];
}

export async function addFavourite(
  uid: string,
  storeId: string,
  productId: string,
): Promise<string[]> {
  const existing = await getFavouriteIds(uid, storeId);
  const productIds = existing.includes(productId)
    ? existing
    : [...existing, productId];
  await favouritesDocRef(uid, storeId).set({
    productIds,
    updatedAt: FieldValue.serverTimestamp(),
  });
  return productIds;
}

export async function removeFavourite(
  uid: string,
  storeId: string,
  productId: string,
): Promise<string[]> {
  const existing = await getFavouriteIds(uid, storeId);
  const productIds = existing.filter((id) => id !== productId);
  await favouritesDocRef(uid, storeId).set({
    productIds,
    updatedAt: FieldValue.serverTimestamp(),
  });
  return productIds;
}
