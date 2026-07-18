import { FieldValue } from "firebase-admin/firestore";
import { adminDb } from "./firebase-admin";
import type { CartItem } from "./types";

// Admin SDK, not the plain client SDK in firebase.ts — a per-user cart is
// not world-readable (unlike the catalog), and there's no shopper auth yet
// to satisfy firestore.rules' `isOwner(uid)` check, so writes go through
// the trusted server path instead. See docs/explanation/superapp-ecommerce-plan.md.
export function cartDocRef(uid: string, storeId: string) {
  return adminDb.collection("users").doc(uid).collection("carts").doc(storeId);
}

export async function getCartItems(
  uid: string,
  storeId: string,
): Promise<CartItem[]> {
  const snap = await cartDocRef(uid, storeId).get();
  if (!snap.exists) return [];
  return (snap.data()?.items as CartItem[] | undefined) ?? [];
}

// Whole-doc replace, not a merge — matches gravia's in-memory CartCubit,
// which always holds (and would sync) the full cart snapshot, never a diff.
export async function saveCartItems(
  uid: string,
  storeId: string,
  items: CartItem[],
): Promise<void> {
  await cartDocRef(uid, storeId).set({
    items,
    updatedAt: FieldValue.serverTimestamp(),
  });
}
