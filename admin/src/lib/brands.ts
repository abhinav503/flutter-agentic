import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  getDocs,
  serverTimestamp,
  type QueryDocumentSnapshot,
  type Timestamp,
  type FirestoreError,
} from "firebase/firestore";

import { watchQuery } from "./watch";
import { db } from "./firebase";
import type { Brand } from "./types";

function brandsRef(storeId: string) {
  return collection(db, "stores", storeId, "brands");
}

function mapBrandDoc(d: QueryDocumentSnapshot): Brand {
  return {
    id: d.id,
    name: (d.data().name as string) ?? "",
    logoUrl: (d.data().logoUrl as string) ?? "",
    createdAtMs:
      (d.data().createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
  };
}

export function watchBrands(
  storeId: string,
  onChange: (brands: Brand[]) => void,
  onError?: (error: FirestoreError) => void,
) {
  return watchQuery(brandsRef(storeId), (snap) => snap.docs.map(mapBrandDoc), onChange, onError);
}

// One-shot fetch (vs. watchBrands' live listener) — for server contexts
// like API routes that don't hold a subscription open.
export async function getBrands(storeId: string): Promise<Brand[]> {
  const snap = await getDocs(brandsRef(storeId));
  return snap.docs.map(mapBrandDoc);
}

export async function addBrand(
  storeId: string,
  data: Omit<Brand, "id" | "createdAtMs">,
) {
  await addDoc(brandsRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateBrand(
  storeId: string,
  id: string,
  data: Omit<Brand, "id" | "createdAtMs">,
) {
  await updateDoc(doc(db, "stores", storeId, "brands", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteBrand(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "brands", id));
}
