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
import type { Brand } from "./types";

function brandsRef(storeId: string) {
  return collection(db, "stores", storeId, "brands");
}

function mapBrandDoc(d: QueryDocumentSnapshot): Brand {
  return {
    id: d.id,
    name: (d.data().name as string) ?? "",
    logoUrl: (d.data().logoUrl as string) ?? "",
  };
}

export function watchBrands(
  storeId: string,
  onChange: (brands: Brand[]) => void,
) {
  return onSnapshot(brandsRef(storeId), (snap) => {
    onChange(snap.docs.map(mapBrandDoc));
  });
}

// One-shot fetch (vs. watchBrands' live listener) — for server contexts
// like API routes that don't hold a subscription open.
export async function getBrands(storeId: string): Promise<Brand[]> {
  const snap = await getDocs(brandsRef(storeId));
  return snap.docs.map(mapBrandDoc);
}

export async function addBrand(storeId: string, data: Omit<Brand, "id">) {
  await addDoc(brandsRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateBrand(
  storeId: string,
  id: string,
  data: Omit<Brand, "id">,
) {
  await updateDoc(doc(db, "stores", storeId, "brands", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteBrand(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "brands", id));
}
