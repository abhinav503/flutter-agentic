import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  getCountFromServer,
  getDocs,
  serverTimestamp,
  type QueryDocumentSnapshot,
  type Timestamp,
  type FirestoreError,
} from "firebase/firestore";

import { watchQuery } from "./watch";
import { db } from "./firebase";
import type { Category } from "./types";

function categoriesRef(storeId: string) {
  return collection(db, "stores", storeId, "categories");
}

function mapCategoryDoc(d: QueryDocumentSnapshot): Category {
  return {
    id: d.id,
    name: (d.data().name as string) ?? "",
    imageUrl: (d.data().imageUrl as string) ?? "",
    groupName: (d.data().groupName as string) ?? "Uncategorized",
    createdAtMs:
      (d.data().createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
  };
}

export function watchCategories(
  storeId: string,
  onChange: (categories: Category[]) => void,
  onError?: (error: FirestoreError) => void,
) {
  return watchQuery(categoriesRef(storeId), (snap) => snap.docs.map(mapCategoryDoc), onChange, onError);
}

// One-shot fetch (vs. watchCategories' live listener) — for server contexts
// like API routes that don't hold a subscription open.
export async function getCategories(storeId: string): Promise<Category[]> {
  const snap = await getDocs(categoriesRef(storeId));
  return snap.docs.map(mapCategoryDoc);
}

// An aggregation query — one read, whatever the catalog's size. For callers
// that only need to know whether the store is empty (the seeder's
// already-has-data warning), not what is in it.
export async function countCategories(storeId: string): Promise<number> {
  const snap = await getCountFromServer(categoriesRef(storeId));
  return snap.data().count;
}

export async function addCategory(
  storeId: string,
  data: Omit<Category, "id" | "createdAtMs">,
) {
  await addDoc(categoriesRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateCategory(
  storeId: string,
  id: string,
  data: Omit<Category, "id" | "createdAtMs">,
) {
  await updateDoc(doc(db, "stores", storeId, "categories", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteCategory(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "categories", id));
}
