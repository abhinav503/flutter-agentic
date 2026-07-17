import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  onSnapshot,
  getDocs,
  serverTimestamp,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
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
  };
}

export function watchCategories(
  storeId: string,
  onChange: (categories: Category[]) => void,
) {
  return onSnapshot(categoriesRef(storeId), (snap) => {
    onChange(snap.docs.map(mapCategoryDoc));
  });
}

// One-shot fetch (vs. watchCategories' live listener) — for server contexts
// like API routes that don't hold a subscription open.
export async function getCategories(storeId: string): Promise<Category[]> {
  const snap = await getDocs(categoriesRef(storeId));
  return snap.docs.map(mapCategoryDoc);
}

export async function addCategory(
  storeId: string,
  data: Omit<Category, "id">,
) {
  await addDoc(categoriesRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateCategory(
  storeId: string,
  id: string,
  data: Omit<Category, "id">,
) {
  await updateDoc(doc(db, "stores", storeId, "categories", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteCategory(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "categories", id));
}
