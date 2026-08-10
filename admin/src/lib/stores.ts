import {
  collection,
  doc,
  getDoc,
  getDocs,
  type DocumentSnapshot,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { db } from "./firebase";
import { isPubliclyVisible, normalizeStoreStatus } from "./store-status";
import { mapStoreDelivery } from "./delivery";
import type { Store } from "./types";

function storesRef() {
  return collection(db, "stores");
}

function mapStoreDoc(d: QueryDocumentSnapshot | DocumentSnapshot): Store {
  // `?? {}`: DocumentSnapshot.data() is undefined for a missing doc (getStore
  // already guards with exists(), but the type doesn't know that).
  const data = d.data() ?? {};
  return {
    id: d.id,
    name: (data.name as string) ?? "",
    logoUrl: (data.logoUrl as string) ?? "",
    description: (data.description as string) ?? "",
    ownerUid: (data.ownerUid as string) ?? "",
    status: normalizeStoreStatus(data.status),
    rejectionReason: (data.rejectionReason as string) ?? "",
    previewReady: (data.previewReady as boolean | undefined) ?? false,
    searchKeywords: (data.searchKeywords as string[] | undefined) ?? [],
    templateId: (data.templateId as string) ?? "gravia",
    language: (data.language as string) ?? "en",
    currency: (data.currency as string) ?? "INR",
    delivery: mapStoreDelivery(data.delivery),
  };
}

// One-shot fetch for the storefront-discovery API route (no live listener,
// same reasoning as getCategories/getProducts). `q`, when present, matches
// case-insensitively against name or searchKeywords — a simple substring
// match, not full text search (see "Missing flow #9" in
// docs/explanation/superapp-ecommerce-plan.md — Algolia/Typesense is a
// later upgrade, this is the MVP scope).
// One-shot single-store read for the dashboard Settings page's store-profile
// prefill (stores are world-readable; writes go through PUT
// /api/stores/{storeId} so validation stays server-side).
export async function getStore(storeId: string): Promise<Store | null> {
  const snap = await getDoc(doc(db, "stores", storeId));
  return snap.exists() ? mapStoreDoc(snap) : null;
}

/// Discovery's store list.
///
/// [viewerUid] is the *verified* uid of the signed-in shopper when the
/// request carried a valid ID token, and undefined for an anonymous one. A
/// store that isn't published is returned only to the person who owns it,
/// so a store admin can open their own storefront in the real app while
/// they're still setting it up — without half-built stores reaching anyone
/// else. [superAdmin] sees every store, which is what the console's review
/// queue reads.
///
/// Preview visibility is gated on the cached `previewReady` flag rather
/// than counting subcollections here: this runs on every discovery load,
/// and an owner's empty store showing an empty storefront helps nobody.
export async function getStores(
  q?: string,
  opts: { viewerUid?: string; superAdmin?: boolean } = {},
): Promise<Store[]> {
  const snap = await getDocs(storesRef());
  const stores = snap.docs.map(mapStoreDoc).filter((s) => {
    if (opts.superAdmin) return true;
    if (isPubliclyVisible(s.status)) return true;
    return Boolean(
      opts.viewerUid && s.ownerUid === opts.viewerUid && s.previewReady,
    );
  });

  if (!q) return stores;
  const needle = q.trim().toLowerCase();
  if (!needle) return stores;

  return stores.filter(
    (s) =>
      s.name.toLowerCase().includes(needle) ||
      s.searchKeywords.some((k) => k.toLowerCase().includes(needle)),
  );
}
