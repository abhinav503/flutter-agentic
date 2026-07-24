import {
  collection,
  getDocs,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { db } from "./firebase";
import type { Store } from "./types";

function storesRef() {
  return collection(db, "stores");
}

function mapStoreDoc(d: QueryDocumentSnapshot): Store {
  const data = d.data();
  return {
    id: d.id,
    name: (data.name as string) ?? "",
    logoUrl: (data.logoUrl as string) ?? "",
    description: (data.description as string) ?? "",
    ownerUid: (data.ownerUid as string) ?? "",
    status: (data.status as string) ?? "active",
    searchKeywords: (data.searchKeywords as string[] | undefined) ?? [],
  };
}

// One-shot fetch for the storefront-discovery API route (no live listener,
// same reasoning as getCategories/getProducts). `q`, when present, matches
// case-insensitively against name or searchKeywords — a simple substring
// match, not full text search (see "Missing flow #9" in
// docs/explanation/superapp-ecommerce-plan.md — Algolia/Typesense is a
// later upgrade, this is the MVP scope).
export async function getStores(q?: string): Promise<Store[]> {
  const snap = await getDocs(storesRef());
  const stores = snap.docs.map(mapStoreDoc).filter((s) => s.status === "active");

  if (!q) return stores;
  const needle = q.trim().toLowerCase();
  if (!needle) return stores;

  return stores.filter(
    (s) =>
      s.name.toLowerCase().includes(needle) ||
      s.searchKeywords.some((k) => k.toLowerCase().includes(needle)),
  );
}
