import {
  collection,
  doc,
  getCountFromServer,
  getDocs,
  getDoc,
  query,
  where,
  type QueryDocumentSnapshot,
  type Timestamp,
  type FirestoreError,
} from "firebase/firestore";

import { watchQuery } from "./watch";
import { db } from "./firebase";
import type { Product } from "./types";

function productsRef(storeId: string) {
  return collection(db, "stores", storeId, "products");
}

import {
  deriveProductSummary,
  resolveLine,
  scalePriceToSize,
  upgradeProductData,
  type ResolvedLinePricing,
} from "./product-model";

export {
  computeDiscountPercentage,
  deriveProductSummary,
  resolveLine,
  scalePriceToSize,
  upgradeProductData,
  type ResolvedLinePricing,
} from "./product-model";

// Pre-v2 entry point, kept until every line carries a variantId (cart,
// coupons, orders still select by pack size). A size the product no longer
// has degrades to the linearly-scaled price, as it always did here; the v2
// resolveLine refuses instead.
export function resolveLinePricing(
  product: Pick<
    Product,
    "price" | "originalPrice" | "unitValue" | "variants" | "stockPerVariant"
  >,
  sizeValue?: number,
): ResolvedLinePricing {
  const resolved = resolveLine(
    product,
    sizeValue && sizeValue > 0 ? { sizeValue } : {},
  );
  if (resolved) return resolved;
  return {
    price: scalePriceToSize(product.price, product.unitValue, sizeValue!),
    originalPrice: scalePriceToSize(
      product.originalPrice,
      product.unitValue,
      sizeValue!,
    ),
    packSize: sizeValue!,
    variant: null,
  };
}

function mapProductDoc(d: QueryDocumentSnapshot): Product {
  const data = d.data();
  return {
    id: d.id,
    ...upgradeProductData(data),
    createdAtMs:
      (data.createdAt as Timestamp | null | undefined)?.toMillis() ?? 0,
  };
}

export function watchProducts(
  storeId: string,
  onChange: (products: Product[]) => void,
  onError?: (error: FirestoreError) => void,
) {
  return watchQuery(productsRef(storeId), (snap) => snap.docs.map(mapProductDoc), onChange, onError);
}

// One-shot fetches for server contexts (API routes) — no live listener held open.
export async function getProducts(storeId: string): Promise<Product[]> {
  const snap = await getDocs(productsRef(storeId));
  return snap.docs.map(mapProductDoc);
}

// An aggregation query — one read, whatever the catalog's size. For callers
// that only need to know whether the store is empty (the seeder's
// already-has-data warning), not what is in it.
export async function countProducts(storeId: string): Promise<number> {
  const snap = await getCountFromServer(productsRef(storeId));
  return snap.data().count;
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

// The rating aggregates are deliberately not accepted here — they belong to
// the review transaction (Admin SDK), never the dashboard form, exactly as
// CouponInput excludes usedCount. addProduct omits them entirely so a new
// product starts unrated by absence, and mapProductDoc's defaults answer.
export type ProductInput = Omit<
  Product,
  | "id"
  | "ratingAverage"
  | "reviewCount"
  | "ratingBuckets"
  | "createdAtMs"
  | "stockPerVariant"
>;

// Re-derives the summary (price/stock/discount and the pre-v2 size shape)
// from the variants on every write, so no caller can store a product whose
// card price disagrees with what its variants charge.
export function finaliseProductInput(data: ProductInput): ProductInput {
  const images = data.images.filter((u) => u.trim() !== "");
  return {
    ...data,
    images,
    imageUrl: images[0] ?? "",
    ...deriveProductSummary(
      { price: data.price, originalPrice: data.originalPrice, stock: data.stock },
      data.variants,
    ),
  };
}



