import {
  collection,
  doc,
  addDoc,
  updateDoc,
  deleteDoc,
  onSnapshot,
  getDocs,
  getDoc,
  query,
  where,
  serverTimestamp,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { db } from "./firebase";
import type { Product, UnitType } from "./types";

function productsRef(storeId: string) {
  return collection(db, "stores", storeId, "products");
}

function mapProductDoc(d: QueryDocumentSnapshot): Product {
  const data = d.data();
  return {
    id: d.id,
    name: (data.name as string) ?? "",
    imageUrl: (data.imageUrl as string) ?? "",
    price: (data.price as number) ?? 0,
    originalPrice: (data.originalPrice as number) ?? 0,
    discountPercentage: (data.discountPercentage as number) ?? 0,
    unitValue: (data.unitValue as number) ?? 0,
    unitType: (data.unitType as UnitType) ?? "g",
    prepTime: (data.prepTime as string) ?? "",
    description: (data.description as string) ?? "",
    stock: (data.stock as number) ?? 0,
    categoryIds: (data.categoryIds as string[]) ?? [],
    sizeOptions: (data.sizeOptions as number[]) ?? [],
    isPopular: (data.isPopular as boolean) ?? false,
  };
}

// Derived, not admin-entered — keeps price/originalPrice/discountPercentage
// from ever disagreeing with each other in Firestore.
export function computeDiscountPercentage(
  price: number,
  originalPrice: number,
): number {
  if (originalPrice <= 0 || price >= originalPrice) return 0;
  return Math.round(((originalPrice - price) / originalPrice) * 100);
}

export function watchProducts(
  storeId: string,
  onChange: (products: Product[]) => void,
) {
  return onSnapshot(productsRef(storeId), (snap) => {
    onChange(snap.docs.map(mapProductDoc));
  });
}

// One-shot fetches for server contexts (API routes) — no live listener held open.
export async function getProducts(storeId: string): Promise<Product[]> {
  const snap = await getDocs(productsRef(storeId));
  return snap.docs.map(mapProductDoc);
}

export async function getPopularProducts(storeId: string): Promise<Product[]> {
  const q = query(productsRef(storeId), where("isPopular", "==", true));
  const snap = await getDocs(q);
  return snap.docs.map(mapProductDoc);
}

export async function getProductsByCategory(
  storeId: string,
  categoryId: string,
): Promise<Product[]> {
  const q = query(
    productsRef(storeId),
    where("categoryIds", "array-contains", categoryId),
  );
  const snap = await getDocs(q);
  return snap.docs.map(mapProductDoc);
}

export async function getProduct(
  storeId: string,
  productId: string,
): Promise<Product | null> {
  const snap = await getDoc(doc(db, "stores", storeId, "products", productId));
  if (!snap.exists()) return null;
  return mapProductDoc(snap as QueryDocumentSnapshot);
}

export async function addProduct(storeId: string, data: Omit<Product, "id">) {
  await addDoc(productsRef(storeId), { ...data, createdAt: serverTimestamp() });
}

export async function updateProduct(
  storeId: string,
  id: string,
  data: Omit<Product, "id">,
) {
  await updateDoc(doc(db, "stores", storeId, "products", id), {
    ...data,
    updatedAt: serverTimestamp(),
  });
}

export async function deleteProduct(storeId: string, id: string) {
  await deleteDoc(doc(db, "stores", storeId, "products", id));
}
