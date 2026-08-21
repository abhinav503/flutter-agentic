import {
  collection,
  doc,
  getDoc,
  getDocs,
  query,
  where,
  type DocumentSnapshot,
  type Query,
  type QueryDocumentSnapshot,
  type Timestamp,
} from "firebase/firestore";
import { db } from "./firebase";
import { isPubliclyVisible, normalizeStoreStatus } from "./store-status";
import { mapStoreDelivery } from "./delivery";
import { mapStoreSupport } from "./support";
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
    address: (data.address as string) ?? "",
    ownerUid: (data.ownerUid as string) ?? "",
    status: normalizeStoreStatus(data.status),
    rejectionReason: (data.rejectionReason as string) ?? "",
    previewReady: (data.previewReady as boolean | undefined) ?? false,
    searchKeywords: (data.searchKeywords as string[] | undefined) ?? [],
    templateId: (data.templateId as string) ?? "gravia",
    language: (data.language as string) ?? "en",
    currency: (data.currency as string) ?? "INR",
    delivery: mapStoreDelivery(data.delivery),
    support: mapStoreSupport(data.support),
    createdAtMs:
      (data.createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
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
  // Ask Firestore for the rows we can actually show instead of reading the
  // collection and discarding most of it in JS. Discovery is the app's first
  // screen and every shopper loads it, while drafts are the majority of the
  // collection and grow with every owner who signs up but never publishes —
  // so an unfiltered read is the one query here whose cost tracks signups
  // rather than catalog size.
  //
  // Both filters are single-field, so Firestore's automatic indexes cover
  // them — no composite index, nothing to deploy alongside this.
  const queries: Query[] = [];

  if (opts.superAdmin) {
    // The console's review queue is the one caller that genuinely needs
    // every status, and it's a handful of admins rather than every shopper.
    queries.push(storesRef());
  } else {
    // Matches the stored string, not the normalized one — which is why
    // `"published"` has to be the only string that ever means live. A doc
    // with no `status` at all matches nothing here, which is correct:
    // normalizeStoreStatus() calls those `draft`.
    queries.push(query(storesRef(), where("status", "==", "published")));
    if (opts.viewerUid) {
      // An owner previewing their own unpublished store.
      //
      // This is deliberately a second query rather than one `or(...)`. An or()
      // of these two filters does run with no composite index — but it buys
      // nothing: an anonymous caller has no uid, so the branch below has to
      // exist either way, and the moment either form is asked to sort
      // server-side Firestore wants composite indexes — one for the plain
      // query, TWO for the or() ((status, createdAt) and (ownerUid,
      // createdAt)). Keeping them apart leaves the anonymous path — nearly
      // all discovery traffic — a single-field query.
      queries.push(
        query(storesRef(), where("ownerUid", "==", opts.viewerUid)),
      );
    }
  }

  const snaps = await Promise.all(queries.map((qy) => getDocs(qy)));

  // Deduped because an owner's own published store matches both queries.
  const byId = new Map<string, Store>();
  for (const snap of snaps) {
    for (const d of snap.docs) {
      const store = mapStoreDoc(d);
      if (
        opts.superAdmin ||
        isPubliclyVisible(store.status) ||
        (store.ownerUid === opts.viewerUid && store.previewReady)
      ) {
        byId.set(store.id, store);
      }
    }
  }

  // Newest first — a shopper opening discovery should meet the stores that
  // have just joined, and this is the opposite of the review queue's order in
  // /api/admin/stores, which is a work queue rather than a feed. Merging two
  // queries loses any order Firestore gave them, so this is also what stops
  // discovery's order depending on whether the viewer happens to own a store.
  // Done here rather than as an `orderBy` because a merge of two result sets
  // can only be ordered after the merge — see the note on the second query.
  //
  // The id tiebreaker is load-bearing, not decoration: the seeder writes
  // stores in one batch, so several docs can carry an identical
  // serverTimestamp, and without it their relative order would flip between
  // requests. It stays ascending whichever way the timestamps run — its only
  // job is to be deterministic, and docs sharing a timestamp have no
  // meaningful newest among them to honour.
  const stores = [...byId.values()].sort(
    (a, b) => b.createdAtMs - a.createdAtMs || (a.id < b.id ? -1 : 1),
  );

  if (!q) return stores;
  const needle = q.trim().toLowerCase();
  if (!needle) return stores;

  return stores.filter(
    (s) =>
      s.name.toLowerCase().includes(needle) ||
      s.searchKeywords.some((k) => k.toLowerCase().includes(needle)),
  );
}
